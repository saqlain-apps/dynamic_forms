part of 'silver_router_delegate.dart';

class SilverRouter<T extends NavigationMethods> extends StatelessWidget {
  const SilverRouter({required this.config, super.key});

  final SilverRouterConfig<T> config;
  SilverNavigationController<T> get controller => config.controller;

  @override
  Widget build(BuildContext context) {
    return Scoped<SilverNavigationController<T>>.static(
      state: controller,
      child: Router.withConfig(
        config: config,
        restorationScopeId: 'scoped-router-${controller.hashCode}',
      ),
    );
  }

  static SilverNavigationController<T> of<T extends NavigationMethods>(
      BuildContext context) {
    var controller = Scoped.maybeOf<SilverNavigationController<T>>(context);
    assert(
        controller != null, 'No SilverNavigationController found in context');
    return controller!;
  }

  static SilverNavigationController<T> ofStatic<T extends NavigationMethods>(
      BuildContext context) {
    var controller =
        Scoped.maybeOfStatic<SilverNavigationController<T>>(context);
    assert(
        controller != null, 'No SilverNavigationController found in context');
    return controller!;
  }
}
