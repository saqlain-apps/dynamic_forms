import 'dart:async';

import '/utils/app_helpers/_app_helper_import.dart';
import '../_libraries/silver_router/silver_router_delegate.dart';

class AppNavigator {
  FutureOr<void> init(
    String initialRoute, {
    List<NavigatorObserver>? navigatorObservers,
  }) {
    routerConfig = SilverRouterConfig.named(
      initialRoute: initialRoute,
      routes: AppRoutes().buildRoutes(),
      navigatorKey: navigatorKey,
      methodBuilder: (access) => AppNavigationMethods(access),
    );
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  late final SilverRouterConfig routerConfig;
  NavigationMethods get navigator => routerConfig.controller.controls;
  List<SilverRoute> get currentRoute =>
      routerConfig.controller.controls.currentRoute;
}

class AppNavigationMethods extends NavigationMethods {
  AppNavigationMethods(super.access);
}
