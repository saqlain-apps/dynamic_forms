import 'dart:async';
import 'dart:io';

import 'package:dynamic_form/controllers/app/app_controller.dart';
import 'package:dynamic_form/models/form_model/form_field_model.dart';
import 'package:dynamic_form/models/form_model/form_model.dart';
import 'package:dynamic_form/models/form_model/submitted_form_model.dart';
import 'package:dynamic_form/repositories/api_repository/api_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '/_libraries/bloc/bloc_event.dart';
import '/_libraries/bloc/bloc_state.dart';
import '/_libraries/generic_status.dart';
import '/utils/app_helpers/_app_helper_import.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormController extends Bloc<FormEvent, FormScreenState> {
  final AppController appController;
  FormController(this.appController) : super(FormScreenState()) {
    printPersistent('FormController Initialized');

    on<FormFetchFormEvent>(fetchForm);
    on<FormSubmitFormEvent>(submitForm);

    add(const FormFetchFormEvent());
  }

  FutureOr<void> fetchForm(
    FormFetchFormEvent event,
    Emitter<FormScreenState> emit,
  ) async {
    try {
      emit(state.loading(event));
      final form = await getit.get<ApiRepository>().getFormData.call();
      if (form != null) {
        emit(state.copyWith(
          event: event,
          eventStatus: state.updateStatus(event, GenericStatus.success),
          form: form,
        ));
      } else {
        emit(state.failure(event));
      }
    } catch (e) {
      emit(state.copyWith(
        event: event,
        eventStatus: state.updateStatus(event, GenericStatus.failure),
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> submitForm(
    FormSubmitFormEvent event,
    Emitter<FormScreenState> emit,
  ) async {
    try {
      final response = SubmittedFormModel(
        id: const AppMethods().generateRandomKey(),
        formName: state.form?.formName ?? '',
        submittedAt: DateTime.now(),
        fields: Map<FormFieldModel, dynamic>.from(
            state.store.responseController.value),
      );

      var storagePath = await getExternalStorageDirectory();
      for (var fieldData in response.fields.entries) {
        final field = fieldData.key;
        final fieldResponse = fieldData.value;
        if (field is FormCaptureImagesFieldModel && isNotBlank(fieldResponse)) {
          if ((fieldResponse as List).first is! XFile) break;
          final xfiles = fieldResponse as List<XFile>;

          final movedFiles = await Future.wait(xfiles.map((e) async {
            final name =
                "${const AppMethods().generateRandomKey()}.${e.name.split(".").last}";
            final newPath = path.join(storagePath!.path, field.folderName);
            await Directory(newPath).create(recursive: true);
            await e.saveTo(path.join(newPath, name));
            return XFile(
              path.join(newPath, name),
              name: name,
              mimeType: e.mimeType,
            );
          }));
          response.fields[fieldData.key] = movedFiles;
        }
      }

      appController.add(AppSubmitFormEvent(response));
      emit(state.success(event));
    } catch (e) {
      emit(state.copyWith(
        event: event,
        eventStatus: state.updateStatus(event, GenericStatus.failure),
        message: e.toString(),
      ));
    }
  }

  FutureOr<void> baseEventCallback(
    FormEvent event,
    Emitter<FormScreenState> emit,
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
    printPersistent('FormController Disposed');
    state.store.dispose();
    return super.close();
  }
}
