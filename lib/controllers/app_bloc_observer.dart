// ignore_for_file: unused_local_variable

import 'package:flutter_bloc/flutter_bloc.dart';

import '/utils/app_helpers/_app_helper_import.dart';
import '../_libraries/bloc/bloc_info.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    final currentState = transition.currentState as BlocInfo;
    final nextState = transition.nextState as BlocInfo;
    final now = DateTime.now();

    record(' ' * 80);
    record('_' * 80);
    record('On Event: ${transition.event}');
    record(
      'Timestamp: ${now.hour}:${now.minute}:${now.second} -- ${now.millisecond}',
    );
    _comparison(transition, 'Event', (state) => state.event);
    _comparison(transition, 'Event Status',
        (state) => state.eventStatus[transition.event]);
    _comparison(transition, 'Main Status', (state) => state.status);
    if (nextState.message != null) {
      record('Message: ${nextState.message}');
    }
    record('_' * 80);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    printError('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  void _comparison(
    Change transition,
    String title,
    Function(BlocInfo state) comparison, {
    void Function(String log)? printer,
  }) {
    printer ??= record;
    final current = comparison(transition.currentState as BlocInfo);
    final next = comparison(transition.nextState as BlocInfo);

    String log = '$title: ';
    if (current == next) {
      if (current == null) return;
      log += '$current';
    } else {
      log += '$current ----> $next';
    }
    printer(log);
  }

  void record(String log) {
    // printPersistent(log);
  }
}
