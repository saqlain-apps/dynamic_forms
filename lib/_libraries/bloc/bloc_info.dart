import '../generic_status.dart';
import 'bloc_event.dart';

class BlocInfo<Event extends BlocEvent> {
  BlocInfo({
    required Event event,
    required Map<Event, GenericStatus> eventStatus,
    dynamic data,
    String? message,
    GenericStatus Function(GenericStatus a, GenericStatus b)? combine,
  })  : _event = event,
        _status = buildStatus(eventStatus, event),
        _statusOverview = buildStatusOverview(
          buildStatus(eventStatus, event),
          combine ?? merge,
        ),
        _message = message,
        _data = data;

  final Event _event;
  final Map<Event, GenericStatus> _status;
  final Map<Type, GenericStatus> _statusOverview;
  final dynamic _data;
  final String? _message;

  Map<Event, GenericStatus> get eventStatus =>
      Map<Event, GenericStatus>.from(_status);
  Map<Type, GenericStatus> get typeStatus =>
      Map<Type, GenericStatus>.from(_statusOverview);

  Event get event => _event;
  GenericStatus get status => _status[event]!;
  GenericStatus get statusOverview => eventStatus.values.reduce(merge);
  dynamic get data => _data;
  String? get message => _message;

  Map<Event, GenericStatus> updateStatus(
    Event event,
    GenericStatus status,
  ) {
    return Map<Event, GenericStatus>.from(eventStatus)..[event] = status;
  }

  bool didChangeStatus(BlocInfo<Event> state) => status != state.status;
  bool isStatus(GenericStatus status, [Type? eventType]) {
    var currentStatus = this.status;
    if (eventType != null) {
      currentStatus = typeStatus[eventType] ?? GenericStatus.none;
    }
    return currentStatus == status;
  }

  bool isLoading([Type? eventType]) =>
      isStatus(GenericStatus.loading, eventType);

  static Map<Event, GenericStatus> buildStatus<Event>(
    Map<Event, GenericStatus> eventStatus,
    Event event,
  ) {
    final statusMap = Map<Event, GenericStatus>.from(eventStatus);
    statusMap.putIfAbsent(event, () => GenericStatus.none);
    return Map<Event, GenericStatus>.unmodifiable(statusMap);
  }

  static Map<Type, GenericStatus> buildStatusOverview<Event>(
    Map<Event, GenericStatus> eventStatus,
    GenericStatus Function(GenericStatus a, GenericStatus b) combine,
  ) {
    Map<Type, GenericStatus> fold(
      Map<Type, GenericStatus> accumulator,
      MapEntry<Event, GenericStatus> value,
    ) {
      final type = value.key.runtimeType;
      final status = combine((accumulator[type] ?? value.value), value.value);
      accumulator[type] = status;
      return accumulator;
    }

    final overview =
        eventStatus.entries.fold<Map<Type, GenericStatus>>({}, fold);
    return Map<Type, GenericStatus>.unmodifiable(overview);
  }

  static GenericStatus merge(GenericStatus a, GenericStatus b) => a + b;
}
