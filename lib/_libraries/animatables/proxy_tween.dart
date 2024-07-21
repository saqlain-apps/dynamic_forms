import 'package:flutter/material.dart';

class ProxyTween<T> extends Tween<T> {
  ProxyTween({required this.beginTween, required this.endTween});

  final Tween<T> beginTween;
  final Tween<T> endTween;

  @override
  T lerp(double t) {
    begin = beginTween.transform(t);
    end = endTween.transform(t);
    return super.lerp(t);
  }
}
