import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby_car_service/models/app_user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('appUsers');

  Future createAppUser(AppUser user) async {
    return await _setAppUser(user);
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

  Future<void> _setAppUser(AppUser user) {
    return collection.doc(uid).set({
      'firstName': user.firstName,
      'lastName': user.lastName,
      'phoneNumber': user.phoneNumber,
      'roles': user.roles,
      'avatar': user.avatar,
      'onboardingStep': user.onboardingStep ?? 1,
    });
  }

  Stream<AppUser> get appUser {
    return collection.doc(uid).snapshots().map(_appUserFromSnapshot);
  }

  AppUser _appUserFromSnapshot(DocumentSnapshot snapshot) {
    return AppUser(
      uid: uid,
      firstName: snapshot.data()!['firstName'] ?? '',
      lastName: snapshot.data()!['lastName'] ?? '',
      phoneNumber: snapshot.data()!['phoneNumber'] ?? '',
      roles: snapshot.data()!['roles'].cast<String>() ?? [],
      avatar: snapshot.data()!['avatar'] ?? '',
      onboardingStep: snapshot.data()!['onboardingStep'] ?? 1,
    );
  }
}
