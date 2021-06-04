import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby_car_service/models/address.dart';
import 'package:nearby_car_service/models/coords.dart';
import 'package:nearby_car_service/models/workshop.dart';

class WorkshopDatabaseService {
  final String? appUserUid;
  final String? workshopUid;

  WorkshopDatabaseService({this.appUserUid, this.workshopUid});

  static final CollectionReference collection =
      FirebaseFirestore.instance.collection('workshops');

  static Future<List<Workshop>> searchWorkshops(String input) async {
    List<Workshop> res = await collection
        .where("searchKeys", arrayContains: input.toLowerCase())
        .get()
        .then((doc) {
      return _workshopsFromSnapshot(doc);
    });

    return res;
  }

  static Future<List<dynamic>> searchWorkshopsPrompt(String input) async {
    return collection
        .where("promptSearchKeys", arrayContains: input.toLowerCase())
        .get()
        .then((doc) {
      return doc.docs;
    });
  }

  static Future<String> getWorkshopAppUserUid(String workshopUid) async {
    DocumentSnapshot doc = await collection.doc(workshopUid).get();
    String workshopAppUserUid = doc['appUserUid'];
    return workshopAppUserUid;
  }

  Future<DocumentReference> createWorkshop(Workshop workshop) async {
    return collection.add({
      'appUserUid': appUserUid,
      'name': workshop.name,
      'email': workshop.email,
      'phoneNumber': workshop.phoneNumber,
      'address': workshop.address?.toMap(),
      'avatar': workshop.avatar,
      'searchKeys':
          getSearchKeys(name: workshop.name, city: workshop.address!.city),
      'promptSearchKeys': getPromptSearchKeys(workshop.name),
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

  Stream<Workshop> get employeeWorkshop {
    return collection.doc(workshopUid).snapshots().map(_mapWorkshop);
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

  static Workshop _workshopFromSnapshot(QuerySnapshot snapshot) {
    QueryDocumentSnapshot doc = snapshot.docs[0];
    return _mapWorkshop(doc);
  }

  static List<Workshop> _workshopsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((w) {
      return _mapWorkshop(w);
    }).toList();
  }

  static Workshop _mapWorkshop(w) {
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
      appUserUid: w.data()!['appUserUid'] ?? '',
      name: w.data()!['name'] ?? '',
      email: w.data()!['email'] ?? '',
      phoneNumber: w.data()!['phoneNumber'] ?? '',
      address: address,
      avatar: w.data()!['avatar'] ?? '',
    );
  }

  static List<String> getSearchKeys(
      {required String name, required String city}) {
    List<String> keys = [];
    for (int i = 0; i <= name.length - 3; i++) {
      keys.add(name.substring(0, i + 3).toLowerCase());
    }
    for (int i = 0; i <= city.length - 3; i++) {
      keys.add(name.substring(0, i + 3).toLowerCase());
    }
    return keys;
  }

  static List<String> getPromptSearchKeys(String name) {
    List<String> keys = [];
    for (int i = 0; i <= name.length - 3; i++) {
      keys.add(name.substring(0, i + 3).toLowerCase());
    }

    return keys;
  }
}
