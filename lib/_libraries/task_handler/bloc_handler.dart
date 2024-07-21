import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'task_handler.dart';

typedef BlocTask<SpecificEvent, State> = FutureOr<void> Function(
    SpecificEvent event, Emitter<State> emit);

class BlocHandler<Event, State> {
  const BlocHandler(this.handler);

  final TaskHandler handler;

  BlocTask<SpecificEvent, State> handleBloc<SpecificEvent extends Event>(
    BlocTask<SpecificEvent, State> task,
  ) {
    return ((event, emit) async =>
        await handler.handle(() => task(event, emit)));
  }
}

class BlocAsyncHandler<Event, State> extends BlocHandler<Event, State> {
  BlocAsyncHandler() : super(TaskHandler.async());
}

class BlocTaskTransformer {
  static BlocTask<SpecificEvent, State> transformAsync<SpecificEvent, State>(
    BlocTask<SpecificEvent, State> task,
    Future<void> Function(FutureOr<void> Function() task) asyncHandler,
  ) {
    return ((event, emit) => asyncHandler(() => task(event, emit)));
  }
}
