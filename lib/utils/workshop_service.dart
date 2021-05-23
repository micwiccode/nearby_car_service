import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby_car_service/models/address.dart';
import 'package:nearby_car_service/models/coords.dart';
import 'package:nearby_car_service/models/workshop.dart';

import 'location_service.dart';

class WorkshopDatabaseService {
  final String appUserUid;
  WorkshopDatabaseService({required this.appUserUid});
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('workshops');

  Future createWorkshop(Workshop workshop) async {
    return collection.add({
      'appUserUid': appUserUid,
      'name': workshop.name,
      'email': workshop.email,
      'phoneNumber': workshop.phoneNumber,
      'address': workshop.address?.toMap(),
      'avatar': workshop.avatar,
    });
  }

  Future updateWorkshop(Workshop workshop) async {
    if (workshop.uid.length > 0) {
      return collection.doc(workshop.uid).set({
        'appUserUid': appUserUid,
        'name': workshop.name,
        'email': workshop.email,
        'phoneNumber': workshop.phoneNumber,
        'address': workshop.address?.toMap(),
        'avatar': workshop.avatar,
      });
    }
  }

  Future removeWorkshop(String workshopUid) async {
    return collection.doc(workshopUid).delete();
  }

  Stream<List<Workshop>> get workshops {
    return collection.snapshots().map(_workshopsFromSnapshot);
  }

  Stream<Workshop> get myWorkshop {
    return collection
        .where("appUserUid", isEqualTo: appUserUid)
        .snapshots()
        .map(_workshopFromSnapshot);
  }

  Workshop _workshopFromSnapshot(QuerySnapshot snapshot) {
    QueryDocumentSnapshot doc = snapshot.docs[0];
    return _mapWorkshop(doc);
  }

  List<Workshop> _workshopsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((w) {
      return _mapWorkshop(w);
    }).toList();
  }

  Workshop _mapWorkshop(w) {
    Map<String, dynamic>? addressMap = w.data()!['address'] ?? null;
    Address address = addressMap != null
        ? Address(
            street: addressMap['street'],
            streetNumber: addressMap['streetNumber'],
            city: addressMap['city'],
            zipCode: addressMap['zipCode'],
            coords: addressMap['coords'] != null
                ? Coords(
                    latitude: addressMap['coords']['latitude'],
                    longitude: addressMap['coords']['longitude'])
                : Coords())
        : Address();

    return Workshop(
      uid: w.id,
      appUserUid: appUserUid,
      name: w.data()!['name'] ?? '',
      email: w.data()!['email'] ?? '',
      phoneNumber: w.data()!['phoneNumber'] ?? '',
      address: address,
      avatar: w.data()!['avatar'] ?? '',
    );
  }
}
