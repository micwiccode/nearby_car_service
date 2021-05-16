class AppUser {
  final String uid;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  List<String>? roles;
  String? avatar;
  int? onboardingStep;

  AppUser({
    required this.uid,
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.roles,
    this.avatar,
    this.onboardingStep = 1,
  });

  @override
  String toString() =>
      "$firstName, $lastName, $phoneNumber, $roles, $avatar, $onboardingStep";
}
