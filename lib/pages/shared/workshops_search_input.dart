import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/address.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/utils/workshop_service.dart';

import 'loading_spinner.dart';

class WorkshopsSearchInput extends StatelessWidget {
  final String label;
  final Workshop? selectedItem;
  final Function onChanged;

  const WorkshopsSearchInput(
      {required this.label,
      required this.selectedItem,
      required this.onChanged,
      Key? key})
      : super(key: key);

  Widget _workshopDropDown(
      BuildContext context, Workshop? workshop, String itemDesignation) {
    return Container(
      child: (workshop == null)
          ? ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text("Workshop"),
            )
          : ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: (workshop.avatar != null &&
                      workshop.avatar!.contains('/storage'))
                  ? CachedNetworkImage(
                      imageUrl: workshop.avatar!,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => LoadingSpinner(),
                    )
                  : Icon(
                      Icons.business_center_outlined,
                      color: Colors.black,
                      size: 25.0,
                    ),
              title: Text(workshop.name),
            ),
    );
  }

  Widget _customPopupItemBuilder(
      BuildContext context, Workshop? workshop, bool isSelected) {
    Address address = workshop!.address!;
    String subtitle =
        "${address.city} ${address.street} ${address.streetNumber}";

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 6),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
        child: ListTile(
          selected: isSelected,
          title: Text(workshop.name),
          subtitle: Text(subtitle),
          dense: true,
          leading:
              (workshop.avatar != null && workshop.avatar!.contains('/storage'))
                  ? CachedNetworkImage(
                      imageUrl: workshop.avatar!,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => LoadingSpinner(),
                    )
                  : Icon(
                      Icons.business_center_outlined,
                      color: Colors.black,
                      size: 25.0,
                    ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: DropdownSearch<Workshop?>(
          label: label,
          validator: (v) => v == null ? "This field is required" : null,
          isFilteredOnline: true,
          maxHeight: 300,
          showClearButton: true,
          showSearchBox: true,
          mode: Mode.BOTTOM_SHEET,
          dropdownBuilder: _workshopDropDown,
          popupItemBuilder: _customPopupItemBuilder,
          onChanged: (data) => onChanged(data),
          selectedItem: selectedItem,
          filterFn: (workshop, filter) => workshop!.userFilterByName(filter),
          onFind: (filter) async {
            return await WorkshopDatabaseService.searchWorkshops(filter);
          },
          itemAsString: (workshop) => workshop!.workshopAsString(),
          searchBoxController: TextEditingController(text: ''),
        ));
    ;
  }
}
