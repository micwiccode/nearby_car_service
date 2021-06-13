import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nearby_car_service/models/order.dart';

import 'package:nearby_car_service/consts/service_statuses.dart' as STATUSES;
import 'package:nearby_car_service/consts/order_events_types.dart'
    as ORDER_EVENTS;
import 'package:nearby_car_service/models/service.dart';

class OrdersDatabaseService {
  final String? workshopUid;
  final String? appUserUid;
  final String? orderUid;

  OrdersDatabaseService({this.workshopUid, this.appUserUid, this.orderUid});

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
      'events': [
        {'date': DateTime.now(), 'type': ORDER_EVENTS.CREATE}
      ],
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

  Map<String, dynamic> _getStatusTimeMap(String status, String employeeUid) {
    switch (status) {
      case STATUSES.ACCEPTED:
        {
          return {
            'date': DateTime.now(),
            'type': ORDER_EVENTS.ACCEPT,
            'employeeUid': employeeUid
          };
        }

      case STATUSES.IN_PROGRESS:
        {
          return {
            'date': DateTime.now(),
            'type': ORDER_EVENTS.PROGRESS,
            'employeeUid': employeeUid
          };
        }

      case STATUSES.DONE:
        {
          return {
            'date': DateTime.now(),
            'type': ORDER_EVENTS.DONE,
            'employeeUid': employeeUid
          };
        }

      default:
        {
          return {
            'date': DateTime.now(),
            'type': ORDER_EVENTS.CREATE,
            'employeeUid': employeeUid
          };
        }
    }
  }

  Future updateOrderStatus(
      String orderUid, String employeeUid, String status) async {
    return collection.doc(orderUid).update({
      'status': status,
      "events": FieldValue.arrayUnion([_getStatusTimeMap(status, employeeUid)])
    });
  }

  Future addOrderQuestion(String orderUid, String content) async {
    return collection.doc(orderUid).update({
      "events": FieldValue.arrayUnion([
        {
          'date': DateTime.now(),
          'type': ORDER_EVENTS.CLIENT_QUESTION,
          'content': content
        }
      ])
    });
  }

  Future addOrderInfo(
      String orderUid, String employeeUid, String content) async {
    return collection.doc(orderUid).update({
      "events": FieldValue.arrayUnion([
        {
          'date': DateTime.now(),
          'type': ORDER_EVENTS.EMPLOYEE_INFO,
          'content': content
        }
      ])
    });
  }

  Future changeOrderPrice(
    String orderUid,
    String employeeUid,
    String content,
    int price,
  ) async {
    return collection.doc(orderUid).update({
      'price': price,
      "events": FieldValue.arrayUnion([
        {
          'date': DateTime.now(),
          'type': ORDER_EVENTS.CHANGE_PRICE,
          'content': content
        }
      ])
    });
  }

  Future removeOrder(String orderUid) async {
    return collection.doc(orderUid).delete();
  }

  Stream<Order> get order {
    if (orderUid == null) {
      throw ('OrderUid is not provided');
    }
    return collection.doc(orderUid).snapshots().map(_mapOrder);
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

  List<Map<String, dynamic>> _mapEvents(events) {
    List<Map<String, dynamic>> res = [];

    events.forEach((event) => res.add({
          ...event,
          'date': DateTime.fromMicrosecondsSinceEpoch(
              event['date'].microsecondsSinceEpoch)
        }));

    return res;
  }

  Order _mapOrder(order) {
    List<Service> services = _serviceFromMap(order.data()!['services'] ?? []);
    List<Map<String, dynamic>> events =
        _mapEvents(order.data()!['events'] ?? []);

    return Order(
        uid: order.id,
        carUid: order.data()!['carUid'] ?? '',
        appUserUid: order.data()!['appUserUid'] ?? '',
        workshopUid: order.data()!['workshopUid'] ?? '',
        price: order.data()!['price'] ?? '',
        services: services,
        status: order.data()!['isActive'] ?? STATUSES.NEW,
        events: events
        // createdAt: createdAtTimestamp != null
        //     ? DateTime.fromMicrosecondsSinceEpoch(
        //         createdAtTimestamp.microsecondsSinceEpoch)
        //     : null,
        // accepteddAt: accepteddAtTimestamp != null
        //     ? (DateTime.fromMicrosecondsSinceEpoch(
        //         accepteddAtTimestamp.microsecondsSinceEpoch))
        //     : null,
        // progressedAt: progressedAtTimestamp != null
        //     ? (DateTime.fromMicrosecondsSinceEpoch(
        //         progressedAtTimestamp.microsecondsSinceEpoch))
        //     : null,
        // doneAt: doneAtTimestamp != null
        //     ? (DateTime.fromMicrosecondsSinceEpoch(
        //         doneAtTimestamp.microsecondsSinceEpoch))
        //     : null,
        );
  }
}
