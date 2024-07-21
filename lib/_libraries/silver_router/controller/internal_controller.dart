// ignore_for_file: prefer_final_fields

part of '../silver_router_delegate.dart';

abstract class _InternalController extends _CoreController
    with _RouteControls, _SentinelWatch {
  _InternalController({
    required this.routes,
    required SilverRoute initialRoute,
    required this.sentinel,
    required _NavigationControl Function(ControllerAccess controller) methods,
    super.navigatorKey,
  }) {
    controls = methods(this);
    controls.setInitialRoute(initialRoute);
  }

  @override
  final List<SilverRoute> routes;

  @override
  final SilverSentinelConfiguration sentinel;

  @override
  late final _NavigationControls controls;
}

abstract class _CoreController extends _RootController
    with _NavigationDebugMethods {
  _CoreController({super.navigatorKey});

  _InternalPageControls get controls;
}

abstract class _RootController extends ControllerAccess with ChangeNotifier {
  _RootController({GlobalKey<NavigatorState>? navigatorKey})
      : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  NavigatorState? get navigator => navigatorKey.currentState;

  SilverRouteConfiguration _configuration =
      SilverRouteConfiguration(history: []);

  Set<SilverRoute> _navigationStack = {};

  @override
  SilverRouteConfiguration get configuration =>
      SilverRouteConfiguration.copy(_configuration);

  @override
  void _configureRoutes(SilverRouteConfiguration configuration) {
    _configuration = SilverRouteConfiguration.copy(configuration);
    _navigationStack = _buildStack();
  }

  Set<SilverRoute> _buildStack() {
    List<SilverRoute> stack =
        history.fold([], (acc, val) => val._buildRoute(acc));
    return stack.reversed.toSet().toList().reversed.toSet();
  }

  @override
  List<SilverRoute> get navigationStack => _navigationStack.toList();

  @override
  void refresh() => notifyListeners();

  // ignore: unused_field
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;

    super.dispose();
  }
}

abstract class ControllerAccess {
  const ControllerAccess();

  GlobalKey<NavigatorState> get navigatorKey;

  void refresh();

  SilverRoute routeByName(String name);
  void _configureRoutes(SilverRouteConfiguration configuration);
  SilverRouteConfiguration get configuration;
  List<SilverRoute> get history => configuration.history;

  List<SilverRoute> get navigationStack;

  List<SilverRoute> get currentRoute => history;
  List<SilverPage> get _pages => navigationStack.map((e) => e.page).toList();
  List<SilverPage> get pages => List.unmodifiable(_pages);
}
