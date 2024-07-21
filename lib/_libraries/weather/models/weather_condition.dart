import '/_libraries/geocoding/models/coordinates.dart';
import '/utils/app_helpers/_app_helper_import.dart';

class WeatherForecast {
  const WeatherForecast({
    required this.time,
    required this.current,
    required this.forecasts,
    required this.city,
  });

  final DateTime time;
  final WeatherCondition current;
  final Map<int, List<WeatherCondition>> forecasts;
  final CityDetails city;

  Map<String, dynamic> toMap() {
    return {
      'time': time.millisecondsSinceEpoch,
      'current': current.toMap(),
      'forecasts': forecasts,
      'city': city.toMap(),
    };
  }

  factory WeatherForecast.fromMap(Map<String, dynamic> map, DateTime time) {
    final forecasts = (map['list'] as List)
        .cast<Map<String, dynamic>>()
        .map(WeatherCondition.fromMap)
        .toList();

    WeatherCondition closest = forecasts.first;
    for (var condition in forecasts) {
      if (condition.time.difference(time).inMinutes <
          closest.time.difference(time).inMinutes) {
        closest = condition;
      }
    }

    return WeatherForecast(
      time: time,
      current: closest,
      forecasts: forecasts.fold({}, (acc, val) {
        final diff = val.time.accumulatedDate - time.accumulatedDate;
        acc.putIfAbsent(diff, () => []);
        acc[diff]!.add(val);
        return acc;
      }),
      city: CityDetails.fromMap(map['city']),
    );
  }
}

class WeatherCondition {
  const WeatherCondition({
    required this.time,
    required this.temp,
    required this.feelsLikeTemp,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.seaLevel,
    required this.groundLevel,
    required this.humidity,
    required this.conditions,
    required this.cloudiness,
    required this.windSpeed,
    required this.windDirection,
    required this.windGust,
    required this.visibility,
    required this.probabilityOfPrecipitation,
    required this.rain,
    required this.snow,
    required this.isDay,
  });

  final DateTime time;
  final double temp;
  final double feelsLikeTemp;
  final double tempMin;
  final double tempMax;
  final double pressure;
  final double seaLevel;
  final double groundLevel;
  final double humidity;

  final Map<String, String> conditions;
  final double cloudiness;

  final double windSpeed;
  final double windDirection;
  final double windGust;

  final double visibility;
  final double probabilityOfPrecipitation;
  final Map<String, num> rain;
  final Map<String, num> snow;
  final bool isDay;

  Map<String, dynamic> toMap() {
    return {
      'time': time.millisecondsSinceEpoch,
      'temp': temp,
      'feelsLikeTemp': feelsLikeTemp,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'pressure': pressure,
      'seaLevel': seaLevel,
      'groundLevel': groundLevel,
      'humidity': humidity,
      'conditions': conditions,
      'cloudiness': cloudiness,
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'windGust': windGust,
      'visibility': visibility,
      'probabilityOfPrecipitation': probabilityOfPrecipitation,
      'rain': rain,
      'snow': snow,
      'isDay': isDay,
    };
  }

  factory WeatherCondition.fromMap(Map<String, dynamic> map) {
    return WeatherCondition(
      time: DateTime.fromMillisecondsSinceEpoch(map['dt'] * 1000).toLocal(),
      temp: map['main']['temp']?.toDouble() ?? 0.0,
      feelsLikeTemp: map['main']['feels_like']?.toDouble() ?? 0.0,
      tempMin: map['main']['temp_min']?.toDouble() ?? 0.0,
      tempMax: map['main']['temp_max']?.toDouble() ?? 0.0,
      pressure: map['main']['pressure']?.toDouble() ?? 0.0,
      seaLevel: map['main']['sea_level']?.toDouble() ?? 0.0,
      groundLevel: map['main']['grnd_level']?.toDouble() ?? 0.0,
      humidity: map['main']['humidity']?.toDouble() ?? 0.0,
      conditions: Map<String, String>.fromEntries((map['weather'] as List)
          .cast<Map<String, dynamic>>()
          .map((e) => MapEntry(e['main'], e['description']))),
      cloudiness: map['clouds']['all']?.toDouble() ?? 0.0,
      windSpeed: map['wind']['speed']?.toDouble() ?? 0.0,
      windDirection: map['wind']['deg']?.toDouble() ?? 0.0,
      windGust: map['wind']['gust']?.toDouble() ?? 0.0,
      visibility: map['visibility']?.toDouble() ?? 0.0,
      probabilityOfPrecipitation: map['pop']?.toDouble() ?? 0.0,
      rain: map['rain'] != null ? Map<String, num>.from(map['rain']) : {},
      snow: map['snow'] != null ? Map<String, num>.from(map['snow']) : {},
      isDay: switch (map['sys']['pod']) {
        "d" => true,
        "n" => false,
        _ => true
      },
    );
  }
}

class CityDetails {
  const CityDetails({
    required this.id,
    required this.name,
    required this.location,
    required this.country,
    required this.population,
    required this.timezone,
    required this.sunrise,
    required this.sunset,
  });

  final int id;
  final String name;
  final Coordinates location;
  final String country;
  final int population;
  final int timezone;
  final DateTime sunrise;
  final DateTime sunset;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location.toMap(),
      'country': country,
      'population': population,
      'timezone': timezone,
      'sunrise': sunrise.millisecondsSinceEpoch,
      'sunset': sunset.millisecondsSinceEpoch,
    };
  }

  factory CityDetails.fromMap(Map<String, dynamic> map) {
    return CityDetails(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      location: Coordinates(
        latitude: map['coord']['lat'],
        longitude: map['coord']['lon'],
      ),
      country: map['country'] ?? '',
      population: map['population']?.toInt() ?? 0,
      timezone: map['timezone']?.toInt() ?? 0,
      sunrise:
          DateTime.fromMillisecondsSinceEpoch(map['sunrise'] * 1000).toLocal(),
      sunset:
          DateTime.fromMillisecondsSinceEpoch(map['sunset'] * 1000).toLocal(),
    );
  }
}
