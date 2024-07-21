part of '../silver_router_delegate.dart';

class SilverRouterConfig<T extends NavigationMethods>
    implements RouterConfig<SilverRouteConfiguration> {
  SilverRouterConfig({
    required this.initialRoute,
    required this.routes,
    FutureOr<SilverRoute> Function(BuildContext)? nullWebRoute,
    this.extendedRoutes,
    T Function(ControllerAccess)? methodBuilder,
    SilverSentinelConfiguration? sentinel,
    GlobalKey<NavigatorState>? navigatorKey,
  })  : _controller = SilverNavigationController<T>(
          initialRoute: initialRoute,
          routes: routes,
          methods: methodBuilder,
          sentinel: sentinel ?? const SilverSentinel(),
          navigatorKey: navigatorKey,
        ),
        nullWebRoute = nullWebRoute ?? ((context) => initialRoute);

  SilverRouterConfig.named({
    required String initialRoute,
    required this.routes,
    dynamic initialArgument,
    FutureOr<SilverRoute> Function(BuildContext)? nullWebRoute,
    this.extendedRoutes,
    T Function(ControllerAccess)? methodBuilder,
    SilverSentinelConfiguration? sentinel,
    GlobalKey<NavigatorState>? navigatorKey,
  })  : _controller = SilverNavigationController<T>.named(
          initialRoute: initialRoute,
          initialArgument: initialArgument,
          routes: routes,
          methods: methodBuilder,
          sentinel: sentinel ?? const SilverSentinel(),
          navigatorKey: navigatorKey,
        ),
        initialRoute = SilverRoute.searchNamedRoute(initialRoute, routes),
        nullWebRoute = nullWebRoute ??
            ((context) => SilverRoute.searchNamedRoute(initialRoute, routes));

  late final SilverNavigationController<T> _controller;

  final SilverRoute initialRoute;
  final FutureOr<SilverRoute?> Function(BuildContext context, String urlInfo)?
      extendedRoutes;
  final FutureOr<SilverRoute> Function(BuildContext context)? nullWebRoute;
  final List<SilverRoute> routes;

  SilverNavigationController<T> get controller => _controller;

  @override
  late final BackButtonDispatcher? backButtonDispatcher =
      RootBackButtonDispatcher();

  @override
  late final RouteInformationParser<SilverRouteConfiguration>?
      routeInformationParser = SilverRouterParser(
    routes: routes,
    extendedRoutes: extendedRoutes,
    nullWebRoute: nullWebRoute,
  );

  @override
  late final RouteInformationProvider? routeInformationProvider =
      SilverRouterProvider(initialRoute: initialRoute);

  @override
  late final RouterDelegate<SilverRouteConfiguration> routerDelegate =
      SilverRouterDelegate(controller: _controller);
}
