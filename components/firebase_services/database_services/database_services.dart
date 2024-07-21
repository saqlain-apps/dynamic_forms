import 'package:firebase_database/firebase_database.dart';

import 'methods/database_methods.dart';

class DatabaseServices = DatabaseServicesCore with DatabaseMethods;

class DatabaseServicesCore {
  DatabaseServicesCore([FirebaseDatabase? database])
      : service = database ?? FirebaseDatabase.instance;

  final FirebaseDatabase service;
}
