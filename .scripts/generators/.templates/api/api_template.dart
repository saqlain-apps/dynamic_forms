import '/_libraries/http_services/http_services.dart';
import '/repositories/api_repository/api.dart';

class <Name>Api extends Api {
  const <Name>Api(super.repository);

  Future<int?> call() async {
    var res = await raw();
    return properResponse<int>(
      res,
      statusCode: {200},
      parser: (json) => json['statusCode'],
    );
  }

  Future<HttpResponse> raw() async {
    return await http.post(
      createRequest(url('/api-endpoint'), body: {}),
    );
  }
}
