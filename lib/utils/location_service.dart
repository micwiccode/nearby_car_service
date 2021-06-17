import 'package:geocoding/geocoding.dart';
import 'package:nearby_car_service/models/coords.dart';

Future<Coords?> getCoordsFromAddress(
    String street, String streetNumber, String city) async {
  List<Location> locations =
      (await locationFromAddress('$street $streetNumber, $city'));

  if (locations.length < 1) {
    return null;
  }

  Location location = locations[0];

  Coords coords =
      Coords(latitude: location.latitude, longitude: location.longitude);

  return coords;
}
