import 'dart:async';

import '../../lib/utils/generic_status.dart';
import 'provider_emitter.dart';

class BaseController extends ProviderEmitter {
  FutureOr<void> baseEventCallback() async {
    emit(GenericStatus.loading);
    // Do the Work
    emit(GenericStatus.none);
  }
}
