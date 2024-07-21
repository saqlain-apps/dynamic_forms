import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import '/utils/app_helpers/_app_helper_import.dart';
import 'permission_services.dart';

class MediaAccess {
  const MediaAccess(this.picker);
  final ImagePicker picker;

  Future<XFile?> pickImage(ImageSource type) async {
    return pick((picker) => picker.pickImage(source: type), type);
  }

  Future<XFile?> pickVideo(ImageSource type) async {
    return pick((picker) => picker.pickVideo(source: type), type);
  }

  Future<XFile?> pickMedia() async {
    return pick((picker) => picker.pickMedia());
  }

  Future<List<XFile>?> pickMultiImages({int? mediaLimit}) async {
    return pick((picker) => picker.pickMultiImage(limit: mediaLimit));
  }

  Future<List<XFile>?> pickMultiMedia({int? mediaLimit}) async {
    return pick((picker) => picker.pickMultipleMedia(limit: mediaLimit));
  }

  Future<T?> pick<T>(
    Future<T?> Function(ImagePicker picker) pick, [
    ImageSource source = ImageSource.gallery,
  ]) async {
    return _handleError(() => pick(picker), source);
  }

  Future<bool> _requestPermission(ImageSource source) {
    final resource = switch (source) {
      ImageSource.camera => RequestResource.camera,
      ImageSource.gallery => RequestResource.storage,
    };
    return PermissionServices.requestPermission(resource);
  }

  Future<T?> _handleError<T>(
    Future<T?> Function() pick,
    ImageSource source,
  ) async {
    try {
      return await pick();
    } on PlatformException {
      final hasPermission = await _requestPermission(source);
      if (hasPermission) return await pick();
      return null;
    } catch (e) {
      printError(e);
      rethrow;
    }
  }

  static MediaType mediaType(String path) {
    final mime = lookupMimeType(path);
    return MediaType.parse(mime!);
  }
}
