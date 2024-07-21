import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

mixin BitmapPaintMethods {
  Future<BitmapDescriptor> paint({
    required Size Function(ui.Canvas) painter,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(pictureRecorder);
    final size = painter(canvas);
    final img = await pictureRecorder
        .endRecording()
        .toImage(size.width.ceil(), size.height.ceil());
    final data = (await img.toByteData(format: ui.ImageByteFormat.png))!;
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  Future<BitmapDescriptor> bitmapDescriptorFromSvg(
      String asset, Size size) async {
    final PictureInfo pictureInfo =
        await vg.loadPicture(SvgStringLoader(asset), null);
    final ui.Image image = await pictureInfo.picture
        .toImage(size.width.ceil(), size.height.ceil());
    pictureInfo.picture.dispose();
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
    return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  }

  Future<BitmapDescriptor> bitmapDescriptorFromPng(
      String asset, Size size) async {
    final bytes = await getBytesFromAsset(asset, size);
    return BitmapDescriptor.fromBytes(bytes);
  }
}
