import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/pages/shared/workshop_view.dart';
import 'package:nearby_car_service/utils/workshop_service.dart';
import 'package:provider/provider.dart';
import 'package:nearby_car_service/pages/shared/slide_up_manage_panel_content.dart';
import 'package:nearby_car_service/pages/shared/confirm_dialog.dart';
import 'workshop_form_page.dart';

class WorkshopMenuPage extends StatefulWidget {
  const WorkshopMenuPage({Key? key}) : super(key: key);

  @override
  _WorkshopMenuPageState createState() => _WorkshopMenuPageState();
}

class _WorkshopMenuPageState extends State<WorkshopMenuPage> {
  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);
    final WorkshopDatabaseService workshopDatabaseService =
        WorkshopDatabaseService(
      appUserUid: appUser!.uid,
    );

    return StreamBuilder<Workshop>(
      stream: WorkshopDatabaseService(appUserUid: appUser.uid).myWorkshop,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingSpinner();
        }

        if (snapshot.data == null) {
          return Text('No workshop');
        }

        Workshop workshop = snapshot.data!;

        return Scaffold(
            body: SingleChildScrollView(
                child: WorkshopView(
                    openManageModal: () => openManageModal(
                        context: context,
                        workshop: workshop,
                        workshopDatabaseService: workshopDatabaseService),
                    workshop: workshop)));
      },
    );
  }
}

openManageModal(
    {required BuildContext context,
    required Workshop workshop,
    required WorkshopDatabaseService workshopDatabaseService}) {
  void onEditWorkshop() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WorkshopFormPage(
                workshop: workshop,
              )),
    );
  }

  void onRemoveWorkshop() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => ConfirmDialog(
            onAccept: () {
              Navigator.pop(context);
              workshopDatabaseService.removeWorkshop(workshop.uid);
            },
            onDeny: () {
              Navigator.pop(context);
            },
            title: 'Do you really want to remove workshop?'));
  }

  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return SlideUpManagePanel(
          editText: 'Edit workshop',
          removeText: 'Remove workshop',
          handleEdit: () {
            Navigator.pop(context);
            onEditWorkshop();
          },
          handleRemove: () {
            Navigator.pop(context);
            onRemoveWorkshop();
          });
    },
  );
}
