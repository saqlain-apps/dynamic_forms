import 'dart:async';

/// Must Call Dispose
class StateStreamController<T> implements EventSink<T> {
  StateStreamController({
    required T initialValue,
    void Function()? onListen,
    void Function()? onPause,
    void Function()? onResume,
    FutureOr<void> Function()? onCancel,
    bool sync = false,
  })  : _value = initialValue,
        _controller = StreamController<T>(
          onListen: onListen,
          onPause: onPause,
          onResume: onResume,
          onCancel: onCancel,
          sync: sync,
        );

  StateStreamController.broadcast({
    required T initialValue,
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  })  : _value = initialValue,
        _controller = StreamController<T>.broadcast(
          onListen: onListen,
          onCancel: onCancel,
          sync: sync,
        );

  final StreamController<T> _controller;

  T _value;
  T get value => _value;

  Stream<T> get stream => _controller.stream;
  Sink<T> get sink => this;

  bool get isClosed => _controller.isClosed;
  bool get isPaused => _controller.isPaused;
  bool get hasListener => _controller.hasListener;
  Future get done => _controller.done;

  @override
  void add(T data) {
    _value = data;
    _controller.add(data);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    _controller.addError(error, stackTrace);
  }

  @override
  void close() {
    _controller.close();
  }
}
