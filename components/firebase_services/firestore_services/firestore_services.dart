import 'package:cloud_firestore/cloud_firestore.dart';

import 'methods/future_methods.dart';
import 'methods/stream_methods.dart';

class FirestoreServices = FirestoreServicesCore
    with FirestoreStreamMethods, FirestoreFutureMethods;

class FirestoreServicesCore {
  FirestoreServicesCore([
    FirebaseFirestore? firestore,
  ]) : service = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore service;
}
