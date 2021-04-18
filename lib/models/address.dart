class Address {
  String street = '';
  String streetNumber = '';
  String city = '';
  String zipCode = '';

  Address(
      {this.street = '',
      this.streetNumber = '',
      this.city = '',
      this.zipCode = ''});

  @override
  String toString() => "$street, $streetNumber, $city, $zipCode";
}
