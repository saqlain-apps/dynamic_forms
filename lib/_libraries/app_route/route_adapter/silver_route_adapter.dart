import '../../silver_router/silver_router_delegate.dart';
import '../app_route.dart';

abstract class SilverRouteFinder extends AppRouteFinder<SilverRoute> {
  @override
  final RouteAdapter<SilverRoute> adapter = const SilverRouteAdapter();
}

class SilverRouteAdapter extends RouteAdapter<SilverRoute> {
  const SilverRouteAdapter();

  @override
  build(AppRoute route) {
    switch (route) {
      case WebRoute():
        return SilverPageRoute(
          name: route.name,
          builder: (context, arguments) {
            assert(arguments is String?);
            arguments = arguments as String?;
            return route.screenBuilder(context, arguments);
          },
        );
      default:
        return SilverPageRoute(
          name: route.name,
          builder: route.screenBuilder,
        );
    }
  }
}
