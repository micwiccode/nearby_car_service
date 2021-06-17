import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby_car_service/models/car.dart';

class CarDatabaseService {
  final String? appUserUid;
  final String? carUid;

  CarDatabaseService({this.appUserUid, this.carUid});
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

  Stream<Car> get car {
    if (carUid == null) {
      throw 'CarUid not provided';
    }
    return collection.doc(carUid).snapshots().map(_carFromSnapshot);
  }

  Stream<List<Car>> get cars {
    if (appUserUid == null) {
      throw 'AppUserUid not provided';
    }
    return collection
        .where("appUserUid", isEqualTo: appUserUid)
        .snapshots()
        .map(_carsFromSnapshot);
  }

  Car _carFromSnapshot(car) {
    return Car(
      uid: car.id,
      appUserUid: car.data()!['appUserUid'] ?? '',
      mark: car.data()!['mark'] ?? '',
      model: car.data()!['model'] ?? '',
      fuelType: car.data()!['fuelType'] ?? '',
      productionYear: car.data()!['productionYear'] ?? '',
      avatar: car.data()!['avatar'] ?? '',
    );
  }

  List<Car> _carsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((car) => _carFromSnapshot(car)).toList();
  }
}
