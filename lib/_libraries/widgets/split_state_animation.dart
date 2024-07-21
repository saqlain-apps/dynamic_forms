import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../animatables/animation_transformers.dart';
import '../animatables/transform_curve.dart';
import 'animated_double.dart';

mixin SplitStateAnimation<T extends Enum> {
  SplitStateController<T> get controller;
  Duration get duration;

  double animatedValue(
    double animation, {
    required double initialValue,
    required double finalValue,
  }) =>
      initialValue + animation * (finalValue - initialValue);

  Widget buildView(
    BuildContext context,
    Animation<double> animation,
  );

  Widget build(BuildContext context) {
    return _buildAnimation(
      animation: controller._state,
      builder: (animation) => buildView(context, animation),
    );
  }

  Widget _buildAnimation({
    required ValueListenable<num> animation,
    required Widget Function(Animation<double> animation) builder,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, __) {
        return AnimatedDouble(
          value: animation.value.toDouble(),
          duration: duration,
          builder: (_, __, animation, ___, ____) {
            return builder(animation);
          },
        );
      },
    );
  }
}

abstract class SplitStateController<T> {
  List<T> get states;
  num computePosition(T state);
  num get initial;

  late final ValueNotifier<num> _state = ValueNotifier(initial);
  Listenable get notifer => _state;

  bool isState(T state) => _state.value == computePosition(state);
  void update(T state) => _state.value = computePosition(state);

  AnimationTransformer _split(T previous, T position) {
    var min = computePosition(previous).toDouble();
    var max = computePosition(position).toDouble();

    var transform = AnimationTransformers.combineTransformers([
      AnimationTransformers.spatialSplit(min, max),
      AnimationTransformers.normalize(min, max),
    ]);

    return transform;
  }

  double animationValue(
    double value, {
    required T position,
    required T previous,
  }) {
    return _split(previous, position)(value);
  }

  Animation<double> animation(
    Animation<double> animation, {
    required T position,
    required T previous,
  }) {
    return TransformedAnimation(
      parent: animation,
      transformer: _split(previous, position),
    );
  }

  void dispose() => _state.dispose();
}
