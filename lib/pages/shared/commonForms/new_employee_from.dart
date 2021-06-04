import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/capitalize.dart';
import 'package:nearby_car_service/models/address.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/error_message.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/pages/shared/shared_preferences.dart';
import 'package:nearby_car_service/utils/database.dart';
import 'package:nearby_car_service/utils/employees_service.dart';
import 'package:nearby_car_service/utils/workshop_service.dart';
import 'package:provider/provider.dart';

import 'package:nearby_car_service/consts/employee_positions.dart' as POSITIONS;
import 'package:nearby_car_service/consts/app_user_roles.dart' as ROLES;

class NewEmployeeForm extends StatefulWidget {
  const NewEmployeeForm({Key? key}) : super(key: key);

  @override
  _NewEmployeeFormState createState() => _NewEmployeeFormState();
}

class _NewEmployeeFormState extends State<NewEmployeeForm> {
  late DatabaseService databaseService;
  final GlobalKey<FormState> _employeeFormKey = GlobalKey<FormState>();
  String _error = '';
  bool _isLoading = false;
  Workshop? _selectedWorkshop;
  String _selectedPosition = POSITIONS.MECHANIC;

  bool isValid() {
    return _employeeFormKey.currentState!.validate();
  }

  Future<void> sendRegistrationToWorkshop(String appUserUid) async {
    if (_selectedWorkshop == null) {
      return;
    }

    if (isValid()) {
      setState(() => _isLoading = true);

      String selectedWorkshopUid = _selectedWorkshop!.uid;

      EmployeesDatabaseService employeesDatabaseService =
          EmployeesDatabaseService(workshopUid: selectedWorkshopUid);

      await employeesDatabaseService.sendRegistrationToWorkshop(
          workshopUid: selectedWorkshopUid,
          position: _selectedPosition,
          appUserUid: appUserUid);

      await databaseService.addAppUserRole(ROLES.EMPLOYEE);
      await databaseService.updateAppUserOnboardingStep(4);

      await setPreferencesUserRole(ROLES.EMPLOYEE, appUserUid);

      setState(() => _isLoading = false);
    }
  }

  void setEmployeeWorkshop(workshop) {
    _selectedWorkshop = workshop;
  }

  void setEmployeePosition(postion) {
    _selectedPosition = postion;
  }

  Widget _buildDropdown(String label, selectedItem, items, onChanged) {
    return Padding(
        padding: EdgeInsets.all(20.0),
        child: DropdownSearch(
            label: label,
            items: items,
            validator: (v) => v == null ? "This field is required" : null,
            hint: "Select a country",
            showClearButton: true,
            onChanged: onChanged));
  }

  Widget _buildWorkshopDropdownSearch(
      String label, Workshop? selectedItem, onChanged) {
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
  }

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

  Widget _buildNewEmployeeForm(String appUserUid) {
    return (Container(
        child: Column(children: <Widget>[
      _buildWorkshopDropdownSearch(
          'Workshop', _selectedWorkshop, setEmployeeWorkshop),
      _buildDropdown(
          'Position',
          _selectedPosition,
          POSITIONS.POSITIONS.map((s) => capitalize(s)).toList(),
          setEmployeePosition),
      ErrorMessage(error: _error),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Button(
              text: 'Next',
              onPressed: () => sendRegistrationToWorkshop(appUserUid),
              isLoading: _isLoading)),
    ])));
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    databaseService = DatabaseService(
      uid: appUser!.uid,
    );

    return Form(key: _employeeFormKey, child: _buildNewEmployeeForm(appUser.uid));
  }
}
