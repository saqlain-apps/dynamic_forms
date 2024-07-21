import 'package:flutter_bloc/flutter_bloc.dart';

import '../generic_status.dart';
import 'bloc_event.dart';
import 'bloc_info.dart';

class BlocStateStore {
  const BlocStateStore();
  void dispose() {}
}

class BlocState<T extends BlocStateStore> extends BlocInfo {
  BlocState({
    required super.event,
    super.eventStatus = const {},
    super.message,
    super.data,
    required this.store,
  });

  final T store;

  BlocState<T> copyWith({
    required BlocEvent event,
    Map<BlocEvent, GenericStatus>? eventStatus,
    String? message,
    dynamic data,
  }) {
    return BlocState<T>(
      event: event,
      eventStatus: eventStatus ?? this.eventStatus,
      message: message,
      data: data,
      store: store,
    );
  }
}

extension AwaitFuture<Event extends BlocEvent, State extends BlocState>
    on Bloc<Event, State> {
  Future<State> future(Event event, {GenericStatus? status}) {
    return stream.firstWhere((state) {
      final isSameEvent = state.event == event;
      final statusCheck =
          status != null ? state.status == status : state.status.isComplete;

      return isSameEvent && statusCheck;
    });
  }

  Future<State> awaitEvent(Event event, {GenericStatus? status}) {
    final fut = future(event, status: status);
    add(event);
    return fut;
  }
}
