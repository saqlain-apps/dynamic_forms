import 'package:flutter/material.dart';

export 'app_route_finder.dart';
export 'route_adapter/route_adapter.dart';

class AppRoute<T> {
  const AppRoute(this.name, this.screenBuilder);
  final String name;
  final Widget Function(BuildContext context, T? arguments) screenBuilder;

  @override
  String toString() => name;
}

class WebRoute extends AppRoute<String> {
  const WebRoute(super.name, super.screenBuilder);
}
