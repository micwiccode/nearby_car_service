import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/notification.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/utils/notifications_service.dart';
import 'package:nearby_car_service/utils/workshop_service.dart';

import 'loading_spinner.dart';

class AppNotificationTile extends StatelessWidget {
  final AppNotification notification;

  const AppNotificationTile({
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> handleAcceptInvitation() async {
      await AppNotificationsService().acceptInvitation(notification.senderUid,
          notification.receiverUserUid, notification.uid);
    }

    Future<void> handleRejectInvitation() async {
      await AppNotificationsService().rejectInvitation(notification.uid);
    }

    return StreamBuilder<Workshop>(
        stream: WorkshopDatabaseService(workshopUid: notification.senderUid)
            .employeeWorkshop,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingSpinner();
          }

          if (snapshot.data == null) {
            return Text('Workshop snapshot error');
          }

          Workshop workshop = snapshot.data!;

          return ListTile(
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                  child: Icon(Icons.check_circle_outline_rounded,
                      color: notification.isRejected
                          ? Colors.black45
                          : Colors.green,
                      size: 35.0),
                  onTap: handleAcceptInvitation),
              GestureDetector(
                  child: Icon(Icons.highlight_remove,
                      color:
                          notification.isRejected ? Colors.black45 : Colors.red,
                      size: 35.0),
                  onTap: handleRejectInvitation)
            ]),
            title: Text(workshop.name,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: notification.isRejected
                        ? Colors.black45
                        : Colors.black)),
            subtitle: Text('You have invitation to workshop',
                style: TextStyle(
                    color: notification.isRejected
                        ? Colors.black45
                        : Colors.black)),
          );
        });
  }
}
