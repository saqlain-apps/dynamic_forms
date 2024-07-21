import 'dart:async';

class CallCounter {
  CallCounter({
    required this.calls,
    required this.resetDuration,
    required this.callback,
    this.nonCallback,
  }) : assert(calls > 1);

  final int calls;
  final Duration resetDuration;
  final void Function() callback;
  final void Function()? nonCallback;

  int _callCount = 0;
  Timer? _timer;

  void call() {
    _callCount++;

    if (_callCount >= calls) {
      callback();
      _reset();
    } else {
      nonCallback?.call();
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(resetDuration, () {
      _callCount = 0;
    });
  }

  void _reset() {
    _callCount = 0;
    _timer?.cancel();
  }
}
