import 'app_user.dart';

enum EmployeePositions { coowner, mechanic, mechanicMaster, mechanicAssistant }

class Employee {
  String uid;
  String workshopUid;
  String appUserUid;
  AppUser? appUser;
  String position;
  bool isConfirmed;

  Employee(
      {this.uid = '',
      this.workshopUid = '',
      this.appUserUid = '',
      this.appUser,
      this.position = '',
      this.isConfirmed = false});

  @override
  String toString() =>
      "$uid, $appUserUid, $workshopUid, $appUser, $isConfirmed,  $position";
}
