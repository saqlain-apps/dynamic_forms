part of '../silver_router_delegate.dart';

sealed class SilverRoute with RouteArgument {
  @override
  String get name;
  String get debugName => name;

  @override
  dynamic get argument;

  RouteTransitionsBuilder? get routeTransition;

  Widget screen(BuildContext context);

  SilverPage? _page;
  SilverPage get page => buildPage();

  SilverPage buildPage<T>({LocalKey? key, SilverRouteProxy? proxy}) {
    var obj = proxy ?? this;
    final pageKey = key ?? ValueKey(obj.keyInfo);
    if (obj._page == null || obj._page?.key != pageKey) {
      obj._page = SilverPage<T>.withRoute(route: obj, key: pageKey);
    }
    return obj._page!;
  }

  String get keyInfo => urlInfo;
  String get locationInfo => '/$urlInfo';

  bool didPop(dynamic result) => true;
  Future? get popResult => page.popped;

  List<SilverRoute> _buildRoute(
    List<SilverRoute> stack, [
    SilverRouteProxy? proxy,
  ]) {
    var obj = proxy ?? this;
    return stack..add(obj);
  }

  @override
  String toString() => keyInfo;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other.runtimeType == runtimeType &&
            other is SilverRoute &&
            (identical(other.keyInfo, keyInfo) || other.keyInfo == keyInfo);
  }

  @override
  int get hashCode => keyInfo.hashCode;

  static SilverRoute searchNamedRoute(
    String name,
    List<SilverRoute> routes, {
    bool Function(SilverRoute e)? additionalTest,
    String? errorMessage,
  }) {
    SilverRoute buildRoute(SilverRoute route) {
      return switch (route) {
        SilverBranchedRoute() => route.copyWith(name: name),
        SilverRouteProxy() =>
          route.copyWith(proxyRoute: buildRoute(route.proxyRoute)),
        _ => route,
      };
    }

    var route = routes.findWhere((element) {
      final pass = element.identifyName(name);
      final additionalPass = additionalTest?.call(element) ?? true;
      return pass && additionalPass;
    });
    assert(route != null, errorMessage ?? 'Route $name not found');

    route = buildRoute(route!);

    return route;
  }
}
