import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/employee.dart';
import 'package:nearby_car_service/models/notification.dart';
import 'package:nearby_car_service/pages/shared/shared_preferences.dart';
import 'user_service.dart';
import 'notifications_service.dart';

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

  Future removeEmployee(Employee employee) async {
    AppNotificationsService notificationService = AppNotificationsService();
    print(employee);
    print(employee.workshopUid);
    print(employee.appUserUid);

    await collection.doc(employee.uid).delete();
    await notificationService.removeEmployeeNotifications(
        senderUid: employee.workshopUid, receiverUserUid: employee.appUserUid);

    print('done');
  }

  Future<void> updateEmployeePosition(
      {required String employeeUid, required String position}) async {
    await collection.doc(employeeUid).update({
      'position': position,
    });
  }

  Future<void> inviteEmployeeToWorkshop(
      {required String email,
      required String position,
      required String currentAppUserUid,
      required BuildContext context,
      bool enableResend = false}) async {
    AppUser? appUser = await AppUserDatabaseService.getAppUserWithEmail(email);

    if (appUser == null) {
      throw 'No user with such email address';
    }

    if (appUser.uid == currentAppUserUid) {
      throw 'You can not add yourself';
    }

    if (workshopUid == null) {
      throw 'No workshopUid provided';
    }

    Employee? alreadyDefinedEmployee = await findAlreadyAddedByOwnerEmployee(
        workshopUid: workshopUid!, appUserUid: appUser.uid);

    if (alreadyDefinedEmployee != null) {
      if (alreadyDefinedEmployee.isConfirmedByOwner &&
          alreadyDefinedEmployee.isConfirmedByEmployee) {
        throw 'User is already your workshop employee';
      } else if (!enableResend) {
        throw 'Invitation was already send to employee';
      }
    }

    Employee employee = Employee(
        workshopUid: workshopUid!,
        appUserUid: appUser.uid,
        position: position,
        isConfirmedByOwner: true);

    await createEmployee(employee);

    AppNotificationsService notificationService = AppNotificationsService();

    AppNotification notification = AppNotification(
        senderUid: workshopUid!,
        type: 'INVITATION',
        receiverUserUid: appUser.uid);

    await notificationService.createAppNotification(notification);
  }

  Future<void> sendRegistrationToWorkshop(
      {required String workshopUid,
      required String position,
      required String appUserUid}) async {
    Employee? employee = await findAlreadyAddedByOwnerEmployee(
        appUserUid: appUserUid, workshopUid: workshopUid);

    if (employee != null) {
      if (employee.isConfirmedByOwner && employee.isConfirmedByEmployee) {
        throw 'You are already an employee of that workshop';
      }

      await acceptWorkshopInvitation(employee.uid);

      AppNotificationsService notificationService = AppNotificationsService();
      await notificationService.removeEmployeeNotifications(
          senderUid: employee.workshopUid,
          receiverUserUid: employee.appUserUid);

      await setSteamPreferencesEmployeeWorkshopUid(workshopUid, appUserUid);
    } else {
      Employee employee = Employee(
          workshopUid: workshopUid,
          appUserUid: appUserUid,
          position: position,
          isConfirmedByEmployee: true);

      await createEmployee(employee);
    }
  }

  Future<void> removeWorkshopEmployees(String workshopUid) async {
    return collection
        .where("workshopUid", isEqualTo: workshopUid)
        .snapshots()
        .forEach((element) {
      for (QueryDocumentSnapshot snapshot in element.docs) {
        snapshot.reference.delete();
      }
    });
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

  Stream<Employee> get employee {
    if (workshopUid == null || appUserUid == null) {
      throw ('No workshopUid or appUserUid provided');
    }
    return collection
        .where("appUserUid", isEqualTo: appUserUid)
        .where("workshopUid", isEqualTo: workshopUid)
        .snapshots()
        .map(_employeeFromSnapshot);
  }

  Stream<List<Employee>> get userEmployees {
    return collection
        .where("appUserUid", isEqualTo: appUserUid)
        .snapshots()
        .map(_employeesFromSnapshot);
  }

  Future<Employee?> getEmployeeByUserAndWorkshop(
      String workshopUid, String appUserUid) {
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

  Employee _employeeFromSnapshot(QuerySnapshot snapshot) {
    QueryDocumentSnapshot doc = snapshot.docs[0];
    return _mapEmployee(doc);
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
