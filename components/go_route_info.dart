import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../lib/utils/app_route/app_route.dart';

class GoRouteInfo extends AppRoute<GoRouterState> {
  const GoRouteInfo(
    super.name,
    super.screenBuilder, {
    String? path,
  }) : path = path ?? '/$name';

  final String path;

  GoRouteInfo copyWith({String? path}) {
    return GoRouteInfo(name, screenBuilder, path: path ?? this.path);
  }

  GoRouteInfo get nest => copyWith(path: name);
}

class GoRouteNamed extends GoRoute {
  GoRouteNamed.raw(
    String name, {
    String? path,
    super.builder,
    super.pageBuilder,
    super.parentNavigatorKey,
    super.redirect,
    super.onExit,
    super.routes = const <RouteBase>[],
  }) : super(name: name, path: path ?? '/$name');

  factory GoRouteNamed(
    GoRouteInfo route, {
    Page<dynamic> Function(BuildContext, GoRouterState)? pageBuilder,
    GlobalKey<NavigatorState>? parentNavigatorKey,
    FutureOr<String?> Function(BuildContext, GoRouterState)? redirect,
    FutureOr<bool> Function(BuildContext)? onExit,
    List<RouteBase> routes = const <RouteBase>[],
  }) {
    return GoRouteNamed.raw(
      route.name,
      path: route.path,
      builder: route.screenBuilder,
      pageBuilder: pageBuilder,
      parentNavigatorKey: parentNavigatorKey,
      redirect: redirect,
      onExit: onExit,
      routes: routes,
    );
  }

  @override
  String get name => super.name!;
}
