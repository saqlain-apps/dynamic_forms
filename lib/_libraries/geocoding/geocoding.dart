import 'dart:math' as math;

import '/_libraries/base_api_repository/base_api_repository.dart';
import '/_libraries/geocoding/models/place_prediction.dart';
import 'apis/google_geocode_api.dart';
import 'apis/google_places_api.dart';
import 'apis/google_places_autocomplete_api.dart';
import 'apis/google_places_search_api.dart';
import 'apis/parameters.dart';
import 'models/coordinates.dart';
import 'models/google_address.dart';

mixin Geocoding on BaseApiRepository {
  String get geocodingApiKey;
  late final GoogleGeocodeApi _location = GoogleGeocodeApi(this);
  late final GooglePlacesApi _places = GooglePlacesApi(this);
  late final GooglePlacesSearchApi _placesSearch = GooglePlacesSearchApi(this);
  late final GooglePlacesAutoCompleteApi _placesAutoComplete =
      GooglePlacesAutoCompleteApi(this);

  Future<GooglePlace?> fetchPlaceWithId(String id) {
    return _places.call(id, geocodingApiKey);
  }

  Future<List<GooglePlace>?> fetchPlaceWithQuery(String query) {
    return _placesSearch.call(query, geocodingApiKey);
  }

  Future<List<PlacePrediction>?> fetchPlaceAutoComplete(
    String query, {
    LocationFilter? filter,
  }) {
    return _placesAutoComplete.call(query, geocodingApiKey, filter: filter);
  }

  Future<GoogleAddress?> fetchPlaceWithCoordinates(
    Coordinates coordinates,
  ) {
    return _location.call(coordinates, geocodingApiKey);
  }

  Coordinates randomizeCoordinates(
    Coordinates coordinates,
    double maxDistanceInMeters,
  ) {
    double x0 = coordinates.longitude;
    double y0 = coordinates.latitude;

    final random = math.Random();

    // Convert radius from meters to degrees.
    double radiusInDegrees = maxDistanceInMeters / 111320;

    // Get a random distance and a random angle.
    double u = random.nextDouble();
    double v = random.nextDouble();
    double w = radiusInDegrees * math.sqrt(u);
    double t = 2 * math.pi * v;
    // Get the x and y delta values.
    double x = w * math.cos(t);
    double y = w * math.sin(t);

    // Compensate the x value.
    double newX = x / math.cos(y0 * math.pi / 180);

    double foundLatitude;
    double foundLongitude;

    foundLatitude = y0 + y;
    foundLongitude = x0 + newX;

    return Coordinates(
      latitude: foundLatitude,
      longitude: foundLongitude,
    );
  }
}
