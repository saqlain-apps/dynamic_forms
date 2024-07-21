import '/_libraries/extensions.dart';
import '/global/printing.dart';
import 'app_route.dart';

abstract class RouteFinder<T> {
  const RouteFinder();

  List<T> get routes;

  static T? parseArguments<T>(dynamic arguments, [String? route]) {
    var routeName = route ?? 'custom';
    var errorMessage = 'Incorrect Arguments to [$routeName]\n'
        'Argument Required: [$T]\n'
        'Argument Received: [${arguments.runtimeType}]';

    if (arguments is! T) {
      printError(errorMessage);
      return null;
    }

    return arguments;
  }
}

abstract class AppRouteFinder<T> extends RouteFinder<AppRoute> {
  const AppRouteFinder();
  RouteAdapter<T> get adapter;

  @override
  List<AppRoute> get routes;
  List<T> get directRoutes => const [];
  List<T> buildRoutes() => adapter.buildAll(routes) + directRoutes;

  static T? parseArguments<T>(dynamic arguments, [String? route]) =>
      RouteFinder.parseArguments(arguments, route);

  AppRoute routeByName(String name) {
    var route = routes.findWhere((e) => e.name == name);
    assert(route != null, '\'$name\' route not found');
    return route!;
  }
}
