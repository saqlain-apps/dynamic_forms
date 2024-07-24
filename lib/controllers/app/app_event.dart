part of 'app_controller.dart';

sealed class AppEvent extends BlocEvent {
  const AppEvent();
}

class AppInitialEvent extends AppEvent {
  const AppInitialEvent();
}

class AppInitializeHiveEvent extends AppEvent {
  const AppInitializeHiveEvent();
}

class AppNetworkChangeEvent extends AppEvent {
  const AppNetworkChangeEvent();
}

class AppSubmitFormEvent extends AppEvent {
  const AppSubmitFormEvent(this.form);
  final SubmittedFormModel form;
}

class AppUploadFormEvent extends AppEvent {
  const AppUploadFormEvent(this.form);
  final SubmittedFormModel form;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppUploadFormEvent && other.form.id == form.id;
  }

  @override
  int get hashCode => form.id.hashCode;
}
