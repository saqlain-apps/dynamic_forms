class PlacePrediction {
  const PlacePrediction({
    required this.id,
    required this.place,
  });

  final String id;
  final String place;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'place': place,
    };
  }

  factory PlacePrediction.fromMap(Map<String, dynamic> map) {
    return PlacePrediction(
      id: map['placeId'] ?? '',
      place: map['text']?['text'] ?? '',
    );
  }
}
