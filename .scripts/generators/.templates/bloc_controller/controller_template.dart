
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/_libraries/bloc/bloc_event.dart';
import '/_libraries/bloc/bloc_state.dart';
import '/_libraries/generic_status.dart';
import '/utils/app_helpers/_app_helper_import.dart';

part '<name>_event.dart';
part '<name>_state.dart';

class <Name>Controller extends Bloc<<Name>Event, <Name>State> {
  <Name>Controller() : super(<Name>State()) {
    printPersistent('<Name>Controller Initialized');
  }

  FutureOr<void> baseEventCallback(
    <Name>Event event,
    Emitter<<Name>State> emit,
  ) async {
    try {
      emit(state.loading(event));
      emit(state.copyWith(
        event: event,
        eventStatus: state.updateStatus(event, GenericStatus.success),
      ));
    } catch (e) {
      emit(state.copyWith(
        event: event,
        eventStatus: state.updateStatus(event, GenericStatus.failure),
        message: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    printPersistent('<Name>Controller Disposed');
    state.store.dispose();
    return super.close();
  }
}
