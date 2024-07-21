import 'package:flutter/material.dart';

import '/_libraries/extensions.dart';
import '../app_route.dart';

abstract class PageRouteFinder extends AppRouteFinder<PageRoute> {
  @override
  final RouteAdapter<PageRoute> adapter = const PageRouteAdapter();
  late final List<PageRoute> pageRoutes = buildRoutes();
  Route onGenerateRoute(RouteSettings settings) {
    assert(settings.name != null, 'Route name not provided');
    var pageRoute = pageRoutes.findWhere((e) => e.name == settings.name);
    assert(pageRoute != null, '\'${settings.name}\' route not found');
    return pageRoute!.onGenerate(settings.arguments);
  }
}

class PageRouteAdapter extends RouteAdapter<PageRoute> {
  const PageRouteAdapter();

  @override
  PageRoute build(AppRoute route) {
    if (route is PageRoute) return route;
    return PageRoute(route.name, route.screenBuilder);
  }
}

class PageRoute extends AppRoute {
  const PageRoute(super.name, super.screenBuilder);

  MaterialPageRoute onGenerate(dynamic arguments) {
    return MaterialPageRoute(
      settings: RouteSettings(name: name, arguments: arguments),
      builder: (context) => screenBuilder(context, arguments),
    );
  }
}
