// ignore_for_file: use_build_context_synchronously

part of '../silver_router_delegate.dart';

class SilverRouterParser
    extends RouteInformationParser<SilverRouteConfiguration> {
  const SilverRouterParser({
    required this.routes,
    required this.extendedRoutes,
    required this.nullWebRoute,
  });

  final List<SilverRoute> routes;
  final FutureOr<SilverRoute?> Function(BuildContext context, String urlInfo)?
      extendedRoutes;
  final FutureOr<SilverRoute> Function(BuildContext context)? nullWebRoute;

  @override
  Future<SilverRouteConfiguration> parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext context,
  ) async {
    var original = routeInformation.uri;
    var uri = original;

    // Handle '/'
    if (uri.pathSegments.isEmpty) {
      return parseEmpty(context);
    }

    final routes = await parseUri(context, uri);
    return SynchronousFuture(SilverRouteConfiguration(history: routes));
  }

  @override
  RouteInformation? restoreRouteInformation(
    SilverRouteConfiguration configuration,
  ) {
    return RouteInformation(
      uri: Uri.parse(configuration.history.map((e) => e.locationInfo).join()),
    );
  }

  FutureOr<SilverRouteConfiguration> parseEmpty(BuildContext context) async {
    var config = SilverRouteConfiguration(history: [
      if (nullWebRoute != null) await nullWebRoute!(context),
    ]);

    return SynchronousFuture(config);
  }

  FutureOr<List<SilverRoute>> parseUri(BuildContext context, Uri uri) async {
    var routes = <SilverRoute>[];

    var iterator = RecursiveIterator(uri.pathSegments);
    while (iterator.moveNext()) {
      var parsedRoutes = await parseRoute(context, this.routes, iterator);
      routes.addAll(parsedRoutes);
    }

    return SynchronousFuture(routes);
  }

  FutureOr<List<SilverRoute>> parseRoute(
    BuildContext context,
    List<SilverRoute> source,
    RecursiveIterator<String> iterator,
  ) async {
    final path = iterator.current;
    if (path == null) return SynchronousFuture([]);

    var route = await parsePath(context, path, source);
    if (route == null && extendedRoutes != null) {
      route = await extendedRoutes!(context, path);
    }

    final routes = [
      if (route != null) route,
      if (iterator.moveNext()) ...(await parseRoute(context, source, iterator)),
    ];

    return SynchronousFuture(routes);
  }

  Future<SilverRoute?> parsePath(
    BuildContext context,
    String path,
    List<SilverRoute> source,
  ) async {
    var route = source.findWhere((r) => r.identifyPath(context, path));
    route = await route?.parse(context, path);
    return route;
  }
}
