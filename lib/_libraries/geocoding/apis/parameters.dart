import '../models/coordinates.dart';

enum LocationFilterType { bias, restrict }

class LocationFilter {
  const LocationFilter({
    required this.center,
    required this.radius,
    required this.type,
  });

  final Coordinates center;
  final double radius;
  final LocationFilterType type;

  Map<String, dynamic> toMap() {
    return {
      switch (type) {
        LocationFilterType.bias => "locationBias",
        LocationFilterType.restrict => "locationRestriction",
      }: {
        "circle": {
          "center": {
            "latitude": center.latitude,
            "longitude": center.longitude,
          },
          "radius": radius,
        }
      }
    };
  }
}
