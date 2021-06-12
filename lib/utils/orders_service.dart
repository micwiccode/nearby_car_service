import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby_car_service/models/order.dart';

import 'package:nearby_car_service/consts/service_statuses.dart' as STATUSES;
import 'package:nearby_car_service/models/service.dart';

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
      'services': order.services.map((service) => service.toMap()).toList(),
      'status': order.status,
      'createdAt': DateTime.now(),
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

  Map<String, DateTime> _getStatusTimeMap(String status) {
    switch (status) {
      case STATUSES.ACCEPTED:
        {
          return {'accepteddAt': DateTime.now()};
        }

      case STATUSES.IN_PROGRESS:
        {
          return {'progressedAt': DateTime.now()};
        }

      case STATUSES.DONE:
        {
          return {'doneAt': DateTime.now()};
        }

      default:
        {
          return {'accepteddAt': DateTime.now()};
        }
    }
  }

  Future updateOrderStatus(String orderUid, String status) async {
    return collection
        .doc(orderUid)
        .update({'status': status, ..._getStatusTimeMap(status)});
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
    if (workshopUid == null) {
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

  List<Service> _serviceFromMap(services) {
    List<Service> res = [];

    services.forEach((s) => res.add(Service(
        uid: s['uid'],
        workshopUid: s['workshopUid'],
        name: s['name'],
        minPrice: s['minPrice'],
        isActive: s['isActive'])));

    return res;
  }

  Order _mapOrder(order) {
    List<Service> services = _serviceFromMap(order.data()!['services'] ?? []);

    dynamic createdAtTimestamp = order.data()!['createdAt'];
    dynamic accepteddAtTimestamp = order.data()!['accepteddAt'];
    dynamic progressedAtTimestamp = order.data()!['progressedAt'];
    dynamic doneAtTimestamp = order.data()!['doneAt'];

    return Order(
      uid: order.id,
      carUid: order.data()!['carUid'] ?? '',
      appUserUid: order.data()!['appUserUid'] ?? '',
      workshopUid: order.data()!['workshopUid'] ?? '',
      price: order.data()!['price'] ?? '',
      services: services,
      status: order.data()!['isActive'] ?? STATUSES.NEW,
      createdAt: createdAtTimestamp != null
          ? DateTime.fromMicrosecondsSinceEpoch(
              createdAtTimestamp.microsecondsSinceEpoch)
          : null,
      accepteddAt: accepteddAtTimestamp != null
          ? (DateTime.fromMicrosecondsSinceEpoch(
              accepteddAtTimestamp.microsecondsSinceEpoch))
          : null,
      progressedAt: progressedAtTimestamp != null
          ? (DateTime.fromMicrosecondsSinceEpoch(
              progressedAtTimestamp.microsecondsSinceEpoch))
          : null,
      doneAt: doneAtTimestamp != null
          ? (DateTime.fromMicrosecondsSinceEpoch(
              doneAtTimestamp.microsecondsSinceEpoch))
          : null,
    );
  }
}
