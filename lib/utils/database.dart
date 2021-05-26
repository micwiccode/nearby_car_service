import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby_car_service/models/app_user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  static final CollectionReference collection =
      FirebaseFirestore.instance.collection('appUsers');

  Future createAppUser(AppUser user) async {
    return await _setAppUser(user);
  }

  static Future<AppUser?> getAppUserWithEmail(String email) async {
    return await collection
        .where('email', isEqualTo: email)
        .limit(1)
        .get()
        .then((doc) {
      return doc.docs.map(_appUserFromSnapshot).toList()[0];
    });
  }

  Future updateAppUser(AppUser user) async {
    return await _setAppUser(user);
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

  Future<void> _setAppUser(AppUser user) {
    return collection.doc(uid).set({
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'roles': user.roles,
      'avatar': user.avatar,
      'onboardingStep': user.onboardingStep ?? 1,
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
