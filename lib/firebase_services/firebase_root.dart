import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '/firebase_options.dart';
import '/utils/app_helpers/_app_helper_import.dart';
import 'storage_services.dart';

class FirebaseRoot {
  FirebaseRoot();

  static String get localhost => defaultTargetPlatform == TargetPlatform.android
      ? "10.0.2.2"
      : "localhost";

  late final FirebaseApp firebaseApp;
  late final StorageServices storageServices;

  Future<FirebaseApp> initialize() async {
    FirebaseApp firebaseApp;

    try {
      firebaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      printError(e);
      firebaseApp = await Firebase.initializeApp();
    }

    FirebaseStorage storage = FirebaseStorage.instance;
    storageServices = StorageServices(storage);

    return firebaseApp;
  }
}
