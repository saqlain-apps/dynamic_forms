import 'package:flutter/material.dart';

class SliverSizedBox extends StatelessWidget {
  const SliverSizedBox({
    this.height,
    this.width,
    this.child,
    super.key,
  });

  const SliverSizedBox.square({super.key, this.child, double? dimension})
      : width = dimension,
        height = dimension;

  final double? height;
  final double? width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: height,
        width: width,
        child: child,
      ),
    );
  }
}
