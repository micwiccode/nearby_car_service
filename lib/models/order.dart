import 'service.dart';

import 'package:nearby_car_service/consts/service_statuses.dart' as STATUSES;

class Order {
  String uid;
  String carUid;
  String appUserUid;
  String workshopUid;
  int price;
  List<Service> services;
  String status;

  Order({
    this.uid = '',
    this.carUid = '',
    this.appUserUid = '',
    this.workshopUid = '',
    this.price = 0,
    this.services = const [],
    this.status = STATUSES.NEW,
  });

  @override
  String toString() => "$uid, $carUid, $appUserUid, $workshopUid, $price, $status,  $services";
}