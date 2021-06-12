import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby_car_service/models/order.dart';

import 'package:nearby_car_service/consts/service_statuses.dart' as STATUSES;

class OrdersDatabaseService {
  final String? workshopUid;
  final String? appUserUid;

  OrdersDatabaseService({this.workshopUid, this.appUserUid});

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('orders');

  Future createOrder(Order order) async {
    return collection.add({
      'carUid': order.carUid,
      'appUserUid': order.appUserUid,
      'workshopUid': order.workshopUid,
      'price': order.price,
      'services': order.services,
      'status': order.status,
    });
  }

  Future updateOrder(Order order) async {
    if (order.uid.length > 0) {
      return collection.doc(order.uid).update({
        'carUid': order.carUid,
        'appUserUid': order.appUserUid,
        'workshopUid': order.workshopUid,
        'price': order.price,
        'services': order.services,
        'status': order.status,
      });
    }
  }

  Future removeOrder(String orderUid) async {
    return collection.doc(orderUid).delete();
  }

  Stream<List<Order>> get orders {
    return collection.snapshots().map(_ordersFromSnapshot);
  }

  Stream<List<Order>> get userOrders {
    if (appUserUid == null) {
      throw ('AppUserUid is not provided');
    }

    return collection
        .where("appUserUid", isEqualTo: appUserUid)
        .snapshots()
        .map(_ordersFromSnapshot);
  }

  Stream<List<Order>> get workshopOrders {
    if (appUserUid == null) {
      throw ('WorkshoprUid is not provided');
    }

    return collection
        .where("workshopUid", isEqualTo: workshopUid)
        .snapshots()
        .map(_ordersFromSnapshot);
  }

  List<Order> _ordersFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((order) {
      return _mapOrder(order);
    }).toList();
  }

  Order _mapOrder(service) {
    return Order(
      uid: service.id,
      carUid: service.data()!['carUid'] ?? '',
      appUserUid: service.data()!['appUserUid'] ?? '',
      workshopUid: service.data()!['workshopUid'] ?? '',
      price: service.data()!['price'] ?? '',
      services: service.data()!['services'] ?? [],
      status: service.data()!['isActive'] ?? STATUSES.NEW,
    );
  }
}
