part of '../silver_router_delegate.dart';

abstract class _SilverNavigationController extends _InternalController {
  _SilverNavigationController({
    required super.routes,
    required super.initialRoute,
    _NavigationControl Function(ControllerAccess controller)? methods,
    SilverSentinelConfiguration? sentinel,
    super.navigatorKey,
  }) : super(
          methods: methods ?? createControls,
          sentinel: sentinel ?? const SilverSentinel(),
        );

  static _NavigationControl createControls(ControllerAccess controller) {
    return _NavigationControl(controller);
  }
}
