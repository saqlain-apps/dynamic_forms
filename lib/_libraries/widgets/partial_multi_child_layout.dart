import 'package:flutter/material.dart';

import '../../user_interface/render_components/empty/empty.dart';

class PartialChild {
  const PartialChild({
    required this.size,
    required this.child,
  });

  final double size;
  final Widget child;
}

class PartialMultiChildLayout extends StatelessWidget {
  const PartialMultiChildLayout({
    required this.sizeCalculator,
    required this.builder,
    required this.children,
    this.offstageInvisibleChildren = true,
    this.overheadSize = 0,
    super.key,
  });

  final double overheadSize;
  final bool offstageInvisibleChildren;
  final double Function(BoxConstraints constraints) sizeCalculator;
  final Widget Function(BuildContext context, List<Widget> children) builder;
  final List<PartialChild> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var size = sizeCalculator(constraints);
        if (size >= overheadSize) {
          return builder(
            context,
            _buildConstrainedList(
              size - overheadSize,
              children,
              offstageInvisibleChildren,
            ),
          );
        } else {
          return nothing;
        }
      },
    );
  }

  List<Widget> _buildConstrainedList(
    double space,
    List<PartialChild> children, [
    bool offstage = true,
  ]) {
    List<Widget> visibleChildren = [];
    List<Widget> invisibleChildren = [];

    for (var childDetails in children) {
      if (childDetails.size <= space) {
        visibleChildren.add(childDetails.child);
        space -= childDetails.size;
      } else {
        invisibleChildren.add(childDetails.child);
      }
    }

    if (offstage) {
      visibleChildren.addAll(invisibleChildren.map((e) => Offstage(child: e)));
    }

    return visibleChildren;
  }
}
