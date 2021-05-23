class Coords {
  double latitude;
  double longitude;

  Coords({this.latitude = 0, this.longitude = 0});

  @override
  String toString() => "$latitude, $longitude";

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
