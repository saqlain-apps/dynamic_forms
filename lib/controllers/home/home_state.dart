part of 'home_controller.dart';

class HomeStateStore extends BlocStateStore {
  HomeStateStore();

  @override
  void dispose() {}
}

class HomeState extends BlocState<HomeStateStore> {
  HomeState({
    super.event = const HomeInitialEvent(),
    super.eventStatus,
    super.message,
    super.data,
    HomeStateStore? store,
    this.submittedForms = const {},
  }) : super(store: store ?? HomeStateStore());

  final Map<SubmittedFormModel, bool> submittedForms;

  @override
  HomeState copyWith({
    required BlocEvent event,
    Map<BlocEvent, GenericStatus>? eventStatus,
    String? message,
    dynamic data,
    Map<SubmittedFormModel, bool>? submittedForms,
  }) {
    return HomeState(
      store: store,
      event: event,
      message: message,
      data: data,
      eventStatus: eventStatus ?? this.eventStatus,
      submittedForms: submittedForms ?? this.submittedForms,
    );
  }

  HomeState loading(HomeEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.loading), event: event);
  HomeState success(HomeEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.success), event: event);
  HomeState failure(HomeEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.failure), event: event);
  HomeState none(HomeEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.none), event: event);
}
