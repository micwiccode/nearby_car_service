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
    print(user);
    return await _setAppUser(user);
  }

  Future updateAppUserRole(String role) async {
    return collection.doc(uid).update({'role': role, 'onboardingStep': 3});
  }

  Future updateAppUserOnboardingStep(int step) async {
    return collection.doc(uid).update({'onboardingStep': step});
  }

  Future<void> _setAppUser(AppUser user) {
    return collection.doc(uid).set({
      'firstName': user.firstName,
      'lastName': user.lastName,
      'phoneNumber': user.phoneNumber,
      'role': user.role,
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
      role: snapshot.data()!['role'] ?? '',
      avatar: snapshot.data()!['avatar'] ?? '',
      onboardingStep: snapshot.data()!['onboardingStep'] ?? 1,
    );
  }
}
