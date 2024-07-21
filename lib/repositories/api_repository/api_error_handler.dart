import '/repositories/app_error_handler.dart';
import '/utils/app_helpers/_app_helper_import.dart';

class ApiErrorHandler extends AppErrorHandler {
  const ApiErrorHandler(this.body);

  final Map<String, dynamic> body;

  @override
  handle() {
    printError(body);
    showError(message: body['message']);
  }
}
