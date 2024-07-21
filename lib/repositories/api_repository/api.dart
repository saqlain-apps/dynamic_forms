import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '/utils/app_helpers/_app_helper_import.dart';
import '../../_libraries/base_api_repository/base_api.dart';
import '../../_libraries/http_services/http_services.dart';
import 'api_error_handler.dart';
import 'api_repository.dart';

abstract class Api extends BaseApi<ApiRepository> {
  const Api(super.repository);

  @override
  errorHandler(HttpError error) {
    var unhandledError = super.errorHandler(error);
    if (unhandledError == null) return;
    return ApiErrorHandler(unhandledError).handle();
  }

  HttpRequest createRequest(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) {
    1;
    return createRawRequest(
      endpoint,
      body: body != null ? repository.inputInterceptor(body) : null,
      headers: headers,
      queryParams: queryParams,
    );
  }

  String url(String endpoint) => baseUrl + endpoint;
  String get baseUrl => AppKeys.baseUrl;

  String get languageCode =>
      Intl.getCurrentLocale().substring(0, 2).toLowerCase();

  String get platform {
    var platform = switch (defaultTargetPlatform) {
      TargetPlatform.android => 1,
      TargetPlatform.iOS => 2,
      _ => 3
    };
    return platform.toString();
  }
}
