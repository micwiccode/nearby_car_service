import 'address.dart';

class Workshop {
  String uid;
  String appUserUid;
  String name;
  Address? address;
  String email;
  String phoneNumber;
  String? avatar;

  Workshop({
    this.uid = '',
    this.appUserUid = '',
    this.name = '',
    this.email = '',
    this.phoneNumber = '',
    this.address,
    this.avatar,
  });

  String workshopAsString() {
    return '$name $email';
  }

  bool userFilterByName(String filter) {
    return name.contains(filter) ||
        address?.city != null &&
            (address!.city.contains(filter) ||
                address!.street.contains(filter));
  }

  @override
  String toString() => "$name, $email, $phoneNumber, $address $avatar";
}
