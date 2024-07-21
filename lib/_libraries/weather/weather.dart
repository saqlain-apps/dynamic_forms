import '/_libraries/base_api_repository/base_api_repository.dart';
import '/_libraries/geocoding/models/coordinates.dart';
import 'apis/open_weather_five_day_api.dart';
import 'models/weather_condition.dart';

mixin Weather on BaseApiRepository {
  String get weatherApiKey;
  late final OpenWeatherFiveDayApi _fiveDayForecast =
      OpenWeatherFiveDayApi(this);

  Future<WeatherForecast?> weatherForecastFromNow(Coordinates coordinates) {
    return _fiveDayForecast.call(coordinates, weatherApiKey);
  }
}
