part of '../silver_router_delegate.dart';

// ignore: must_be_immutable
class SilverPage<T> extends SilverRawPage<T> {
  SilverPage({
    required this.route,
    required super.pageBuilder,
    super.name,
    super.arguments,
    super.transitionsBuilder,
    super.transitionDuration,
    super.reverseTransitionDuration,
    super.maintainState = true,
    super.fullscreenDialog = false,
    super.restorationId,
    super.key,
  });

  factory SilverPage.withRoute({required SilverRoute route, LocalKey? key}) {
    return SilverPage<T>(
      route: route,
      name: route.name,
      pageBuilder: (context, animation, secondaryAnimation) {
        return route.screen(context);
      },
      transitionsBuilder: route.routeTransition,
      arguments: route.argument,
      restorationId: key.toString(),
      key: key,
    );
  }

  final SilverRoute route;

  @override
  bool didPop(T? result) => route.didPop(result);
}
