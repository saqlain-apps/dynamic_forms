import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '/_libraries/web_functions/web_functions.dart';
import '/controllers/app_bloc_observer.dart';
import '/utils/app_helpers/_app_helper_import.dart';
import '_main.dart';
import 'dependencies.dart';

void main() => ApplicationManager().run();

class ApplicationManager extends DependencyManager {
  ApplicationManager([super.dependencyManager]);

  @override
  Future<void> init() async {
    await super.init();
    await configureApp();
  }

  FutureOr<void> configureApp() async {
    Bloc.observer = AppBlocObserver();
    WebFunctions().configureUrl();
    Messenger().appNavigator.init(AppRoutes.home.name);
  }

  @override
  Widget build() {
    return const DynamicForms();
  }
}
