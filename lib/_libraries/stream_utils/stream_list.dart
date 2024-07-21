import 'dart:async';

class StreamList<T> implements Sink<Stream<T>> {
  /// The stream through which all events from streams in the list are emitted.
  Stream<List<T?>> get stream => _controller.stream;
  late StreamController<List<T?>> _controller;

  final _value = <Stream<T>, T?>{};
  List<T?> get value => _value.values.toList();

  bool get isClosed => _closed;
  var _closed = false;
  var _state = _StreamListState.dormant;

  /// Whether this list contains no streams.
  ///
  /// A [StreamList] is idle when it contains no streams, which is the case for
  /// a newly created list or one where all added streams have been emitted
  /// done events (or been [remove]d).
  ///
  /// If this is a single-subscription list, then cancelling the subscription
  /// to [stream] will also remove all streams.
  bool get isIdle => _subscriptions.isEmpty;

  /// A broadcast stream that emits an event whenever this list becomes idle.
  ///
  /// A [StreamList] is idle when it contains no streams, which is the case for
  /// a newly created list or one where all added streams have been emitted
  /// done events (or been [remove]d).
  ///
  /// This stream will close when either:
  ///
  /// * This list is idle *and* [close] has been called, or
  /// * [stream]'s subscription has been cancelled (if this is a
  ///   single-subscription list).
  ///
  /// Note that:
  ///
  /// * Events won't be emitted on this stream until [stream] has been listened
  ///   to.
  /// * Events are delivered asynchronously, so it's possible for the list to
  ///   become active again before the event is delivered.
  Stream<void> get onIdle =>
      (_onIdleController ??= StreamController.broadcast()).stream;

  StreamController<void>? _onIdleController;

  /// Streams that have been added to the list, and their subscriptions if they
  /// have been subscribed to.
  ///
  /// The subscriptions will be null until the list has a listener registered.
  /// If it's a broadcast list and it goes dormant again, broadcast stream
  /// subscriptions will be canceled and set to null again. Single-subscriber
  /// stream subscriptions will be left intact, since they can't be
  /// re-subscribed.
  final _subscriptions = <Stream<T>, StreamSubscription<T>?>{};

  /// Merges the events from [streams] into a single single-subscription stream.
  ///
  /// This is equivalent to adding [streams] to a list, closing that list, and
  /// returning its stream.
  static Stream<List<T?>> merge<T>(Iterable<Stream<T>> streams) {
    var list = StreamList<T>();
    streams.forEach(list.add);
    list.close();
    return list.stream;
  }

  /// Merges the events from [streams] into a single broadcast stream.
  ///
  /// This is equivalent to adding [streams] to a broadcast list, closing that
  /// list, and returning its stream.
  static Stream<List<T?>> mergeBroadcast<T>(Iterable<Stream<T>> streams) {
    var list = StreamList<T>.broadcast();
    streams.forEach(list.add);
    list.close();
    return list.stream;
  }

  /// Creates a new stream list where [stream] is single-subscriber.
  StreamList() {
    _controller = StreamController(
      onListen: _onListen,
      onPause: _onPause,
      onResume: _onResume,
      onCancel: _onCancel,
      sync: true,
    );
  }

  /// Creates a new stream list where [stream] is a broadcast stream.
  StreamList.broadcast() {
    _controller = StreamController.broadcast(
      onListen: _onListen,
      onCancel: _onCancelBroadcast,
      sync: true,
    );
  }

  /// Adds [stream] as a member of this list.
  ///
  /// Any events from [stream] will be emitted through [this.stream]. If this
  /// list has a listener, [stream] will be listened to immediately; otherwise
  /// it will only be listened to once this list gets a listener.
  ///
  /// If this is a single-subscription list and its subscription has been
  /// canceled, [stream] will be canceled as soon as its added. If this returns
  /// a [Future], it will be returned from [add]. Otherwise, [add] returns
  /// `null`.
  ///
  /// Throws a [StateError] if this list is closed.
  @override
  Future<void>? add(Stream<T> stream) {
    if (_closed) {
      throw StateError("Can't add a Stream to a closed StreamList.");
    }

    if (_state == _StreamListState.dormant) {
      _subscriptions.putIfAbsent(stream, () => null);
    } else if (_state == _StreamListState.canceled) {
      // Listen to the stream and cancel it immediately so that no one else can
      // listen, for consistency. If the stream has an onCancel listener this
      // will also fire that, which may help it clean up resources.
      return stream.listen(null).cancel();
    } else {
      _subscriptions.putIfAbsent(stream, () => _listenToStream(stream));
    }

    return null;
  }

  /// Removes [stream] as a member of this list.
  ///
  /// No further events from [stream] will be emitted through this list. If
  /// [stream] has been listened to, its subscription will be canceled.
  ///
  /// If [stream] has been listened to, this *synchronously* cancels its
  /// subscription. This means that any events from [stream] that haven't yet
  /// been emitted through this list will not be.
  ///
  /// If [stream]'s subscription is canceled, this returns
  /// [StreamSubscription.cancel]'s return value. Otherwise, it returns `null`.
  Future<void>? remove(Stream<T> stream) {
    var subscription = _subscriptions.remove(stream);
    _value.remove(stream);
    var future = subscription?.cancel();

    if (_subscriptions.isEmpty) {
      _onIdleController?.add(null);
      if (_closed) {
        _onIdleController?.close();
        scheduleMicrotask(_controller.close);
      }
    }

    return future;
  }

  /// A callback called when [stream] is listened to.
  ///
  /// This is called for both single-subscription and broadcast lists.
  void _onListen() {
    _state = _StreamListState.listening;

    for (var entry in _subscriptions.entries) {
      // If this is a broadcast list and this isn't the first time it's been
      // listened to, there may still be some subscriptions to
      // single-subscription streams.
      if (entry.value != null) continue;

      var stream = entry.key;
      try {
        _subscriptions[stream] = _listenToStream(stream);
      } catch (error) {
        // If [Stream.listen] throws a synchronous error (for example because
        // the stream has already been listened to), cancel all subscriptions
        // and rethrow the error.
        _onCancel()?.catchError((_) {});
        rethrow;
      }
    }
  }

  /// Starts actively forwarding events from [stream] to [_controller].
  ///
  /// This will pause the resulting subscription if `this` is paused.
  StreamSubscription<T> _listenToStream(Stream<T> stream) {
    _value.putIfAbsent(stream, () => null);
    var subscription = stream.listen(
      (T data) {
        _value[stream] = data;
        _controller.add(value);
      },
      onError: _controller.addError,
      onDone: () => remove(stream),
    );

    if (_state == _StreamListState.paused) subscription.pause();
    return subscription;
  }

  /// A callback called when [stream] is paused.
  void _onPause() {
    _state = _StreamListState.paused;
    for (var subscription in _subscriptions.values) {
      subscription!.pause();
    }
  }

  /// A callback called when [stream] is resumed.
  void _onResume() {
    _state = _StreamListState.listening;
    for (var subscription in _subscriptions.values) {
      subscription!.resume();
    }
  }

  /// A callback called when [stream] is canceled.
  ///
  /// This is only called for single-subscription lists.
  Future<void>? _onCancel() {
    _state = _StreamListState.canceled;

    var futures = _subscriptions.entries
        .map((entry) {
          var subscription = entry.value;
          try {
            if (subscription != null) return subscription.cancel();
            return entry.key.listen(null).cancel();
          } catch (_) {
            return null;
          }
        })
        .whereNotNull
        .toList();

    _subscriptions.clear();

    var onIdleController = _onIdleController;
    if (onIdleController != null && !onIdleController.isClosed) {
      onIdleController.add(null);
      onIdleController.close();
    }

    return futures.isEmpty ? null : Future.wait(futures);
  }

  /// A callback called when [stream]'s last listener is canceled.
  ///
  /// This is only called for broadcast lists.
  void _onCancelBroadcast() {
    _state = _StreamListState.dormant;

    _subscriptions.forEach((stream, subscription) {
      // Cancel the broadcast streams, since we can re-listen to those later,
      // but allow the single-subscription streams to keep firing. Their events
      // will still be added to [_controller], but then they'll be dropped since
      // it has no listeners.
      if (!stream.isBroadcast) return;
      subscription!.cancel();
      _subscriptions[stream] = null;
    });
  }

  /// Closes the list, indicating that no more streams will be added.
  ///
  /// If there are no streams in the list, [stream] is closed immediately.
  /// Otherwise, [stream] will close once all streams in the list close.
  ///
  /// Returns a [Future] that completes once [stream] has actually been closed.
  @override
  Future<void> close() {
    if (_closed) return _controller.done;

    _closed = true;
    if (_subscriptions.isEmpty) _controller.close();

    return _controller.done;
  }
}

enum _StreamListState { dormant, listening, paused, canceled }

extension _ExtendedNullIterable<T> on Iterable<T?> {
  Iterable<T> get whereNotNull sync* {
    for (var element in this) {
      if (element != null) yield element;
    }
  }
}
