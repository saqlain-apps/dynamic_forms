library silver_router;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'configuration/silver_route_configuration.dart';
part 'configuration/silver_sentinel_configuration.dart';
part 'controller/controller.dart';
part 'controller/internal_controller.dart';
part 'controller/internal_controls.dart';
part 'controller/navigation_debug.dart';
part 'controller/route_controls.dart';
part 'controller/sentinel_watch.dart';
part 'navigation_controller.dart';
part 'page/silver_page.dart';
part 'page/silver_raw_page.dart';
part 'route/route_components/route_argument.dart';
part 'route/routes/silver_branched_route.dart';
part 'route/routes/silver_custom_route.dart';
part 'route/routes/silver_nested_route.dart';
part 'route/routes/silver_page_route.dart';
part 'route/routes/silver_route_proxy.dart';
part 'route/silver_route.dart';
part 'router_utils/extensions.dart';
part 'router_utils/recursive_iterator.dart';
part 'router_utils/scoped.dart';
part 'router_utils/silver_router_config.dart';
part 'router_utils/silver_router_parser.dart';
part 'router_utils/silver_router_provider.dart';
part 'silver_navigator.dart';
part 'silver_router.dart';

class SilverRouterDelegate extends RouterDelegate<SilverRouteConfiguration>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<SilverRouteConfiguration> {
  SilverRouterDelegate({required this.controller}) {
    controller.addListener(notifyListeners);
  }

  final SilverNavigationController controller;

  @override
  GlobalKey<NavigatorState> get navigatorKey => controller.navigatorKey;
  List<SilverPage> get pages => controller.pages;

  @override
  Future<bool> popRoute() {
    print('popping');
    if (!controller.controls.pop()) {
      controller.controls.quit();
    }
    return SynchronousFuture(true);
  }

  @override
  Future<void> setInitialRoutePath(SilverRouteConfiguration configuration) {
    if (!kIsWeb) return SynchronousFuture(null);
    return super.setInitialRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(SilverRouteConfiguration configuration) async {
    if (!kIsWeb) return SynchronousFuture(null);

    bool willNavigate = await controller.sentinel.shouldNavigate(
      currentConfiguration,
      configuration,
    );

    if (willNavigate) {
      controller.controls.configure(configuration);
    }

    return SynchronousFuture(null);
  }

  @override
  SilverRouteConfiguration get currentConfiguration => controller.configuration;

  @override
  Widget build(BuildContext context) {
    controller.debugPrintStatus();
    return Scoped<SilverNavigationController>.static(
      state: controller,
      child: Navigator(
        key: navigatorKey,
        pages: controller.pages,
        restorationScopeId: 'router-${controller.hashCode}',
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;
          controller.controls._removePage();
          return true;
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
