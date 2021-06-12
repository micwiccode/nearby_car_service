import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/service.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/services_list.dart';
import 'package:nearby_car_service/utils/services_service.dart';

import 'loading_spinner.dart';

class ServicesView extends StatelessWidget {
  final Workshop workshop;
  final bool isEditable;
  final bool? onlyActive;
  final Function? openServiceForm;

  const ServicesView(
      {required this.workshop,
      required this.isEditable,
      this.openServiceForm,
      this.onlyActive,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String workshopUid = workshop.uid;

    return StreamBuilder<List<Service>>(
      stream: onlyActive == null || !onlyActive!
          ? ServicesDatabaseService(workshopUid: workshopUid).myWorkshopServices
          : ServicesDatabaseService(workshopUid: workshopUid)
              .workshopActiveServices,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingSpinner();
        }

        return ServicesList(
            services: snapshot.data == null ? [] : snapshot.data!,
            isEditable: isEditable,
            openServiceForm: openServiceForm);
      },
    );
  }
}
