import 'dart:io';

import 'package:dynamic_form/_libraries/_interfaces/base_repository.dart';
import 'package:dynamic_form/firebase_services/storage_services.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository implements BaseRepository {
  const StorageRepository(this.storage);
  final StorageServices storage;

  Future<String> uploadImage(File imageFile, String name) async {
    Reference imagePath = storage.service.ref("plrs-assignments/tasks/saqlain");
    var imageRef = imagePath.child(name);
    try {
      var downloadLink = await storage.uploadFile(imageFile, imageRef);
      return downloadLink;
    } catch (e) {
      rethrow;
    }
  }
}
