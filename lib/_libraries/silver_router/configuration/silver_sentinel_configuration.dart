part of '../silver_router_delegate.dart';

abstract class SilverSentinelConfiguration {
  const SilverSentinelConfiguration();
  SilverRouteConfiguration redirect(SilverRouteConfiguration config);

  /// False prevents navigation
  FutureOr<bool> shouldNavigate(
    SilverRouteConfiguration currentStack,
    SilverRouteConfiguration newStack,
  );
}

class SilverSentinel extends SilverSentinelConfiguration {
  static SilverRouteConfiguration noRedirection(
          SilverRouteConfiguration config) =>
      config;

  static FutureOr<bool> alwaysNavigate(
    SilverRouteConfiguration currentStack,
    SilverRouteConfiguration newStack,
  ) =>
      SynchronousFuture(true);

  const SilverSentinel({
    this.redirection = noRedirection,
    this.platformNavigation = alwaysNavigate,
  });

  final SilverRouteConfiguration Function(SilverRouteConfiguration config)
      redirection;

  final FutureOr<bool> Function(
    SilverRouteConfiguration currentStack,
    SilverRouteConfiguration newStack,
  ) platformNavigation;

  @override
  SilverRouteConfiguration redirect(SilverRouteConfiguration config) =>
      redirection(config);

  @override
  FutureOr<bool> shouldNavigate(
    SilverRouteConfiguration currentStack,
    SilverRouteConfiguration newStack,
  ) =>
      platformNavigation(currentStack, newStack);
}
