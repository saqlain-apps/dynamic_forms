import 'package:flutter/material.dart';

import 'multi_child_offset_view.dart';

class AnimatedOffsetView extends ImplicitlyAnimatedWidget {
  static Offset alignmentToOffset(Alignment alignment) =>
      Offset(alignment.x, alignment.y);

  const AnimatedOffsetView({
    required this.children,
    this.index = 0,
    this.direction = const Offset(1, 0),
    super.duration = const Duration(milliseconds: 300),
    super.key,
  });

  final int index;
  final Offset direction;
  final List<Widget> children;

  @override
  ImplicitlyAnimatedWidgetState<AnimatedOffsetView> createState() =>
      _ScrollAnimatedViewState();
}

class _ScrollAnimatedViewState
    extends ImplicitlyAnimatedWidgetState<AnimatedOffsetView> {
  Tween<double>? _index;
  late Animation<double> _indexAnimation;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _index = visitor(
      _index, // Reference of Value
      widget.index.toDouble(), // New Value
      (dynamic value) => Tween<double>(begin: value as double), // Tween Builder
    ) as Tween<double>?;
  }

  @override
  void didUpdateTweens() {
    _indexAnimation = animation.drive(_index!);
  }

  @override
  Widget build(BuildContext context) {
    return MultiChildOffsetView(
      delegate: MultiChildAnimatedOffsetViewDelegate(
        indexAnimation: _indexAnimation,
        direction: widget.direction,
      ),
      children: widget.children,
    );
  }
}
