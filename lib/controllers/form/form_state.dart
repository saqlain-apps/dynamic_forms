part of 'form_controller.dart';

class FormStateStore extends BlocStateStore {
  FormStateStore();

  final ValueNotifier<Map<FormFieldModel, dynamic>> responseController =
      ValueNotifier({});

  @override
  void dispose() {
    responseController.dispose();
  }
}

class FormScreenState extends BlocState<FormStateStore> {
  FormScreenState({
    super.event = const FormInitialEvent(),
    super.eventStatus,
    super.message,
    super.data,
    this.form,
    FormStateStore? store,
  }) : super(store: store ?? FormStateStore());

  final FormModel? form;

  @override
  FormScreenState copyWith({
    required BlocEvent event,
    Map<BlocEvent, GenericStatus>? eventStatus,
    String? message,
    dynamic data,
    FormModel? form,
  }) {
    return FormScreenState(
      store: store,
      event: event,
      message: message,
      data: data,
      eventStatus: eventStatus ?? this.eventStatus,
      form: form ?? this.form,
    );
  }

  FormScreenState loading(FormEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.loading), event: event);
  FormScreenState success(FormEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.success), event: event);
  FormScreenState failure(FormEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.failure), event: event);
  FormScreenState none(FormEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.none), event: event);
}
