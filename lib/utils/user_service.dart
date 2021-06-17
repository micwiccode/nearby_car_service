import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby_car_service/models/app_user.dart';

import 'package:nearby_car_service/consts/app_user_roles.dart' as ROLES;

class AppUserDatabaseService {
  final String uid;
  AppUserDatabaseService({required this.uid});
  static final CollectionReference collection =
      FirebaseFirestore.instance.collection('appUsers');

  Future createAppUser(AppUser user) async {
    return collection.doc(user.uid).set({
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'roles': user.roles,
      'avatar': user.avatar,
      'onboardingStep': user.onboardingStep ?? 1,
    });
  }

  Future setAppUser(AppUser user) async {
    return collection.doc(user.uid).set({
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'roles': user.roles,
      'avatar': user.avatar,
      'onboardingStep': user.onboardingStep ?? 1,
    });
  }

  static Future<AppUser?> getAppUserWithEmail(String email) async {
    return await collection
        .where('email', isEqualTo: email)
        .limit(1)
        .get()
        .then((doc) {
      List<AppUser> appUsers = doc.docs.map(_appUserFromSnapshot).toList();
      return appUsers.length > 0 ? appUsers[0] : null;
    });
  }

  Future updateAppUser(AppUser user) async {
    return collection.doc(user.uid).update({
      'firstName': user.firstName,
      'lastName': user.lastName,
      'phoneNumber': user.phoneNumber,
      'roles': user.roles,
      'avatar': user.avatar,
      'onboardingStep': user.onboardingStep ?? 1,
    });
  }

  Future<bool> isAppUserExists() async {
    return (await collection.doc(uid).get()).exists;
  }

  Future updateAppUserRole(List<String> roles) async {
    return collection.doc(uid).update({'roles': roles, 'onboardingStep': 3});
  }

  Future updateAppUserOnboardingStep(int step) async {
    return collection.doc(uid).update({'onboardingStep': step});
  }

  Future addAppUserRole(String role) async {
    return collection.doc(uid).update({
      "roles": FieldValue.arrayUnion([role])
    });
  }

  Future addAppUserOwnerEmployeeRole() async {
    return collection.doc(uid).update({
      "roles": FieldValue.arrayUnion([ROLES.OWNER, ROLES.EMPLOYEE])
    });
  }

  Stream<AppUser> get appUser {
    return collection.doc(uid).snapshots().map(_appUserFromSnapshot);
  }

  static AppUser _appUserFromSnapshot(DocumentSnapshot snapshot) {
    return AppUser(
      uid: snapshot.id,
      firstName: snapshot.data()!['firstName'] ?? '',
      lastName: snapshot.data()!['lastName'] ?? '',
      email: snapshot.data()!['email'] ?? '',
      phoneNumber: snapshot.data()!['phoneNumber'] ?? '',
      roles: snapshot.data()!['roles'].cast<String>() ?? [],
      avatar: snapshot.data()!['avatar'] ?? '',
      onboardingStep: snapshot.data()!['onboardingStep'] ?? 1,
    );
  }
}
