import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nearby_car_service/models/employee.dart';
import 'package:nearby_car_service/models/notification.dart';

import 'employees_service.dart';

class AppNotificationsService {
  final String? receiverUserUid;

  AppNotificationsService({this.receiverUserUid});

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final CollectionReference tokensCollection =
      FirebaseFirestore.instance.collection('tokens');

  final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> createAppNotification(AppNotification notification) async {
    // DocumentSnapshot doc = await tokensCollection.doc(receiverUserUid).get();
    // String token = doc['token'];

    notificationsCollection.add({
      'receiverUserUid': notification.receiverUserUid,
      'senderUid': notification.senderUid,
      'type': notification.type,
      'isSeen': notification.isSeen,
      'isAccepted': notification.isAccepted,
      'isRejected': notification.isRejected,
    });
  }

  Future<void> acceptInvitation(
      String workshopUid, String appUserUid, String notificationUid) async {
    Employee? employee = await EmployeesDatabaseService()
        .findAlreadyAddedByOwnerEmployee(
            workshopUid: workshopUid, appUserUid: appUserUid);

    if (employee == null) {
      throw ('No employee find');
    }
    String employeeUid = employee.uid;

    await EmployeesDatabaseService().acceptWorkshopInvitation(employeeUid);
    return notificationsCollection.doc(notificationUid).update({
      'isAccepted': true,
    });
  }

  Future<void> rejectInvitation(String notificationUid) async {
    return notificationsCollection.doc(notificationUid).update({
      'isRejected': true,
    });
  }

  Future<void> removeWorkshopNotifications(String workshopUid) async {
    return notificationsCollection
        .where("senderUid", isEqualTo: workshopUid)
        .snapshots()
        .forEach((element) {
      for (QueryDocumentSnapshot snapshot in element.docs) {
        snapshot.reference.delete();
      }
    });
  }

  Future<void> removeEmployeeNotifications({
    required String senderUid,
    required String receiverUserUid,
  }) async {
    print(senderUid);
    print(receiverUserUid);
    return await notificationsCollection
        .where("receiverUserUid", isEqualTo: receiverUserUid)
        .where("senderUid", isEqualTo: senderUid)
        .snapshots()
        .forEach((element) {
      if (element.docs.length > 0) {
        element.docs.forEach((QueryDocumentSnapshot snapshot) async {
          await snapshot.reference.delete();
        });
        return;
      }
    });
  }

  Stream<List<AppNotification>> get userNotifications {
    return notificationsCollection
        .where("receiverUserUid", isEqualTo: receiverUserUid)
        .where("isAccepted", isEqualTo: false)
        .snapshots()
        .map(_notificationsFromSnapshot);
  }

  List<AppNotification> _notificationsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((employee) {
      return _mapAppNotification(employee);
    }).toList();
  }

  AppNotification _mapAppNotification(notification) {
    return AppNotification(
      uid: notification.id,
      receiverUserUid: notification.data()!['receiverUserUid'] ?? '',
      senderUid: notification.data()!['senderUid'] ?? '',
      type: notification.data()!['type'] ?? '',
      isSeen: notification.data()!['isSeen'] ?? false,
      isAccepted: notification.data()!['isAccepted'] ?? false,
      isRejected: notification.data()!['isRejected'] ?? false,
    );
  }

  Future initialise() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        AndroidNotificationChannel channel = const AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          'This channel is used for important notifications.', // description
          importance: Importance.high,
        );

        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'launch_background',
              ),
            ));
      }
    });
  }

  Future<String?> getUserdNotificationToken(String appUserUid) async {
    return await _firebaseMessaging.getToken();
  }

  Future<String?> getNotificationToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future saveToken(String appUserUid, String token) async {
    return tokensCollection.doc(appUserUid).set({
      'appUserUid': appUserUid,
      'token': token,
    });
  }

  Future<void> getAndSaveToken(String appUserUid) async {
    String? token = await getNotificationToken();
    if (token != null) {
      await saveToken(appUserUid, token);
    }
  }
}
