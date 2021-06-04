import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final CollectionReference tokensCollection =
      FirebaseFirestore.instance.collection('tokens');

  final CollectionReference notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> createNotification(String receiverUserUid,
      String notificationText, String employeeUid) async {
    DocumentSnapshot doc = await tokensCollection.doc(receiverUserUid).get();
    String token = doc['token'];

    notificationsCollection.add({
      'token': token,
      'text': notificationText,
      'employeeId': employeeUid,
    });
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
