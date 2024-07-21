part of '../silver_router_delegate.dart';

mixin _RouteControls on _CoreController {
  List<SilverRoute> get routes;

  @override
  SilverRoute routeByName(String name) {
    return SilverRoute.searchNamedRoute(name, routes);
  }
}
