part of '../../silver_router_delegate.dart';

class NestedNavigatorHandler {
  factory NestedNavigatorHandler.original({
    GlobalKey<NavigatorState>? navigatorKey,
    Widget Function(
      BuildContext context,
      List<SilverPage> pages,
      VoidCallback onPop,
      GlobalKey<NavigatorState> navigatorKey,
    )? shellBuilder,
    bool Function(dynamic result, GlobalKey<NavigatorState> navigatorKey)?
        popHandler,
    String? pageKey,
  }) {
    return NestedNavigatorHandler(
      navigatorKey: navigatorKey ?? GlobalKey<NavigatorState>(),
      popHandler: popHandler ?? NestedNavigatorHandler.defaultPopHandler,
      shellBuilder: shellBuilder ?? NestedNavigatorHandler.defaultShellBuilder,
      pageKey: pageKey,
    );
  }

  const NestedNavigatorHandler({
    required this.navigatorKey,
    required this.popHandler,
    required this.shellBuilder,
    this.pageKey,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final String? pageKey;

  final bool Function(dynamic result, GlobalKey<NavigatorState> navigatorKey)
      popHandler;

  final Widget Function(
    BuildContext context,
    List<SilverPage> pages,
    VoidCallback onPop,
    GlobalKey<NavigatorState> navigatorKey,
  ) shellBuilder;

  bool didPopInternally(result) {
    return popHandler(result, navigatorKey);
  }

  Widget buildShell(
    BuildContext context,
    List<SilverPage> pages,
    VoidCallback onPop,
  ) {
    return shellBuilder(context, pages, onPop, navigatorKey);
  }

  String get keyInfo => pageKey ?? navigatorKey.toString();

  static bool defaultPopHandler(
    result,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return true;

    final didPopInternally = navigator.canPop();
    if (didPopInternally) navigator.pop(result);

    return !didPopInternally;
  }

  static Widget defaultShellBuilder(
    BuildContext context,
    List<SilverPage> pages,
    VoidCallback onPop,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    return PopScope(
      canPop: pages.length <= 1,
      child: Navigator(
        key: navigatorKey,
        pages: pages,
        restorationScopeId: 'nested-${navigatorKey.hashCode}',
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;
          onPop();
          return true;
        },
      ),
    );
  }
}

class SilverNestedRoute extends SilverRoute {
  SilverNestedRoute({
    required this.name,
    required this.builder,
    required this.fixedRoute,
    List<SilverShellRoute> Function(String parentRoute)? nestedRoutes,
    this.argumentEncoder,
    this.argumentDecoder,
    this.routeTransition,
    this.argument,
    NestedNavigatorHandler? navigatorHandler,
  }) : navigatorHandler =
            navigatorHandler ?? NestedNavigatorHandler.original() {
    final givenNestedRoutes = nestedRoutes?.call(name);
    final fixedShellRoute = SilverShellRoute(
      shellRoute: fixedRoute.copyWith(argument: argument),
      parentRoute: name,
    );

    if (givenNestedRoutes?.contains(fixedShellRoute) == true) {
      givenNestedRoutes?.remove(fixedShellRoute);
    }

    this.nestedRoutes = [
      fixedShellRoute,
      if (givenNestedRoutes != null) ...givenNestedRoutes
    ].fold([], (acc, val) => _buildInternalRoute(val, acc));
  }

  @override
  final String name;

  @override
  final dynamic argument;

  @override
  String get debugName => '$name>';

  final Function(String? argument)? argumentDecoder;
  final String? Function(dynamic argument)? argumentEncoder;

  @override
  final RouteTransitionsBuilder? routeTransition;

  final Widget Function(
    BuildContext context,
    Widget shell,
    dynamic argument,
  ) builder;

  final NestedNavigatorHandler navigatorHandler;

  final SilverRoute fixedRoute;
  late final List<SilverShellRoute> nestedRoutes;

  @override
  String get keyInfo => navigatorHandler.keyInfo;

  @override
  bool didPop(result) => navigatorHandler.didPopInternally(result);

  @override
  String? encodeArgument(argument) =>
      argumentEncoder?.call(argument) ?? super.encodeArgument(argument);

  @override
  decodeArgument(String? argument) =>
      argumentDecoder?.call(argument) ?? super.decodeArgument(argument);

  SilverNavigationController _controller(BuildContext context) =>
      Scoped.maybeOfStatic<SilverNavigationController>(context)!;

  @override
  Widget screen(BuildContext context) {
    final shell = navigatorHandler.buildShell(
      context,
      nestedRoutes.map((e) => e.shellRoute.page).toList(),
      _controller(context).controls._removePage,
    );
    return builder(context, shell, argument);
  }

  List<SilverShellRoute> _buildInternalRoute(
    SilverShellRoute shell,
    List<SilverShellRoute> stack,
  ) {
    return shell.shellRoute
        ._buildRoute(stack.map((e) => e.shellRoute).toList())
        .map((e) => SilverShellRoute(parentRoute: name, shellRoute: e))
        .toList();
  }

  @override
  SilverNestedRoute copyWith({
    dynamic argument,
    List<SilverShellRoute>? nestedRoutes,
    SilverRoute? fixedRoute,
    RouteTransitionsBuilder? routeTransition,
  }) {
    return SilverNestedRoute(
      name: name,
      builder: builder,
      fixedRoute: fixedRoute ?? this.fixedRoute,
      nestedRoutes: (parent) =>
          nestedRoutes?.map((e) => e.copyWith(parentRoute: parent)).toList() ??
          this.nestedRoutes,
      argumentDecoder: argumentDecoder,
      argumentEncoder: argumentEncoder,
      argument: argument ?? this.argument,
      routeTransition: routeTransition ?? this.routeTransition,
      navigatorHandler: navigatorHandler,
    );
  }
}

class SilverShellRoute<T extends SilverRoute> extends SilverRouteProxy {
  SilverShellRoute({required this.shellRoute, required this.parentRoute});

  final String parentRoute;
  final T shellRoute;

  @override
  T get proxyRoute => shellRoute;

  @override
  String get debugName => '[$parentRoute]:$name';

  @override
  List<SilverRoute> _buildRoute(
    List<SilverRoute> stack, [
    SilverRouteProxy? proxy,
  ]) {
    final shell =
        (proxy?.rootProxy<SilverShellRoute>() ?? this) as SilverShellRoute;
    bool identifyParent(SilverRoute route) =>
        route.identifyName(shell.parentRoute);

    bool parentRouteFinder(SilverRoute e) {
      return switch (e) {
        SilverNestedRoute() => identifyParent(e),
        SilverBranchedRoute() => e.branches.any((e) => parentRouteFinder(e)),
        SilverRouteProxy() => parentRouteFinder(e.proxyRoute),
        _ => false,
      };
    }

    SilverRoute buildParent(SilverRoute parent) {
      switch (parent) {
        case SilverNestedRoute():
          return parent.copyWith(
            nestedRoutes: parent._buildInternalRoute(
              shell,
              parent.nestedRoutes,
            ),
          );

        case SilverBranchedRoute():
          var updatedBranches = parent.branches.toList();
          final originalBranchIndex =
              updatedBranches.indexWhere((e) => identifyParent(e));
          final replacementBranch =
              buildParent(updatedBranches[originalBranchIndex]);

          return parent.copyWith(
            branches: updatedBranches.replaceElementAt(
              originalBranchIndex,
              replacementBranch,
            ),
          );

        case SilverRouteProxy():
          return parent.copyWith(proxyRoute: buildParent(parent.proxyRoute));

        default:
          throw UnimplementedError();
      }
    }

    var parent = stack.findWhere(parentRouteFinder);

    assert(
      parent != null,
      'Before a shell route can be pushed to stack,'
      ' Its parent route must already exist.'
      ' ${shell.name} shell route requires ${shell.parentRoute} parent route.'
      ' The current stack is $stack',
    );

    parent = buildParent(parent!);

    return stack..replaceWhere(parentRouteFinder, parent);
  }

  @override
  SilverShellRoute copyWith({
    dynamic argument,
    SilverRoute? proxyRoute,
    String? parentRoute,
  }) {
    return SilverShellRoute(
      shellRoute: effectiveProxyRoute(
        argument: argument,
        proxyRoute: proxyRoute,
      ),
      parentRoute: parentRoute ?? this.parentRoute,
    );
  }
}
