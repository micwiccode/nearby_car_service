import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby_car_service/models/car.dart';

class CarDatabaseService {
  final String appUserUid;
  CarDatabaseService({required this.appUserUid});
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('cars');

  Future createCar(Car car) async {
    return collection.add({
      'appUserUid': appUserUid,
      'mark': car.mark,
      'model': car.model,
      'fuelType': car.fuelType,
      'productionYear': car.productionYear,
      'avatar': car.avatar,
    });
  }

  Future updateCar(Car car) async {
    if (car.uid.length > 0) {
      return collection.doc(car.uid).update({
        'appUserUid': appUserUid,
        'mark': car.mark,
        'model': car.model,
        'fuelType': car.fuelType,
        'productionYear': car.productionYear,
        'avatar': car.avatar,
      });
    }
  }

  Stream<List<Car>> get cars {
    return collection
        .where("appUserUid", isEqualTo: appUserUid)
        .snapshots()
        .map(_carFromSnapshot);
  }

  List<Car> _carFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((s) {
      return Car(
        uid: s.id,
        appUserUid: appUserUid,
        mark: s.data()!['mark'] ?? '',
        model: s.data()!['model'] ?? '',
        fuelType: s.data()!['fuelType'] ?? '',
        productionYear: s.data()!['productionYear'] ?? '',
        avatar: s.data()!['avatar'] ?? '',
      );
    }).toList();
  }
}
