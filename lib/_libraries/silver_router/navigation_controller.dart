part of 'silver_router_delegate.dart';

class NavigationMethods extends _NavigationControl {
  NavigationMethods(super.access);

  String? currentBranchName(String branch) {
    return currentRoute.findWhere((e) => e.identifyName(branch))?.name;
  }

  void branchNamed(String branchName, [bool shouldPush = true]) {
    setNamed({
      ...Map.fromEntries(
        currentRoute.map(
          (e) {
            return MapEntry(
              e.identifyName(branchName) ? branchName : e.name,
              e.argument,
            );
          },
        ),
      ),
    }, shouldPush);
  }

  Future<T?> pushNamed<T>(String routeName, {dynamic argument}) {
    return push<T>(routeByName(routeName), argument: argument);
  }

  Future<T?> replaceNamed<T>(String routeName, {dynamic argument}) {
    return replace(routeByName(routeName), argument: argument);
  }

  void setNamed(Map<String, dynamic> routes, [bool shouldPush = true]) {
    return set(
      routes.entries
          .map((route) => routeByName(route.key).withArgument(route.value))
          .toList(),
      shouldPush,
    );
  }

  Future<T?> push<T>(SilverRoute route, {dynamic argument}) {
    return pushPage<T>(route.withArgument(argument));
  }

  Future<T?> replace<T>(SilverRoute route, {dynamic argument}) {
    return replacePage<T>(route.withArgument(argument));
  }

  void replaceAllNamed(String routeName, {dynamic argument}) {
    replaceAll(routeByName(routeName), argument: argument);
  }

  void replaceAll(SilverRoute route, {dynamic argument}) {
    var pageRoute = route.withArgument(argument);
    _replaceAllPages(pageRoute);
  }

  void _replaceAllPages(SilverRoute route) {
    _clearPages();
    push(route);
  }

  void popAll() {
    _clearPages();
    refresh();
  }
}

typedef NavigationMethodType<T extends NavigationMethods> = T Function(
    ControllerAccess controller);

class SilverNavigationController<T extends NavigationMethods>
    extends _SilverNavigationController {
  SilverNavigationController({
    required super.routes,
    required super.initialRoute,
    NavigationMethodType<T>? methods,
    super.sentinel,
    super.navigatorKey,
  })  : assert((methods ?? createControls) is NavigationMethodType<T>),
        super(methods: methods ?? createControls);

  SilverNavigationController.named({
    required super.routes,
    required String initialRoute,
    dynamic initialArgument,
    NavigationMethodType<T>? methods,
    super.sentinel,
    super.navigatorKey,
  })  : assert((methods ?? createControls) is NavigationMethodType<T>),
        super(
          initialRoute: SilverRoute.searchNamedRoute(initialRoute, routes)
              .withArgument(initialArgument),
          methods: methods ?? createControls,
        );

  @override
  T get controls => super.controls as T;

  static NavigationMethods createControls(ControllerAccess controller) {
    return NavigationMethods(controller);
  }
}
