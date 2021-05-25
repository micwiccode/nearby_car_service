import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby_car_service/models/service.dart';

import 'package:nearby_car_service/consts/services.dart' as DEFAULT_SERVICES;

class ServicesDatabaseService {
  final String workshopUid;
  ServicesDatabaseService({required this.workshopUid});
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('services');

  Future addDefaultServices() async {
    for (dynamic service in DEFAULT_SERVICES.DEFAULT_SERVICES) {
      await collection.add({
        'workshopUid': workshopUid,
        'name': service['name'],
        'minPrice': service['minPrice'],
        'isActive': service['isActive'],
      });
    }
  }

  Future createService(Service service) async {
    return collection.add({
      'workshopUid': workshopUid,
      'name': service.name,
      'minPrice': service.minPrice,
      'isActive': service.isActive,
    });
  }

  Future updateService(Service service) async {
    if (service.uid.length > 0) {
      return collection.doc(service.uid).set({
        'workshopUid': workshopUid,
        'name': service.name,
        'minPrice': service.minPrice,
        'isActive': service.isActive,
      });
    }
  }

  Future updateServices(List<Service> services) async {
    for (Service service in services) {
      await collection.doc(service.uid).set({
        'workshopUid': workshopUid,
        'name': service.name,
        'minPrice': service.minPrice,
        'isActive': service.isActive,
      });
    }
  }

  Future removeService(String serviceUid) async {
    return collection.doc(serviceUid).delete();
  }

  Stream<List<Service>> get services {
    return collection.snapshots().map(_servicesFromSnapshot);
  }

  Stream<List<Service>> get myWorkshopServices {
    return collection
        .where("workshopUid", isEqualTo: workshopUid)
        .snapshots()
        .map(_servicesFromSnapshot);
  }

  List<Service> _servicesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((service) {
      return _mapService(service);
    }).toList();
  }

  Service _mapService(service) {
    return Service(
      uid: service.id,
      workshopUid: workshopUid,
      name: service.data()!['name'] ?? '',
      minPrice: service.data()!['minPrice'] ?? '',
      isActive: service.data()!['isActive'] ?? '',
    );
  }
}
