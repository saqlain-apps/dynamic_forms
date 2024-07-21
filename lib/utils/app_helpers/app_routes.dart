import 'package:dynamic_form/user_interface/screens/form/form_screen.dart';

import '/_libraries/app_route/app_route.dart';
import '/_libraries/app_route/route_adapter/silver_route_adapter.dart';
import '/_libraries/silver_router/silver_router_delegate.dart';
import '/user_interface/screens/home/home_screen.dart';

class AppRoutes extends SilverRouteFinder {
  static final home = WebRoute('home', (_, __) => HomeScreen.provider);
  static final form = WebRoute('form', (_, __) => FormScreen.provider);

  @override
  List<AppRoute> get routes => [home, form];

  @override
  List<SilverRoute> get directRoutes => [];

  AppRoutes._singleton();
  static final AppRoutes _instance = AppRoutes._singleton();
  factory AppRoutes() => _instance;

  static T? parseArguments<T>(dynamic arguments, [String? route]) =>
      AppRouteFinder.parseArguments(arguments, route);
}
