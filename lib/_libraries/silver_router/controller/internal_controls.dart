part of '../silver_router_delegate.dart';

class _NavigationControl extends _NavigationControls {
  _NavigationControl(ControllerAccess access) : _access = access;

  final ControllerAccess _access;

  @override
  SilverRoute routeByName(String name) => _access.routeByName(name);

  @override
  GlobalKey<NavigatorState> get navigatorKey => _access.navigatorKey;

  @override
  SilverRouteConfiguration get configuration => _access.configuration;

  @override
  List<SilverRoute> get navigationStack => _access.navigationStack;

  @override
  void _configureRoutes(SilverRouteConfiguration configuration) =>
      _access._configureRoutes(configuration);

  @override
  void refresh() => _access.refresh();
}

abstract class _NavigationControls extends _InternalPageControls {
  const _NavigationControls();
  void neglectNextHistoryEntry(BuildContext context) {
    Router.neglect(context, () {});
  }

  void createNextHistoryEntry(BuildContext context) {
    Router.navigate(context, () {});
  }

  void setInitialRoute(SilverRoute initialRoute) {
    _setInitialPage(initialRoute);
  }

  void pushAnonymous<T>(SilverRoute route, dynamic argument) {
    route = route.copyWith(argument: argument);
    pushPage<T>(route);
  }

  void configure(SilverRouteConfiguration configuration) {
    _configurePages(configuration);
  }

  void set(List<SilverRoute> routes, [bool shouldPush = true]) {
    _setPages(routes, shouldPush);
  }

  Future<T?> replacePage<T>(SilverRoute route) {
    return _replacePage(route);
  }

  Future<T?> pushPage<T>(SilverRoute route) {
    return _addPage<T>(route);
  }

  bool pop<T>([T? result]) {
    final didPop = canPop();
    if (didPop) navigatorKey.currentState?.pop(result);
    return didPop;
  }
}

abstract class _InternalPageControls extends _InternalRouteControls {
  const _InternalPageControls();
  void quit() => SystemNavigator.pop();
  bool canPop() => _canRemoveRoute;

  void _setInitialPage(SilverRoute initialPage) {
    if (pages.isEmpty) _addRoute(initialPage);
  }

  void _configurePages(SilverRouteConfiguration configuration) {
    _configureRoutes(configuration);
    refresh();
  }

  void _setPages(List<SilverRoute> routes, bool shouldPush) {
    for (var route in routes) {
      route.buildPage();
    }
    _setRoutes(routes);
    if (shouldPush) refresh();
  }

  Future<T?> _addPage<T>(SilverRoute route) async {
    route.buildPage<T>();
    _addRoute(route);
    refresh();
    return await route.popResult as T?;
  }

  Future<T?> _replacePage<T>(SilverRoute route) {
    _removeRoute();
    return _addPage<T>(route);
  }

  void _pop<T>([T? result]) {
    navigatorKey.currentState?.pop(result);
  }

  void _removePage() {
    _removeRoute();
    refresh();
  }

  void _clearPages() {
    _clearRoutes();
    refresh();
  }
}

abstract class _InternalRouteControls extends ControllerAccess {
  const _InternalRouteControls();

  void _setRoutes(List<SilverRoute> routes) {
    final configuration = SilverRouteConfiguration(history: routes.toList());
    _configureRoutes(configuration);
  }

  void _addRoute(SilverRoute route) {
    var routes = history;
    routes.add(route);
    _setRoutes(routes);
  }

  bool get _canRemoveRoute => history.length > 1;

  SilverRoute? _removeRoute() {
    if (configuration.isEmpty) return null;

    var routes = history;
    var route = routes.removeLast();
    _configureRoutes(configuration.copyWith(history: routes));

    return route;
  }

  void _clearRoutes() {
    if (configuration.isEmpty) return;
    _configureRoutes(configuration.copyWith(history: []));
  }
}
