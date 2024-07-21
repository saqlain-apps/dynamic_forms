import 'package:dynamic_form/_libraries/extensions.dart';
import 'package:flutter/material.dart';

class PrototypeItem extends StatelessWidget {
  factory PrototypeItem.axis({
    required Widget prototype,
    required Widget child,
    required Axis direction,
  }) {
    return PrototypeItem(
      prototype: prototype,
      child: Flex(
        direction: direction,
        children: [Expanded(child: child)],
      ),
    );
  }

  const PrototypeItem({
    required this.prototype,
    required this.child,
    super.key,
  });

  final Widget prototype;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ConstraintsTransformBox(
      constraintsTransform: (constraints) => constraints.expandBelowInfinity(),
      child: Stack(
        children: [
          Visibility(
            visible: false,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: prototype,
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}
