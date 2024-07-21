part of '../../silver_router_delegate.dart';

class SilverCustomRoute<T extends SilverRoute> extends SilverRouteProxy {
  SilverCustomRoute({
    required this.route,
    this.urlEncoder,
    this.urlDecoder,
    this.pathIdentifier,
    this.pageKey,
  });

  final T route;

  @override
  T get proxyRoute => route;

  final String Function(String name, String? argument)? urlEncoder;
  final (String, String?) Function(String urlInfo)? urlDecoder;
  final bool Function(BuildContext context, String urlInfo)? pathIdentifier;

  final String? pageKey;

  @override
  String encodeUrlInfo(String name, String? argument) =>
      urlEncoder?.call(name, argument) ?? super.encodeUrlInfo(name, argument);

  @override
  (String, String?) decodeUrlInfo(String urlInfo) =>
      urlDecoder?.call(urlInfo) ?? super.decodeUrlInfo(urlInfo);

  @override
  bool identifyPath(
    BuildContext context,
    String urlInfo, [
    SilverRouteProxy? proxy,
  ]) =>
      pathIdentifier?.call(context, urlInfo) ??
      super.identifyPath(context, urlInfo, proxy);

  @override
  String get keyInfo => pageKey ?? super.keyInfo;

  @override
  SilverCustomRoute copyWith({
    dynamic argument,
    SilverRoute? proxyRoute,
    RouteTransitionsBuilder? routeTransition,
  }) {
    return SilverCustomRoute(
      route: effectiveProxyRoute(
        argument: argument,
        proxyRoute: proxyRoute,
      ),
      urlEncoder: urlEncoder,
      urlDecoder: urlDecoder,
      pathIdentifier: pathIdentifier,
      pageKey: pageKey,
    );
  }
}
