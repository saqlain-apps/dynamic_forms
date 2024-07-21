import '/utils/app_helpers/_app_helper_import.dart';

class HttpConfiguration {
  const HttpConfiguration();

  String get exceptionSocket => AppStrings.current.exceptionSocket;
  String get exceptionTimeout => AppStrings.current.exceptionTimeout;
  String get exception => AppStrings.current.exception;

  void print(dynamic object) => printRemote(object);
}

extension ExtendedUri on Uri {
  Uri addQueryParameters(Map<String, dynamic> queryParameters) {
    var uri = replace();

    var uriQueryParams = {...uri.queryParametersAll};
    for (var param in queryParameters.entries) {
      if (uriQueryParams.containsKey(param.key)) {
        uriQueryParams[param.key] = [...uriQueryParams[param.key]!];
        uriQueryParams[param.key]!.add(param.value);
      } else {
        if (param.value is Iterable<String>) {
          uriQueryParams[param.key] = param.value.toList();
        } else {
          uriQueryParams[param.key] = [param.value];
        }
      }
    }

    uri = uri.replace(queryParameters: uriQueryParams);
    return uri;
  }
}
