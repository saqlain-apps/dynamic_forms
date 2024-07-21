part of 'gap.dart';

class _RenderGap extends RenderBox {
  _RenderGap({required double extent}) : _extent = extent;

  double _extent;
  double get extent => _extent;
  set extent(double value) {
    if (_extent != value) {
      _extent = value;
      markNeedsLayout();
    }
  }

  Axis? get _direction {
    final flex = parent!;
    if (flex is RenderFlex) {
      return flex.direction;
    } else {
      return null;
    }
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return extent;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return extent;
  }

  Size? get _computeSize {
    if (_direction == Axis.horizontal) {
      return Size(extent, 0);
    } else if (_direction == Axis.vertical) {
      return Size(0, extent);
    } else {
      return null;
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (_computeSize == null) {
      throw FlutterError(
        'A Gap widget must be placed directly inside a Flex widget',
      );
    }

    return constraints.constrain(_computeSize!);
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('extent', extent));
  }
}
