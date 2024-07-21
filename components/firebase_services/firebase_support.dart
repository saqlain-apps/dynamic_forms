import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '/firebase_options.dart';
import '/utils/app_helpers/_app_helper_import.dart';

import 'auth_services/auth_services.dart';
import 'database_services/database_services.dart';
import 'firestore_services/firestore_services.dart';
import 'storage_services.dart';

class FirebaseSupport {
  FirebaseSupport(this.firebaseApp);

  static String get localhost => defaultTargetPlatform == TargetPlatform.android
      ? "10.0.2.2"
      : "localhost";

  final FirebaseApp firebaseApp;

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  late final AuthServices authService;
  late final FirestoreServices firestoreServices;
  late final DatabaseServices databaseServices;
  late final StorageServices storageServices;

  Future<FirebaseApp> initializeFirebase({
    bool shouldLog = false,
  }) async {
    FirebaseApp firebaseApp;

    try {
      firebaseApp = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      printError(e);
      firebaseApp = await Firebase.initializeApp();
    }

    try {
      FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(shouldLog);
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(shouldLog);
    } catch (e) {
      printError(e);
    }

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseDatabase database = FirebaseDatabase.instance;
    FirebaseStorage storage = FirebaseStorage.instance;

    if (kDebugMode) {
      try {
        await auth.useAuthEmulator(localhost, 9099);
        firestore.useFirestoreEmulator(localhost, 8080);
        database.useDatabaseEmulator(localhost, 9000);
        await storage.useStorageEmulator(localhost, 9199);

        // firestore.settings = const Settings(
        //   host: 'localhost:8080',
        //   sslEnabled: false,
        //   persistenceEnabled: false,
        // );
      } catch (e) {
        printError(e);
      }
    }

    authService = AuthServices(auth: auth);
    firestoreServices = FirestoreServices(firestore);
    databaseServices = DatabaseServices(database);
    storageServices = StorageServices(storage);

    return firebaseApp;
  }
}
