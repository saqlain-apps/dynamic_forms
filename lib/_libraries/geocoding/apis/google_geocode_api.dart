import '/_libraries/base_api_repository/base_api.dart';
import '/_libraries/http_services/http_services.dart';
import '../models/coordinates.dart';
import '../models/google_address.dart';

class GoogleGeocodeApi extends BaseApi {
  const GoogleGeocodeApi(super.repository);

  Future<GoogleAddress?> call(Coordinates coordinates, String apiKey) async {
    var res = await raw(coordinates, apiKey);
    return properResponse<GoogleAddress>(
      res,
      statusCode: {200},
      parser: GoogleAddress.fromMap,
    );
  }

  Future<HttpResponse> raw(Coordinates coordinates, String apiKey) async {
    return await http.get(
      createRawRequest(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParams: {
          'latlng': '${coordinates.latitude},${coordinates.longitude}',
          'key': apiKey,
        },
      ),
    );
  }
}
