import 'package:flutter/material.dart';

import 'animated_value.dart';

class AnimatedDouble extends AnimatedValue<double> {
  const AnimatedDouble({
    super.value = 0,
    required super.duration,
    required super.builder,
    super.child,
    super.curve,
    super.onEnd,
    super.key,
  }) : super(tweenBuilder: _tweenBuilder);

  static Tween<double> _tweenBuilder({double? begin, double? end}) =>
      Tween<double>(begin: begin, end: end);
}
