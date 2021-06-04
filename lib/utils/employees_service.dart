import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/employee.dart';
import 'package:nearby_car_service/pages/shared/shared_preferences.dart';
import 'database.dart';
import 'notifications_service.dart';
import 'workshop_service.dart';

class EmployeesDatabaseService {
  final String? workshopUid;
  final String? appUserUid;

  EmployeesDatabaseService({this.workshopUid, this.appUserUid});

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('employees');

  Future<DocumentReference> createEmployee(Employee employee) async {
    return await collection.add({
      'appUserUid': employee.appUserUid,
      'workshopUid': employee.workshopUid,
      'position': employee.position,
      'isConfirmed': employee.isConfirmed,
      'isConfirmedByOwner': employee.isConfirmedByOwner,
      'isConfirmedByEmployee': employee.isConfirmedByEmployee,
    });
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
      throw 'No user with such email address';
    }

    if (workshopUid == null) {
      throw 'No workshopUid provided';
    }

    Employee employee = Employee(
        workshopUid: workshopUid!,
        appUserUid: appUser.uid,
        position: position,
        isConfirmedByOwner: true);

    String employeeUid = (await createEmployee(employee)).id;

    NotificationsService notificationService = NotificationsService();
    await notificationService.createNotification(
        appUser.uid, 'You have a pending invitation to workshop', employeeUid);
  }

  Future<void> sendRegistrationToWorkshop(
      {required String workshopUid,
      required String position,
      required String appUserUid}) async {
    Employee? employee = await findAlreadyAddedByOwnerEmployee(
        appUserUid: appUserUid, workshopUid: workshopUid);

    if (employee != null) {
      await acceptWorkshopInvitation(employee.uid);
      await setPreferencesEmployeeWorkshopUid(workshopUid, appUserUid);
    } else {
      Employee employee = Employee(
          workshopUid: workshopUid,
          appUserUid: appUserUid,
          position: position,
          isConfirmedByEmployee: true);

      String employeeUid = (await createEmployee(employee)).id;

      String receiverUserUid =
          await WorkshopDatabaseService.getWorkshopAppUserUid(workshopUid);

      NotificationsService notificationService = NotificationsService();
      await notificationService.createNotification(
          receiverUserUid, 'Please add me to your workshop', employeeUid);
    }
  }

  Future<Employee?> findAlreadyAddedByOwnerEmployee(
      {required String workshopUid, required String appUserUid}) {
    return collection
        .where("workshopUid", isEqualTo: workshopUid)
        .where("appUserUid", isEqualTo: appUserUid)
        .where("isConfirmedByOwner", isEqualTo: true)
        .limit(1)
        .get()
        .then((QuerySnapshot doc) {
      return doc.docs.length > 0 ? _mapEmployee(doc.docs[0]) : null;
    });
  }

  Future<void> acceptEmployeeRegistration(String employeeUid) async {
    await collection
        .doc(employeeUid)
        .update({'isConfirmedByOwner': true, 'isConfirmed': true});
  }

  Future<void> acceptWorkshopInvitation(String employeeUid) async {
    await collection
        .doc(employeeUid)
        .update({'isConfirmedByEmployee': true, 'isConfirmed': true});
  }

  Stream<List<Employee>> get userEmployees {
    return collection
        .where("appUserUid", isEqualTo: appUserUid)
        .snapshots()
        .map(_employeesFromSnapshot);
  }

  Future<Employee?> getEmployeeByUserAndWorkshop(String workshopUid, String appUserUid ) {
     return collection
        .where("workshopUid", isEqualTo: workshopUid)
        .where("appUserUid", isEqualTo: appUserUid)
        .limit(1)
        .get()
        .then((QuerySnapshot doc) {
      return doc.docs.length > 0 ? _mapEmployee(doc.docs[0]) : null;
    });
  }

  Stream<List<Employee>> get workshopConfirmedEmployees {
    if (workshopUid == null) {
      throw 'No workshopUid provided';
    }

    return collection
        .where("workshopUid", isEqualTo: workshopUid)
        .where("isConfirmed", isEqualTo: true)
        .snapshots()
        .map(_employeesFromSnapshot);
  }

  Stream<List<Employee>> get workshopPendingEmployees {
    if (workshopUid == null) {
      throw 'No workshopUid provided';
    }

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
      isConfirmedByOwner: employee.data()!['isConfirmedByOwner'] ?? false,
      isConfirmedByEmployee: employee.data()!['isConfirmedByEmployee'] ?? false,
    );
  }
}
