import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/service.dart';
import 'package:nearby_car_service/pages/shared/confirm_dialog.dart';
import 'package:nearby_car_service/pages/shared/services_view.dart';
import 'package:provider/provider.dart';

class SerivcesMenuPage extends StatefulWidget {
  const SerivcesMenuPage({Key? key}) : super(key: key);

  @override
  _SerivcesMenuPageState createState() => _SerivcesMenuPageState();
}

class _SerivcesMenuPageState extends State<SerivcesMenuPage> {
  @override
  Widget build(BuildContext context) {
    final workshopUid = Provider.of<String?>(context);

    if (workshopUid == null) {
      return Text('No workshopUid provided');
    }

    void handleOpenAlertDialog(Service service) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => ConfirmDialog(
              title:
                  "You can't edit service ${service.name}, please contact workshop owner"));
    }

    return Scaffold(
      body: ServicesView(
          workshopUid: workshopUid,
          onServiceTileTap: handleOpenAlertDialog,
          isEditable: false),
    );
  }
}
