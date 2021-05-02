import 'app_user_role.dart';

class AppUser {
  final String uid;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? role;
  String? avatar;
  int? onboardingStep;

  AppUser({
    required this.uid,
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.role,
    this.avatar,
    this.onboardingStep = 1,
  });

  @override
  String toString() =>
      "$firstName, $lastName, $phoneNumber, $role, $avatar, $onboardingStep";
}
