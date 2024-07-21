import 'package:flutter/material.dart';

class MultiChildOffsetView extends StatelessWidget {
  factory MultiChildOffsetView.indexed({
    required double index,
    required List<Widget> children,
  }) {
    return MultiChildOffsetView(
      delegate: MultiChildOffsetDelegate.indexed(index: index),
      children: children,
    );
  }

  factory MultiChildOffsetView.animated({
    required Animation<double> index,
    required List<Widget> children,
  }) {
    return MultiChildOffsetView(
      delegate: MultiChildOffsetDelegate.animated(indexAnimation: index),
      children: children,
    );
  }

  const MultiChildOffsetView({
    required this.delegate,
    required this.children,
    super.key,
  });

  final MultiChildOffsetDelegate delegate;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: delegate,
      children: children,
    );
  }
}

class MultiChildOffsetViewDelegate extends MultiChildOffsetDelegate {
  const MultiChildOffsetViewDelegate({
    required this.index,
    required super.direction,
    super.resize,
  }) : super._internal();

  @override
  final double index;

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => false;
}

class MultiChildAnimatedOffsetViewDelegate extends MultiChildOffsetDelegate {
  const MultiChildAnimatedOffsetViewDelegate({
    required this.indexAnimation,
    required super.direction,
    super.resize,
  }) : super._internal(repaint: indexAnimation);

  final Animation<double> indexAnimation;

  @override
  double get index => indexAnimation.value;

  @override
  bool shouldRepaint(
          covariant MultiChildAnimatedOffsetViewDelegate oldDelegate) =>
      indexAnimation != oldDelegate.indexAnimation;
}

abstract class MultiChildOffsetDelegate extends FlowDelegate {
  factory MultiChildOffsetDelegate.indexed({
    required double index,
    Offset direction = const Offset(1, 0),
  }) {
    return MultiChildOffsetViewDelegate(index: index, direction: direction);
  }

  factory MultiChildOffsetDelegate.animated({
    required Animation<double> indexAnimation,
    Offset direction = const Offset(1, 0),
  }) {
    return MultiChildAnimatedOffsetViewDelegate(
      indexAnimation: indexAnimation,
      direction: direction,
    );
  }

  const MultiChildOffsetDelegate._internal({
    this.direction = const Offset(1, 0),
    this.resize,
    super.repaint,
  });

  final Size Function(BoxConstraints constraints)? resize;
  final Offset direction;
  double get index;

  @override
  void paintChildren(FlowPaintingContext context) {
    var childCount = context.childCount;

    if (childCount == 1) {
      context.paintChild(0, transform: Matrix4.identity());
    } else if (index < 0 || index.ceil() >= childCount) {
      return;
    }

    Size getIndexSize(num index) {
      int lowerToInt(num value) =>
          value is double ? value.floor() : value.toInt() - 1;

      int xIndex =
          direction.dx.sign.isNegative ? index.ceil() : lowerToInt(index);
      int yIndex =
          direction.dy.sign.isNegative ? index.ceil() : lowerToInt(index);

      return Size(
        context.getChildSize(xIndex)!.width,
        context.getChildSize(yIndex)!.height,
      );
    }

    Offset transformOffset = Offset.zero;
    var tIndex = index.truncate();
    while (tIndex > 0) {
      var currentSize = getIndexSize(tIndex--);
      transformOffset += sizeToOffset(currentSize);
    }
    var nextSize = (getIndexSize(index)) * index.fraction;
    transformOffset += sizeToOffset(nextSize);

    Size totalSize = Size.zero;
    for (var i = 0; i < childCount; i++) {
      var currentSize = i == 0 ? Size.zero : getIndexSize(i);
      totalSize += sizeToOffset(currentSize);
      var position = sizeToOffset(totalSize) - transformOffset;
      position = applyDirection(position, direction);
      // position = applyAlignment(
      //   position,
      //   alignment,
      //   context.size,
      //   context.getChildSize(i)!,
      // );

      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          position.dx,
          position.dy,
          0,
        ),
      );
    }
  }

  @override
  Size getSize(BoxConstraints constraints) =>
      resize?.call(constraints) ?? super.getSize(constraints);

  Offset sizeToOffset(Size size) => Offset(size.width, size.height);
  Offset applyDirection(Offset position, Offset direction) {
    var identityDirection = Offset(direction.dx.sign, direction.dy.sign);
    var updatedPosition =
        position.scale(identityDirection.dx, identityDirection.dy);
    return updatedPosition;
  }

  // Offset applyAlignment(
  //   Offset position,
  //   Alignment alignment,
  //   Size totalSize,
  //   Size elementSize,
  // ) {
  //   return Offset(
  //     position.dx + totalSize.width / 2 - elementSize.width / 2,
  //     position.dy + totalSize.height / 2 - elementSize.height / 2,
  //   );

  //   return position;
  //   // return alignment.inscribe(size, rect);
  // }
}

extension _DoubleFraction on double {
  double get fraction {
    if (truncate() == 0) return this;
    return remainder(truncate());
  }
}
