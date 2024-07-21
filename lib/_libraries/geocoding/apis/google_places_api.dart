import '/_libraries/base_api_repository/base_api.dart';
import '/_libraries/http_services/http_services.dart';
import '../models/google_address.dart';

class GooglePlacesApi extends BaseApi {
  const GooglePlacesApi(super.repository);

  Future<GooglePlace?> call(String id, String apiKey) async {
    var res = await raw(id, apiKey);
    return properResponse<GooglePlace>(
      res,
      statusCode: {200},
      parser: GooglePlace.fromMap,
    );
  }

  Future<HttpResponse> raw(String id, String apiKey) async {
    return await http.get(
      createRawRequest(
        'https://places.googleapis.com/v1/places/$id',
        headers: {
          "X-Goog-Api-Key": apiKey,
          "X-Goog-FieldMask": [
            "id",
            "displayName",
            "formattedAddress",
            "shortFormattedAddress",
            "addressComponents",
            "location",
            "googleMapsUri",
          ].join(","),
        },
      ),
    );
  }
}
