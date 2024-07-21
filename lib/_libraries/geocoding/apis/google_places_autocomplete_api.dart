import '/_libraries/base_api_repository/base_api.dart';
import '/_libraries/http_services/http_services.dart';
import '../models/place_prediction.dart';
import 'parameters.dart';

class GooglePlacesAutoCompleteApi extends BaseApi {
  const GooglePlacesAutoCompleteApi(super.repository);

  Future<List<PlacePrediction>?> call(
    String query,
    String apiKey, {
    LocationFilter? filter,
  }) async {
    var res = await raw(query, apiKey, filter);
    return properResponse<List<PlacePrediction>>(
      res,
      statusCode: {200},
      parser: (json) => parseList(
        json['suggestions'],
        (map) => PlacePrediction.fromMap(map['placePrediction']),
      ),
    );
  }

  Future<HttpResponse> raw(
    String query,
    String apiKey,
    LocationFilter? filter,
  ) async {
    return await http.post(
      createRawRequest(
        'https://places.googleapis.com/v1/places:autocomplete',
        headers: {"X-Goog-Api-Key": apiKey},
        body: {
          "input": query,
          if (filter != null) ...filter.toMap(),
        },
      ),
    );
  }
}
