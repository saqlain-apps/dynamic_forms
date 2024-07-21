import 'package:flutter/material.dart';

import 'animation_transformers.dart';

class TransformCurve extends Curve {
  const TransformCurve(this.transformer);
  final AnimationTransformer transformer;

  @override
  double transformInternal(double t) => transformer(t);
}

class TransformedAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  const TransformedAnimation({
    required this.parent,
    required this.transformer,
  });

  final AnimationTransformer transformer;

  @override
  double get value => transformer(parent.value);

  @override
  final Animation<double> parent;
}
