import '/_libraries/_interfaces/error_handler.dart';
import '/utils/app_helpers/_app_helper_import.dart';

abstract class AppErrorHandler implements ErrorHandler {
  const AppErrorHandler();

  @override
  void showError({required String message, String? body}) {
    if (isBlank(message)) return;
    Messenger().notificationMessenger.errorMessage.show(message);
  }
}
