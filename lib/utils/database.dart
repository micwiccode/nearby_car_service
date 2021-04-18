import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby_car_service/models/app_user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('appUsers');

  Future createAppUser(firstName, lastName, phoneNumber, role, avatar) async {
    return await _setAppUser(firstName, lastName, phoneNumber, role, avatar);
  }

  Future updateAppUser(firstName, lastName, phoneNumber, role, avatar) async {
    return await _setAppUser(firstName, lastName, phoneNumber, role, avatar);
  }

  Future<void> _setAppUser(firstName, lastName, phoneNumber, role, avatar) {
    return collection.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'role': role,
      'avatar': avatar
    });
  }

  AppUser _appUserFromSnapshot(DocumentSnapshot snapshot) {
    return AppUser(
      uid: uid,
      firstName: snapshot.data()!['firstName'] ?? '',
      lastName: snapshot.data()!['lastName'] ?? '',
      phoneNumber: snapshot.data()!['phoneNumber'] ?? '',
      role: snapshot.data()!['role'] ?? '',
      avatar: snapshot.data()!['avatar'] ?? '',
    );
  }

  Stream<AppUser> get appUser {
    return collection.doc(uid).snapshots().map(_appUserFromSnapshot);
  }
}
