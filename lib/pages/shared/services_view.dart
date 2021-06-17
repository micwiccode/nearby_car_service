import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/service.dart';
import 'package:nearby_car_service/pages/shared/services_list.dart';
import 'package:nearby_car_service/utils/services_service.dart';

import 'loading_spinner.dart';

class ServicesView extends StatelessWidget {
  final String workshopUid;
  final bool isEditable;
  final bool? onlyActive;
  final Function? onServiceTileTap;

  const ServicesView(
      {required this.workshopUid,
      required this.isEditable,
      this.onServiceTileTap,
      this.onlyActive,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            services: snapshot.data!,
            isEditable: isEditable,
            onServiceTileTap: onServiceTileTap);
      },
    );
  }
}
