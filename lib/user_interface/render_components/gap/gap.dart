// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

part 'render_gap.dart';

class Gap extends LeafRenderObjectWidget {
  const Gap(this.size, {super.key});

  final double size;

  double get effectiveSize {
    if (size.isNegative || !size.isFinite) {
      return 0;
    } else {
      return size;
    }
  }

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderGap(extent: effectiveSize);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderGap renderObject,
  ) {
    renderObject.extent = effectiveSize;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('extent', effectiveSize));
  }
}
