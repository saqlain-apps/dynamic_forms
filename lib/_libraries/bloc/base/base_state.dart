part of 'base_controller.dart';

class BaseStateStore extends BlocStateStore {
  BaseStateStore();

  @override
  void dispose() {}
}

class BaseState extends BlocState<BaseStateStore> {
  BaseState({
    super.event = const BaseInitialEvent(),
    super.eventStatus,
    super.message,
    super.data,
    BaseStateStore? store,
  }) : super(store: store ?? BaseStateStore());

  @override
  BaseState copyWith({
    required BlocEvent event,
    Map<BlocEvent, GenericStatus>? eventStatus,
    String? message,
    dynamic data,
  }) {
    return BaseState(
      store: store,
      event: event,
      message: message,
      data: data,
      eventStatus: eventStatus ?? this.eventStatus,
    );
  }

  BaseState loading(BaseEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.loading), event: event);
  BaseState success(BaseEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.success), event: event);
  BaseState failure(BaseEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.failure), event: event);
  BaseState none(BaseEvent event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.none), event: event);
}
