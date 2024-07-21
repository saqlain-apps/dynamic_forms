part of '../silver_router_delegate.dart';

/// Only for debugging Purposes
/// Will not work in release mode
mixin _NavigationDebugMethods on _RootController {
  List<SilverRoute> get debugStack => history;

  void debugPrintStatus() {
    if (kReleaseMode) return;
    var stack = debugStack;

    debugPrint('_' * 80);
    debugPrint('Controller-${navigatorKey.currentState?.hashCode}');
    debugPrint('-' * 80);
    debugPrint('Navigation Stack:');
    debugPrint('Stack Length - ${stack.length}');
    debugPrint('Pages:');
    for (var route in stack) {
      debugPrint('-  ${route.debugName}');
    }
    debugPrint('_' * 80);
  }
}
