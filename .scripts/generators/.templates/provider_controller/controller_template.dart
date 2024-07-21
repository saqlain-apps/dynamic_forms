import 'dart:async';

import '/utils/generic_status.dart';
import '/utils/provider/provider_emitter.dart';

class <Name>Provider extends ProviderEmitter {
  FutureOr<void> baseEventCallback() async {
    emit(GenericStatus.loading);
    // Do the Work
    emit(GenericStatus.none);
  }
}
