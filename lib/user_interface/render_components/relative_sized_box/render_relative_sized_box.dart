part of 'relative_sized_box.dart';

/// When the child overflows the current animated size of this render object, it
/// is clipped.
class RenderRelativeSizedBox extends RenderAligningShiftedBox {
  RenderRelativeSizedBox({
    super.alignment,
    super.textDirection,
    Clip clipBehavior = Clip.hardEdge,
    double heightFactor = 1,
    double widthFactor = 1,
    super.child,
  })  : _clipBehavior = clipBehavior,
        _heightFactor = heightFactor,
        _widthFactor = widthFactor;

  late bool _hasVisualOverflow;

  double get heightFactor => _heightFactor;
  double _heightFactor = 1;
  set heightFactor(double value) {
    if (value != _heightFactor) {
      _heightFactor = value;
      markNeedsLayout();
    }
  }

  double get widthFactor => _widthFactor;
  double _widthFactor = 1;
  set widthFactor(double value) {
    if (value != _widthFactor) {
      _widthFactor = value;
      markNeedsLayout();
    }
  }

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  Clip get clipBehavior => _clipBehavior;
  Clip _clipBehavior = Clip.hardEdge;
  set clipBehavior(Clip value) {
    if (value != _clipBehavior) {
      _clipBehavior = value;
      markNeedsPaint();
      markNeedsSemanticsUpdate();
    }
  }

  Size _sizeFactor(Size childSize) {
    return Size(
      childSize.width * widthFactor,
      childSize.height * heightFactor,
    );
  }

  @override
  void performLayout() {
    _hasVisualOverflow = false;
    final BoxConstraints constraints = this.constraints;
    if (child == null || constraints.isTight) {
      size = constraints.smallest;
      child?.layout(constraints);
      return;
    }

    child!.layout(constraints, parentUsesSize: true);
    size = constraints.constrain(_sizeFactor(child!.size));
    alignChild();

    if (size.width < child!.size.width || size.height < child!.size.height) {
      _hasVisualOverflow = true;
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child == null || constraints.isTight) {
      return constraints.smallest;
    }

    final Size childSize = child!.getDryLayout(constraints);
    return constraints.constrain(_sizeFactor(childSize));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && _hasVisualOverflow && clipBehavior != Clip.none) {
      final Rect rect = Offset.zero & size;
      _clipRectLayer.layer = context.pushClipRect(
        needsCompositing,
        offset,
        rect,
        super.paint,
        clipBehavior: clipBehavior,
        oldLayer: _clipRectLayer.layer,
      );
    } else {
      _clipRectLayer.layer = null;
      super.paint(context, offset);
    }
  }

  final LayerHandle<ClipRectLayer> _clipRectLayer =
      LayerHandle<ClipRectLayer>();

  @override
  void dispose() {
    _clipRectLayer.layer = null;
    super.dispose();
  }
}
