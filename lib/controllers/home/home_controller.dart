import 'dart:async';

import 'package:dynamic_form/controllers/app/app_controller.dart';
import 'package:dynamic_form/models/form_model/submitted_form_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/_libraries/bloc/bloc_event.dart';
import '/_libraries/bloc/bloc_state.dart';
import '/_libraries/generic_status.dart';
import '/utils/app_helpers/_app_helper_import.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeController extends Bloc<HomeEvent, HomeState> {
  final AppController appController;
  HomeController(this.appController) : super(HomeState()) {
    printPersistent('HomeController Initialized');

    on<HomeSyncEvent>(sync);

    _init();
  }

  StreamSubscription<AppState>? sub;

  void _init() {
    sub = appController.stream.listen((event) {
      add(HomeSyncEvent(event));
    });
  }

  void sync(
    HomeSyncEvent event,
    Emitter<HomeState> emit,
  ) async {
    final submittedForm =
        Map.fromEntries(event.appState.submittedForms.map((e) {
      final isLoading =
          event.appState.eventStatus[AppUploadFormEvent(e)]?.isLoading == true;
      return MapEntry(e, isLoading);
    }));

    emit(state.copyWith(
      event: event,
      submittedForms: submittedForm,
    ));
  }

  FutureOr<void> baseEventCallback(
    HomeEvent event,
    Emitter<HomeState> emit,
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
    printPersistent('HomeController Disposed');
    sub?.cancel();
    state.store.dispose();
    return super.close();
  }
}
