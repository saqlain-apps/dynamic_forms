import 'package:flutter/material.dart';

class AnimatedValue<T> extends ImplicitlyAnimatedWidget {
  const AnimatedValue({
    required this.value,
    required this.tweenBuilder,
    required this.builder,
    required super.duration,
    this.child,
    super.curve,
    super.onEnd,
    super.key,
  });

  final T value;

  final Widget Function(
    BuildContext context,
    T value,
    Animation<T> animation,
    Animation<double> controller,
    Widget? child,
  ) builder;

  final Tween<T> Function({T? begin, T? end}) tweenBuilder;

  final Widget? child;

  @override
  AnimatedWidgetBaseState<AnimatedValue<T>> createState() =>
      _AnimatedValueState<T>();
}

class _AnimatedValueState<T> extends AnimatedWidgetBaseState<AnimatedValue<T>> {
  Tween<T>? _value;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _value = visitor(
      _value,
      widget.value,
      (dynamic value) => widget.tweenBuilder(begin: value as T),
    ) as Tween<T>?;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _value!.evaluate(animation),
      _value!.animate(animation),
      animation,
      widget.child,
    );
  }
}
