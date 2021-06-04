import 'package:geocoding/geocoding.dart';
import 'package:nearby_car_service/models/coords.dart';

Future<Coords> getCoordsFromAddress(
    String street, String streetNumber, String city) async {
  Location location =
      (await locationFromAddress('$street $streetNumber, $city'))[0];

  Coords coords =
      Coords(latitude: location.latitude, longitude: location.longitude);

  return coords;
}
