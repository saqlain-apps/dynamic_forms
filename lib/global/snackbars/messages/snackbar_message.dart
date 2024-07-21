import '/global/snackbars/snackbar_messenger.dart';
import '/utils/app_helpers/_app_helper_import.dart';

abstract class SnackBarMessage<T> {
  const SnackBarMessage(this.messenger);
  final SnackBarMessenger messenger;

  void show(T message) {
    showAdvanced(
      message: message,
      duration: const Duration(milliseconds: 800),
    );
  }

  void showAdvanced({
    required T message,
    required Duration duration,
    Widget? action,
  }) {
    printMessages(message);
    messenger.show(
      snackBar: build(
        message: message,
        duration: duration,
        action: action,
      ),
    );
  }

  SnackBar build({
    required T message,
    Duration duration = const Duration(milliseconds: 3000),
    Widget? action,
  });
}
