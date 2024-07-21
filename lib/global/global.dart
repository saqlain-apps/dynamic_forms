import 'package:get_it/get_it.dart';

final getit = GetIt.instance;

bool isBlank(dynamic object) {
  if (object == null) {
    return true;
  } else {
    if (object is List || object is String || object is Map) {
      return object.isEmpty;
    } else {
      return false;
    }
  }
}

bool isNotBlank(dynamic object) => !isBlank(object);
