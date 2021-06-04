import 'coords.dart';

class Address {
  String street = '';
  String streetNumber = '';
  String city = '';
  String zipCode = '';
  Coords? coords;

  Address(
      {this.street = '',
      this.streetNumber = '',
      this.city = '',
      this.zipCode = '',
      this.coords});

  @override
  String toString() => "$street, $streetNumber, $city, $zipCode, $coords";

  String getAddressDetails() => "$city $street $streetNumber";

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'streetNumber': streetNumber,
      'city': city,
      'zipCode': zipCode,
      'coords': coords?.toMap(),
    };
  }
}
