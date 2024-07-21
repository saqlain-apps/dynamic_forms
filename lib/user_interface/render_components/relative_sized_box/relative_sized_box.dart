import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

part 'render_relative_sized_box.dart';

class RelativeSizedBox extends SingleChildRenderObjectWidget {
  const RelativeSizedBox({
    this.heightFactor = 1,
    this.widthFactor = 1,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.hardEdge,
    super.key,
    super.child,
  });

  final double heightFactor;
  final double widthFactor;
  final AlignmentGeometry alignment;
  final Clip clipBehavior;

  @override
  RenderRelativeSizedBox createRenderObject(BuildContext context) {
    return RenderRelativeSizedBox(
      heightFactor: heightFactor,
      widthFactor: widthFactor,
      alignment: alignment,
      textDirection: Directionality.maybeOf(context),
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderRelativeSizedBox renderObject) {
    renderObject
      ..heightFactor = heightFactor
      ..widthFactor = widthFactor
      ..alignment = alignment
      ..textDirection = Directionality.maybeOf(context)
      ..clipBehavior = clipBehavior;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AlignmentGeometry>(
        'alignment', alignment,
        defaultValue: Alignment.topCenter));
  }
}
