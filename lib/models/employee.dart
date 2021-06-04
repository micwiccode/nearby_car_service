import 'app_user.dart';

class Employee {
  String uid;
  String workshopUid;
  String appUserUid;
  AppUser? appUser;
  String position;
  bool isConfirmed;
  bool isConfirmedByOwner;
  bool isConfirmedByEmployee;

  Employee(
      {this.uid = '',
      this.workshopUid = '',
      this.appUserUid = '',
      this.appUser,
      this.position = '',
      this.isConfirmed = false,
      this.isConfirmedByOwner = false,
      this.isConfirmedByEmployee = false});

  @override
  String toString() =>
      "$uid, $appUserUid, $workshopUid, $appUser, $isConfirmed, $isConfirmedByOwner, $isConfirmedByEmployee, $position";
}
