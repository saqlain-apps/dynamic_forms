import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'widgets/life_cycle.dart';

abstract class LifeCycleManager<T extends Widget> {
  @mustCallSuper
  FutureOr<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  T build();

  FutureOr<void> run() async {
    Future<void> app() async {
      await init();
      runApp(LifeCycle(
        builder: (context) => build(),
        dispose: dispose,
      ));
    }

    runZonedGuarded(app, onError);
    _originalFlutterErrorHandler = FlutterError.onError;
    _originalPlatformErrorHandler = PlatformDispatcher.instance.onError;
    FlutterError.onError = (error) => onError(
          error.exception,
          error.stack,
          flutterError: error,
        );
    PlatformDispatcher.instance.onError =
        (error, stack) => onError(error, stack, isPlatformError: true);
  }

  bool onError(
    Object error,
    StackTrace? stack, {
    bool isPlatformError = false,
    FlutterErrorDetails? flutterError,
  }) {
    if (flutterError != null && _originalFlutterErrorHandler != null) {
      _originalFlutterErrorHandler.call(flutterError);
    } else if (isPlatformError) {
      return _originalPlatformErrorHandler?.call(error, stack!) ?? false;
    } else {
      throw error;
    }
    return true;
  }

  late final Function(FlutterErrorDetails)? _originalFlutterErrorHandler;
  late final bool Function(Object, StackTrace)? _originalPlatformErrorHandler;

  @mustCallSuper
  void dispose() {}
}
