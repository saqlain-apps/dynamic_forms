import 'dart:async';

part 'future_stream.dart';

/// Must Call Dispose\
/// Only Broadcast Streams
class StateStream<T> extends Stream<T> {
  T? _value;
  final Stream<T> _stream;
  StreamSubscription<T>? _observerStream;

  T? get value => _value;
  Stream<T> get stream => _stream;

  StateStream({
    T? initialValue,
    required Stream<T> stream,
  })  : _stream = stream.makeBroadcast(),
        _value = initialValue {
    observe();
  }

  StateStream.unobserved({
    T? initialValue,
    required Stream<T> stream,
  })  : _stream = stream.makeBroadcast(),
        _value = initialValue;

  void observe() {
    _observerStream ??= _stream.listen(
      (event) {
        _value = event;
      },
      onDone: dispose,
    );
  }

  void dispose() {
    _observerStream?.cancel();
    _observerStream = null;
  }

  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError,
      );
}

extension ExtendedStream<T> on Stream<T> {
  Stream<T> makeBroadcast() {
    assert(() {
      return true;
    }());
    return isBroadcast ? this : asBroadcastStream();
  }
}
