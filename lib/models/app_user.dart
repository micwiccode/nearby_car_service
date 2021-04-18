enum AppUserRole { owner, employee, client }

class AppUser {
  final String uid;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  AppUserRole? role;
  String? avatar;

  AppUser({
    required this.uid,
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.role,
    this.avatar,
  });

  @override
  String toString() => "$firstName, $lastName, $phoneNumber, $role $avatar";
}
