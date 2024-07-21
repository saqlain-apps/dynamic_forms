part of '../../silver_router_delegate.dart';

abstract class SilverRouteProxy implements SilverRoute {
  SilverRoute get proxyRoute;

  SilverRoute effectiveProxyRoute({dynamic argument, SilverRoute? proxyRoute}) {
    var effectiveProxyRoute = proxyRoute ?? this.proxyRoute;
    if (argument != null) {
      effectiveProxyRoute = effectiveProxyRoute.copyWith(argument: argument);
    }
    return effectiveProxyRoute;
  }

  SilverRoute rootProxy<R extends SilverRoute>() {
    if (proxyRoute is R || proxyRoute is! SilverRouteProxy) {
      return proxyRoute;
    } else {
      return (proxyRoute as SilverRouteProxy).rootProxy<R>();
    }
  }

  SilverRoute copyRootWith<R extends SilverRoute>(R root) {
    var updatedRoute = proxyRoute;

    if (proxyRoute is R || proxyRoute is! SilverRouteProxy) {
      updatedRoute = root;
    } else {
      updatedRoute = (updatedRoute as SilverRouteProxy).copyRootWith(root);
    }

    return copyWith(proxyRoute: updatedRoute);
  }

  @override
  SilverRoute copyWith({argument, SilverRoute? proxyRoute});

  @override
  get argument => proxyRoute.argument;

  @override
  String get name => proxyRoute.name;

  @override
  String get debugName => '$name(${proxyRoute.debugName})';

  @override
  bool identifyName(String name) => proxyRoute.identifyName(name);

  @override
  RouteTransitionsBuilder? get routeTransition => proxyRoute.routeTransition;

  @override
  Widget screen(BuildContext context) => proxyRoute.screen(context);

  @override
  String get urlInfo => proxyRoute.urlInfo;

  @override
  String encodeUrlInfo(String name, String? argument) =>
      proxyRoute.encodeUrlInfo(name, argument);

  @override
  (String, String?) decodeUrlInfo(String urlInfo) =>
      proxyRoute.decodeUrlInfo(urlInfo);

  @override
  String? encodeArgument(argument) => proxyRoute.encodeArgument(argument);

  @override
  FutureOr<dynamic>? decodeArgument(String? argument) =>
      proxyRoute.decodeArgument(argument);

  @override
  FutureOr<SilverRoute> parse(
    BuildContext context,
    String urlInfo, [
    SilverRouteProxy? proxy,
  ]) =>
      proxyRoute.parse(context, urlInfo, proxy ?? this);

  @override
  bool didPop(result) => proxyRoute.didPop(result);

  @override
  bool identifyPath(
    BuildContext context,
    String urlInfo, [
    SilverRouteProxy? proxy,
  ]) =>
      proxyRoute.identifyPath(context, urlInfo, proxy ?? this);

  @override
  SilverPage? get _page => proxyRoute._page;

  @override
  set _page(SilverPage? page) {
    proxyRoute._page = page;
  }

  @override
  SilverPage buildPage<Q>({
    LocalKey? key,
    SilverRouteProxy? proxy,
  }) =>
      proxyRoute.buildPage<Q>(key: key, proxy: proxy ?? this);

  @override
  String get keyInfo => proxyRoute.keyInfo;

  @override
  String get locationInfo => proxyRoute.locationInfo;

  @override
  SilverPage get page => buildPage();

  @override
  Future? get popResult => proxyRoute.popResult;

  @override
  List<SilverRoute> _buildRoute(
    List<SilverRoute> stack, [
    SilverRouteProxy? proxy,
  ]) =>
      proxyRoute._buildRoute(stack, proxy ?? this);

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
}
