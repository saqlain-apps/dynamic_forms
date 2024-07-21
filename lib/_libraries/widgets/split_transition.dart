import 'package:flutter/material.dart';

import '../animatables/animation_transformers.dart';
import '../animatables/transform_curve.dart';

class SplitTransition extends CustomSplitTransition {
  const SplitTransition({
    required super.animation,
    required super.builder,
    super.splitPoint = 0.5,
    super.transitionBuilder = defaultTransition,
    super.key,
  })  : assert(splitPoint < 1 && splitPoint >= 0),
        super(max: 1, min: 0);

  static Widget defaultTransition(Widget child, Animation<double> animation) =>
      FadeTransition(opacity: animation, child: child);
}

class CustomSplitTransition extends StatelessWidget {
  const CustomSplitTransition({
    required this.animation,
    required this.builder,
    required this.splitPoint,
    required this.max,
    required this.min,
    required this.transitionBuilder,
    super.key,
  });

  final double max;
  final double min;

  final double splitPoint;
  final Animation<double> animation;

  final Widget Function(
    BuildContext context,
    bool isForward,
  ) builder;

  final Widget Function(
    Widget child,
    Animation<double> animation,
  ) transitionBuilder;

  @override
  Widget build(BuildContext context) {
    return transitionBuilder(
      builder(context, animation.value < splitPoint),
      TransformedAnimation(
        parent: animation,
        transformer: AnimationTransformers.customRebound(
          splitPoint,
          min,
          max,
        ),
      ),
    );
  }
}
