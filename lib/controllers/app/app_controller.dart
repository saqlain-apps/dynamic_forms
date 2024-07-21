import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dynamic_form/models/form_model/fields/form_capture_images_field_model.dart';
import 'package:dynamic_form/models/form_model/submitted_form_model.dart';
import 'package:dynamic_form/repositories/api_repository/api_repository.dart';
import 'package:dynamic_form/repositories/hive_repository/hive_repository.dart';
import 'package:dynamic_form/repositories/storage_repository/storage_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '/_libraries/bloc/bloc_event.dart';
import '/_libraries/bloc/bloc_state.dart';
import '/_libraries/generic_status.dart';
import '/utils/app_helpers/_app_helper_import.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppController extends Bloc<AppEvent, AppState> {
  AppController() : super(AppState()) {
    printPersistent('AppController Initialized');

    on<AppNetworkChangeEvent>(networkChange);
    on<AppSubmitFormEvent>(submitFormHandler);
    on<AppUploadFormEvent>(uploadFormHandler);

    _init();
  }

  StreamSubscription<List<ConnectivityResult>>? sub;

  void _init() {
    add(const AppNetworkChangeEvent());
    sub = Connectivity().onConnectivityChanged.listen((event) {
      add(const AppNetworkChangeEvent());
    });
  }

  FutureOr<void> networkChange(
    AppNetworkChangeEvent event,
    Emitter<AppState> emit,
  ) async {
    try {
      emit(state.loading(event));
      final isConnected = await checkInternet();
      if (isConnected) {
        for (var form in formsToBeUploaded(state.submittedForms)) {
          add(AppUploadFormEvent(form));
        }
      }
      emit(state.copyWith(
        event: event,
        eventStatus: state.updateStatus(event, GenericStatus.success),
        isConnected: isConnected,
      ));
    } catch (e) {
      print(e);
      emit(state.copyWith(
        event: event,
        eventStatus: state.updateStatus(event, GenericStatus.failure),
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> submitFormHandler(
    AppSubmitFormEvent event,
    Emitter<AppState> emit,
  ) async {
    try {
      emit(state.loading(event));

      await putToDB(event.form);
      if (state.isConnected) {
        add(AppUploadFormEvent(event.form));
      }

      emit(state.success(event));
    } catch (e) {
      printError(e);
      emit(state.copyWith(
        event: event,
        eventStatus: state.updateStatus(event, GenericStatus.failure),
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> uploadFormHandler(
    AppUploadFormEvent event,
    Emitter<AppState> emit,
  ) async {
    if (!state.isConnected) return;

    try {
      emit(state.loading(event));

      var uploaded = await uploadForm(event.form);
      if (uploaded != null) await putToDB(uploaded);

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

  FutureOr<void> baseEventCallback(
    AppEvent event,
    Emitter<AppState> emit,
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

  static Future<void> putToDB(SubmittedFormModel form) async {
    var hiveRepo = getit.get<HiveRepository>();
    var box = hiveRepo.submittedForms;
    await box.put(form.id, form);
    await box.flush();
  }

  static Future<SubmittedFormModel?> uploadForm(SubmittedFormModel form) async {
    if (await checkInternet() == false) return null;

    for (var field in form.fields.entries) {
      if (field.key is FormCaptureImagesFieldModel && isNotBlank(field.value)) {
        final xfiles = field.value as List;
        if (xfiles.first is! XFile) break;

        var links = await Future.wait(xfiles.map((e) async {
          return getit
              .get<StorageRepository>()
              .uploadImage(File(e.path), e.name);
        }));
        form.fields[field.key] = links;
      }
    }

    final res = await getit.get<ApiRepository>().submitForm.call(form);
    return res ? form.copyWith(isUploaded: true) : form;
  }

  static Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      printError(e);
    }
    return false;
  }

  static List<SubmittedFormModel> formsToBeUploaded(
          List<SubmittedFormModel> forms) =>
      forms.where((e) => !e.isUploaded).toList();

  @override
  Future<void> close() {
    sub?.cancel();
    state.store.dispose();
    return super.close();
  }
}
