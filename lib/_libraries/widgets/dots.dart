import 'package:flutter/material.dart';

import '../../user_interface/render_components/gap/gap.dart';
import '../separator_builder.dart';

class Dots extends StatelessWidget {
  static const int defaultDots = 3;

  /// All Dots Inactive
  Dots.disabled({
    this.totalDots = defaultDots,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.white,
    super.key,
  })  : previousIndex = double.maxFinite.toInt(),
        nextIndex = double.maxFinite.toInt(),
        progressFactor = 0;

  /// Index Starts from 0
  ///
  /// if [index] is too big, it is rounded by mod Function\
  /// Use this to make infinite scrollable
  const Dots.static({
    int index = 0,
    this.totalDots = defaultDots,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.white,
    super.key,
  })  : previousIndex = index % totalDots,
        nextIndex = index % totalDots,
        progressFactor = 0;

  /// [previousIndex] to mark the dot
  /// which needs to transition from active to inactive
  ///
  /// [nextIndex] to mark the dot
  /// which needs to transition from inactive to active
  ///
  /// [progressFactor] for the transition value\
  /// It tells How much transition has progressed\
  /// It goes from 0.0 to 1.0
  const Dots.animated({
    required int previousIndex,
    required int nextIndex,
    required this.progressFactor,
    this.totalDots = defaultDots,
    this.activeColor = Colors.red,
    this.inactiveColor = Colors.white,
    super.key,
  })  : previousIndex = previousIndex % totalDots,
        nextIndex = nextIndex % totalDots;

  final int previousIndex;
  final int nextIndex;
  final double progressFactor;
  final int totalDots;

  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: SeparatorBuilder<int, Widget>(
        originalList: Iterable<int>.generate(totalDots).toList(),
        separatorBuilder: (index) => const Gap(5),
        itemBuilder: (index, itemData) => buildDot(itemData),
      ).separatedList,
    );
  }

  Widget buildDot(int index) {
    double activeFactor = previousIndex == nextIndex ? 0 : progressFactor;

    return _Dot(
      activeFactor: switch (index) {
        _ when (index == previousIndex) => 1 - activeFactor,
        _ when (index == nextIndex) => activeFactor,
        _ => 0,
      },
      activeColor: activeColor,
      inactiveColor: inactiveColor,
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    this.activeFactor = 0,
    required this.activeColor,
    required this.inactiveColor,
    // ignore: unused_element
    super.key,
  });

  final double activeFactor;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    final colorTween = ColorTween(begin: inactiveColor, end: activeColor);

    return Container(
      height: 8,
      width: 8 + (activeFactor * 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorTween.transform(activeFactor),
      ),
    );
  }
}
