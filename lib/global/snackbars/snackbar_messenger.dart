import '/global/snackbars/messages/info_snackbar_message.dart';
import '../../utils/app_helpers/_app_helper_import.dart';

class SnackBarMessenger<T> {
  ScaffoldMessengerState? get scaffoldMessenger =>
      Messenger().messengerKey.currentState;

  late final infoSnackbar = InfoSnackBarMessage(this);

  void show({required SnackBar snackBar}) {
    pushSnackBar(snackBar);
  }

  void pushSnackBar(SnackBar snackbar) {
    if (scaffoldMessenger != null) {
      scaffoldMessenger!
        ..removeCurrentSnackBar()
        ..showSnackBar(snackbar);
    }
  }
}
