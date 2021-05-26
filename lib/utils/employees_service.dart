import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/employee.dart';
import 'database.dart';

class EmployeesDatabaseService {
  final String workshopUid;
  EmployeesDatabaseService({required this.workshopUid});
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('employees');

  Future createEmployee(Employee employee) async {
    return collection.add({
      'appUserUid': employee.appUserUid,
      'workshopUid': employee.workshopUid,
      'position': employee.position,
    });
  }

  Future updateEmployee(Employee employee) async {
    if (employee.uid.length > 0) {
      return collection.doc(employee.uid).set({
        'appUserUid': employee.appUserUid,
        'workshopUid': employee.workshopUid,
        'position': employee.position,
      });
    }
  }

  Future removeEmployee(String employeeUid) async {
    await collection.doc(employeeUid).delete();
  }

  Future<void> updateEmployeePosition(
      {required String employeeUid, required String position}) async {
    await collection.doc(employeeUid).set({
      'position': position,
    });
  }

  Future<void> inviteEmployeeToWorkshop(
      {required String email, required String position}) async {
    AppUser? appUser = await DatabaseService.getAppUserWithEmail(email);

    if (appUser == null) {
      throw new Exception('No user with such email address');
    }

    bool hasPendingInvitation = await collection
        .where('appUserUid', isEqualTo: appUser.uid)
        .where('workshopUid', isEqualTo: workshopUid)
        .limit(1)
        .get()
        .then((doc) {
      return doc.docs.length > 0;
    });

    if (hasPendingInvitation) {
      throw new Exception('Invitation was already send');
    }

    await collection.add({
      'appUserUid': appUser.uid,
      'workshopUid': workshopUid,
      'position': position,
      'isConfirmed': false,
    });
  }

  Future<void> acceptWorkshopInvitation(String employeeUid) async {
    await collection.doc(employeeUid).set({'isConfirmed': true});
  }

  Stream<List<Employee>> get employees {
    return collection.snapshots().map(_employeesFromSnapshot);
  }

  Stream<List<Employee>> get workshopConfirmedEmployees {
    return collection
        .where("workshopUid", isEqualTo: workshopUid)
        .where("isConfirmed", isEqualTo: true)
        .snapshots()
        .map(_employeesFromSnapshot);
  }

  Stream<List<Employee>> get workshopPendingEmployees {
    return collection
        .where("workshopUid", isEqualTo: workshopUid)
        .where("isConfirmed", isEqualTo: false)
        .snapshots()
        .map(_employeesFromSnapshot);
  }

  List<Employee> _employeesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((employee) {
      return _mapEmployee(employee);
    }).toList();
  }

  Employee _mapEmployee(employee) {
    return Employee(
      uid: employee.id,
      appUserUid: employee.data()!['appUserUid'] ?? '',
      workshopUid: employee.data()!['workshopUid'] ?? const [],
      position: employee.data()!['position'] ?? '',
      isConfirmed: employee.data()!['isConfirmed'] ?? false,
    );
  }
}
