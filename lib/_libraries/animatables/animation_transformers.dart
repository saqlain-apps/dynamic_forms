import 'package:flutter/foundation.dart';

typedef AnimationTransformer = double Function(double value);

abstract class AnimationTransformers {
  static AnimationTransformer combineTransformers(
    List<AnimationTransformer> transformers,
  ) {
    double transform(double value) {
      return transformers.fold(value, (p, t) => t(p));
    }

    return transform;
  }

  static AnimationTransformer customRebound(
    double split,
    double min,
    double max,
  ) {
    assert(min < max);
    assert(split > min && split < max);
    double transform(double value) {
      bool isForward = value < split;
      var distance = max - min;

      double forward() {
        var forwardDistance = split - min;
        var forwardDisplacementValue = value / forwardDistance;
        var forwardDisplacement = forwardDisplacementValue * distance;
        var forward = max - forwardDisplacement;
        return forward;
      }

      double reverse() {
        var reverseDistance = max - split;
        var reverseDisplacementValue = (value - split) / reverseDistance;
        var reverseDisplacement = reverseDisplacementValue * distance;
        var reverse = min + reverseDisplacement;
        return reverse;
      }

      var result = isForward ? forward() : reverse();
      return result;
    }

    return transform;
  }

  static AnimationTransformer rebound(double split) =>
      customRebound(split, 0, 1);

  static AnimationTransformer spatialSplit(double min, double max) {
    double transform(double value) {
      return clampDouble(value, min, max);
    }

    return transform;
  }

  static AnimationTransformer normalize(double min, double max) {
    double transform(double value) {
      return clampDouble((value - min) / (max - min), 0.0, 1.0);
    }

    return transform;
  }

  static AnimationTransformer animate(double min, double max) {
    double transform(double value) {
      return min + value * (max - min);
    }

    return transform;
  }
}
