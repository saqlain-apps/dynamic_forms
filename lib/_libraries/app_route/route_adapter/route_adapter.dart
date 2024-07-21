import '../app_route.dart';

abstract class RouteAdapter<T> {
  const RouteAdapter();

  T build(AppRoute route);
  List<T> buildAll(List<AppRoute> routes) =>
      routes.map((e) => build(e)).toList();
}
