import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageServices {
  StorageServices([FirebaseStorage? storage])
      : service = storage ?? FirebaseStorage.instance;
  final FirebaseStorage service;

  Future<String> uploadFile(File data, Reference ref) async {
    try {
      await ref.putFile(data);
      String downloadLink = await ref.getDownloadURL();
      return downloadLink;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadString(
    String data,
    Reference ref, [
    PutStringFormat format = PutStringFormat.raw,
  ]) async {
    try {
      await ref.putString(data, format: format);
      String downloadLink = await ref.getDownloadURL();
      return downloadLink;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadData(Uint8List data, Reference ref) async {
    try {
      await ref.putData(data);
      String downloadLink = await ref.getDownloadURL();
      return downloadLink;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadBlob(dynamic data, Reference ref) async {
    try {
      await ref.putBlob(data);
      String downloadLink = await ref.getDownloadURL();
      return downloadLink;
    } catch (e) {
      rethrow;
    }
  }
}
