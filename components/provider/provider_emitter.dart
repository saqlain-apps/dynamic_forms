import 'package:flutter/material.dart';

import '../../lib/utils/generic_status.dart';

class ProviderEmitter extends ChangeNotifier {
  GenericStatus _status = GenericStatus.none;
  GenericStatus get status => _status;

  void emit(GenericStatus status) {
    _status = status;
    notifyListeners();
  }
}
