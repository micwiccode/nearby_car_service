import 'package:geocoding/geocoding.dart';

Future<List<Location>> getCoordsFromAddress(String address) async {
  return locationFromAddress(address);
}
