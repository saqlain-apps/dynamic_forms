import '/repositories/app_error_handler.dart';
import '/utils/app_helpers/_app_helper_import.dart';
import '../../_libraries/http_services/http_services.dart';

class ApiExceptionHandler extends AppErrorHandler {
  const ApiExceptionHandler(this.error);
  final HttpError error;

  @override
  dynamic handle() {
    if (error.exception != null) {
      printError(error.exception);
      showError(message: error.message);
    } else {
      return error.body;
    }
  }
}
