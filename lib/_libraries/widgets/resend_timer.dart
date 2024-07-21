import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResendTimer extends StatefulWidget {
  const ResendTimer({
    required this.duration,
    required this.builder,
    this.controller,
    super.key,
  });

  final Duration duration;
  final ResendTimerController? controller;
  final Widget Function(
    BuildContext context,
    Duration timeRemaining,
    String timer,
  ) builder;

  @override
  State<ResendTimer> createState() => _ResendTimerState();

  static String resendTime(Duration timeRemaining) {
    String pad(int number) => number.toString().padLeft(2, '0');

    var min = timeRemaining.inMinutes;
    var sec = timeRemaining.inSeconds - (min * 60);

    var timerString = '${pad(min)}:${pad(sec)}';
    return timerString;
  }
}

class _ResendTimerState extends State<ResendTimer>
    with SingleTickerProviderStateMixin {
  ResendTimerController get _controller => __controller!;
  ResendTimerController? __controller;

  @override
  void initState() {
    super.initState();

    __controller = widget.controller ?? ResendTimerController();
    _init();
  }

  @override
  void didUpdateWidget(covariant ResendTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _controller._reset(duration: widget.duration, value: 0);
    }

    if (widget.controller != oldWidget.controller &&
        widget.controller != null) {
      __controller?.__controller?.dispose();
      __controller = widget.controller;
      _init();
    }
  }

  void _init() {
    _controller._init(this);
    _controller._reset(duration: widget.duration, value: 0);
  }

  @override
  void dispose() {
    __controller?._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller._controller,
      builder: (context, child) {
        return widget.builder(
          context,
          _controller.timeRemaining.value,
          ResendTimer.resendTime(_controller.timeRemaining.value),
        );
      },
    );
  }
}

class ResendTimerController {
  ValueListenable<int> get secondsRemaining =>
      _secondsTween!.animate(_controller);

  ValueListenable<Duration> get timeRemaining =>
      _durationTween!.animate(_controller);

  AnimationController get _controller => __controller!;
  AnimationController? __controller;
  IntTween? _secondsTween;
  Tween<Duration>? _durationTween;

  void restart() {
    _reset(value: 0);
  }

  void complete() {
    _reset(value: 1);
  }

  void _init(TickerProvider vsync) {
    __controller?.dispose();
    __controller = AnimationController(vsync: vsync);
  }

  void _reset({double? value, Duration? duration}) {
    if (__controller == null) return;
    _controller.duration = duration ?? _controller.duration;
    _secondsTween = IntTween(begin: _controller.duration!.inSeconds, end: 0);
    _durationTween =
        Tween<Duration>(begin: _controller.duration!, end: Duration.zero);
    _controller.value = value ?? _controller.value;
    _controller.forward();
  }

  void _dispose() {
    __controller?.dispose();
    __controller = null;
  }
}
