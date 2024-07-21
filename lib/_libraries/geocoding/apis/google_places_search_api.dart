import '/_libraries/base_api_repository/base_api.dart';
import '/_libraries/http_services/http_services.dart';
import '../models/google_address.dart';
import 'parameters.dart';

class GooglePlacesSearchApi extends BaseApi {
  const GooglePlacesSearchApi(super.repository);

  Future<List<GooglePlace>?> call(
    String query,
    String apiKey, {
    LocationFilter? filter,
  }) async {
    var res = await raw(query, apiKey, filter);
    return properResponse<List<GooglePlace>>(
      res,
      statusCode: {200},
      parser: (json) => parseList(json['places'], GooglePlace.fromMap),
    );
  }

  Future<HttpResponse> raw(
    String query,
    String apiKey,
    LocationFilter? filter,
  ) async {
    return await http.post(
      createRawRequest(
        'https://places.googleapis.com/v1/places:searchText',
        headers: {
          "X-Goog-Api-Key": apiKey,
          "X-Goog-FieldMask": [
            "places.id",
            "places.displayName",
            "places.formattedAddress",
            "places.shortFormattedAddress",
            "places.addressComponents",
            "places.location",
            "places.googleMapsUri",
          ].join(","),
        },
        body: {
          "textQuery": query,
          if (filter != null) ...filter.toMap(),
        },
      ),
    );
  }
}
