part of '../silver_router_delegate.dart';

mixin _SentinelWatch on _CoreController {
  SilverSentinelConfiguration get sentinel;

  // @override
  // void _configureRoutes(SilverRouteConfiguration configuration) {
  //   super._configureRoutes(sentinel.redirect(configuration));
  // }
}
