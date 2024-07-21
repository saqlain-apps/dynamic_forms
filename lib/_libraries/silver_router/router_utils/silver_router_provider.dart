part of '../silver_router_delegate.dart';

class SilverRouterProvider extends PlatformRouteInformationProvider {
  SilverRouterProvider({required this.initialRoute})
      : super(initialRouteInformation: updatedLocation(initialRoute));

  final SilverRoute? initialRoute;

  static RouteInformation updatedLocation(SilverRoute? route) {
    final location = route?.locationInfo;
    final uri = route != null ? Uri.parse('/$location') : null;
    return RouteInformation(uri: _effectiveInitialLocation(uri));
  }

  static Uri _effectiveInitialLocation(Uri? initialLocation) {
    var platformDefault =
        Uri.parse(WidgetsBinding.instance.platformDispatcher.defaultRouteName);

    if (initialLocation == null) {
      return platformDefault;
    } else if (platformDefault.path == '/') {
      return initialLocation;
    } else {
      return platformDefault;
    }
  }
}
