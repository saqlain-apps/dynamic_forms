import '/_libraries/base_api_repository/base_api.dart';
import '/_libraries/geocoding/models/coordinates.dart';
import '/_libraries/http_services/http_services.dart';
import '../models/weather_condition.dart';

class OpenWeatherFiveDayApi extends BaseApi {
  const OpenWeatherFiveDayApi(super.repository);

  Future<WeatherForecast?> call(Coordinates coordinates, String apiKey) async {
    final now = DateTime.now();
    var res = await raw(coordinates, apiKey);
    return properResponse<WeatherForecast>(
      res,
      statusCode: {200},
      parser: (json) => WeatherForecast.fromMap(json, now),
    );
  }

  Future<HttpResponse> raw(Coordinates coordinates, String apiKey) async {
    return await http.get(
      createRawRequest(
        'https://api.openweathermap.org/data/2.5/forecast',
        queryParams: {
          'lat': coordinates.latitude.toString(),
          'lon': coordinates.longitude.toString(),
          'appid': apiKey,
        },
      ),
    );
  }
}
