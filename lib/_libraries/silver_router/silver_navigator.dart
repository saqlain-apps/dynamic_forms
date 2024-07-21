part of 'silver_router_delegate.dart';

class SilverNavigator<T extends NavigationMethods> extends StatelessWidget {
  const SilverNavigator({required this.controller, super.key});

  final SilverNavigationController<T> controller;

  @override
  Widget build(BuildContext context) {
    return Scoped<SilverNavigationController<T>>.static(
      state: controller,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          controller.debugPrintStatus();
          return Navigator(
            key: controller.navigatorKey,
            pages: controller.pages,
            restorationScopeId: 'scoped-navigator-${controller.hashCode}',
            onPopPage: (route, result) {
              if (!route.didPop(result)) return false;
              controller.controls._pop();
              return true;
            },
          );
        },
      ),
    );
  }

  static SilverNavigationController<T> of<T extends NavigationMethods>(
      BuildContext context) {
    var controller =
        Scoped.maybeOfStatic<SilverNavigationController<T>>(context);
    assert(
        controller != null, 'No SilverNavigationController found in context');
    return controller!;
  }

  static SilverNavigationController<T> ofRoot<T extends NavigationMethods>(
      BuildContext context) {
    var controller =
        Scoped.maybeOfStaticRoot<SilverNavigationController<T>>(context);
    assert(
        controller != null, 'No SilverNavigationController found in context');
    return controller!;
  }
}
