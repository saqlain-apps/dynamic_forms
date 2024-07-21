import '/utils/app_helpers/_app_helper_import.dart';
import '../_libraries/silver_router/silver_router_delegate.dart';
import 'app_navigator.dart';
import 'notifications/notification_messenger.dart';
import 'snackbars/snackbar_messenger.dart';

class Messenger {
  Messenger._singleton();
  static final Messenger _instance = Messenger._singleton();
  factory Messenger() => _instance;

  final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey();
  final SnackBarMessenger snackbarMessenger = SnackBarMessenger();
  final NotificationMessenger notificationMessenger = NotificationMessenger();

  final AppNavigator appNavigator = AppNavigator();
  NavigationMethods get navigator => appNavigator.navigator;
}
