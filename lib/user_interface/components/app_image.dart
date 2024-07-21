import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';

import '/utils/app_helpers/_app_helper_import.dart';

enum ImageType { network, local, svgLocal, svgNetwork, file }

class AppImage extends StatelessWidget {
  const AppImage({
    required this.image,
    this.type = ImageType.network,
    this.fit,
    this.height,
    this.width,
    this.color,
    this.maxHeightDiskCache,
    this.maxWidthDiskCache,
    this.showLoadingProgress = false,
    this.placeholder,
    super.key,
  });

  final BoxFit? fit;
  final String image;
  final Color? color;
  final double? height;
  final double? width;
  final int? maxWidthDiskCache;
  final int? maxHeightDiskCache;
  final bool showLoadingProgress;
  final String? placeholder;
  final ImageType type;

  @override
  Widget build(BuildContext context) {
    if (isBlank(image)) return const SizedBox.shrink();

    switch (type) {
      case ImageType.file:
        return _buildImagePNGLocal(FileImage(File(image)));
      case ImageType.local:
        return _buildImagePNGLocal(AssetImage(image));
      case ImageType.svgLocal:
        return _buildImageSVG(SvgAssetLoader(image));
      case ImageType.svgNetwork:
        return _buildImageSVG(SvgNetworkLoader(image));
      case ImageType.network:
        return _buildImagePNGNetwork(image);
    }
  }

  Widget _buildImagePNGLocal(ImageProvider provider) {
    return Image(
      image: provider,
      height: height,
      width: width,
      fit: fit,
      color: color,
    );
  }

  Widget _buildImageSVG(BytesLoader loader) {
    return SvgPicture(
      loader,
      fit: fit ?? BoxFit.contain,
      height: height,
      width: width,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
    );
  }

  Widget _buildImagePNGNetwork(String image) {
    return CachedNetworkImage(
      imageUrl: image,
      height: height,
      width: width,
      color: color,
      fit: fit,
      placeholder:
          isNotBlank(placeholder) ? (_, __) => _buildPlaceholder() : null,
      progressIndicatorBuilder: isBlank(placeholder) && showLoadingProgress
          ? (context, url, progress) => _progressIndicator(progress.progress)
          : null,
      errorWidget: (context, url, error) => _buildPlaceholder(),
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
    );
  }

  Widget _progressIndicator(double? progress) {
    return Center(
      child: CircularProgressIndicator(
        value: progress,
        color: AppColors.black,
      ),
    );
  }

  Widget _buildPlaceholder() {
    if (isBlank(placeholder)) return const SizedBox.shrink();
    return _buildImagePNGLocal(AssetImage(placeholder!));
  }
}
