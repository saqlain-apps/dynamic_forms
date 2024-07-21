part of 'form_controller.dart';

sealed class FormEvent extends BlocEvent {
  const FormEvent();
}

class FormInitialEvent extends FormEvent {
  const FormInitialEvent();
}

class FormFetchFormEvent extends FormEvent {
  const FormFetchFormEvent();
}

class FormSubmitFormEvent extends FormEvent {
  const FormSubmitFormEvent();
}
