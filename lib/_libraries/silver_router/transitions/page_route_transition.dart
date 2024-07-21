import 'package:flutter/material.dart';

abstract class PageRouteTransition extends StatelessWidget {
  const PageRouteTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
    super.key,
  });

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;
}
