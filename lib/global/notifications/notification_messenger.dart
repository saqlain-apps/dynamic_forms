import '/utils/app_helpers/_app_helper_import.dart';
import '../../_libraries/widgets/notification_messenger/notification_manager.dart';
import '../../_libraries/widgets/scoped.dart';
import 'messages/error_notification_message.dart';

class NotificationMessenger extends NotificationController {
  @override
  OverlayState get overlayState =>
      Messenger().appNavigator.navigatorKey.currentState!.overlay!;

  late final errorMessage = ErrorNotificationMessage(this);

  static NotificationController of(BuildContext context) {
    return Scoped.maybeOfStatic<NotificationController>(context)!;
  }
}
