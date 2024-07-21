import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../generic_status.dart';
import '../bloc_event.dart';
import '../bloc_state.dart';

part 'base_event.dart';
part 'base_state.dart';

class BaseController extends Bloc<BaseEvent, BaseState> {
  BaseController() : super(BaseState()) {
    print('BaseController Initialized');
  }

  FutureOr<void> baseEventCallback(
    BaseEvent event,
    Emitter<BaseState> emit,
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
    state.store.dispose();
    return super.close();
  }
}
