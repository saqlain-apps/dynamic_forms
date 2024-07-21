import 'package:flutter/foundation.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '/user_interface/components/app_components/app_image.dart';
import '/utils/app_helpers/_app_helper_import.dart';

class AppVideoThumbnail extends StatefulWidget {
  static Widget playIcon() {
    return Container(
      color: Colors.black.withOpacity(.2),
      child: FractionallySizedBox(
        heightFactor: .4,
        widthFactor: .4,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: constraints.biggest.shortestSide,
            );
          },
        ),
      ),
    );
  }

  const AppVideoThumbnail({
    required this.video,
    this.child,
    this.fit,
    this.height,
    this.width,
    this.placeholder,
    super.key,
  });

  final BoxFit? fit;
  final String video;

  final int? height;
  final int? width;

  final String? placeholder;
  final Widget? child;

  @override
  State<AppVideoThumbnail> createState() => _AppVideoThumbnailState();
}

class _AppVideoThumbnailState extends State<AppVideoThumbnail> {
  final ValueNotifier<Uint8List?> _thumbnail = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _initializeThumbnail();
  }

  @override
  void didUpdateWidget(covariant AppVideoThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeThumbnail();
  }

  void _initializeThumbnail() async {
    if (widget.video.isNotEmpty && _thumbnail.value == null) {
      final data = await VideoThumbnail.thumbnailData(
        video: widget.video,
        maxHeight: widget.height ?? 0,
        maxWidth: widget.width ?? 0,
      );

      if (mounted) {
        _thumbnail.value = data;
      }
    }
  }

  @override
  void dispose() {
    _thumbnail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.video.isEmpty) return const SizedBox.shrink();
    return ValueListenableBuilder(
      valueListenable: _thumbnail,
      builder: (context, value, _) {
        if (value == null) {
          return widget.placeholder != null
              ? buildPlaceholder()
              : progressIndicator(null);
        }

        return Container(
          height: widget.height?.toDouble(),
          width: widget.width?.toDouble(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(value),
              fit: widget.fit,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }

  Widget progressIndicator(double? progress) {
    return Center(child: CircularProgressIndicator.adaptive(value: progress));
  }

  Widget buildPlaceholder() {
    if (widget.placeholder != null) return const SizedBox.shrink();
    return AppImage(
      image: widget.placeholder!,
      type: ImageType.local,
      height: widget.height?.toDouble(),
      width: widget.width?.toDouble(),
      fit: widget.fit,
    );
  }
}
