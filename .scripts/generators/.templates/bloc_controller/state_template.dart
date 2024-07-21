part of '<name>_controller.dart';

class <Name>StateStore extends BlocStateStore {
  <Name>StateStore();
  
  @override
  void dispose() {}
}

class <Name>State extends BlocState<<Name>StateStore> {
  <Name>State({
    super.event = const <Name>InitialEvent(),
    super.eventStatus,
    super.message,
    super.data,
    <Name>StateStore? store,
  }) : super(store: store ?? <Name>StateStore());

  @override
  <Name>State copyWith({
    required BlocEvent event,
    Map<BlocEvent, GenericStatus>? eventStatus,
    String? message,
    dynamic data,
  }) {
    return <Name>State(
      store: store,
      event: event,
      message: message,
      data: data,
      eventStatus: eventStatus ?? this.eventStatus,
    );
  }

  <Name>State loading(<Name>Event event) => copyWith(
      eventStatus: updateStatus(event, GenericStatus.loading), event: event);
  <Name>State success(<Name>Event event) =>  copyWith(
      eventStatus: updateStatus(event, GenericStatus.success), event: event);
  <Name>State failure(<Name>Event event) =>  copyWith(
      eventStatus: updateStatus(event, GenericStatus.failure), event: event);
  <Name>State none(<Name>Event event) =>  copyWith(
      eventStatus: updateStatus(event, GenericStatus.none), event: event);

}
