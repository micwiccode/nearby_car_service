import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/enum_to_list.dart';
import 'package:nearby_car_service/helpers/get_year_to_now.dart';
import 'package:nearby_car_service/models/address.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/app_user_role.dart';
import 'package:nearby_car_service/models/car.dart';
import 'package:nearby_car_service/models/employee.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/text_form_field.dart';
import 'package:nearby_car_service/pages/shared/workshop_avatar.dart';
import 'package:nearby_car_service/utils/database.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:nearby_car_service/consts/app_user_roles.dart' as ROLES;

class OnboardingPage extends StatefulWidget {
  final AppUser? user;
  OnboardingPage({required this.user, Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late DatabaseService databaseService;
  late AppUser _user;
  Workshop _workshop = Workshop(
    name: '',
    email: '',
    phoneNumber: '',
    address: new Address(street: '', streetNumber: '', city: '', zipCode: ''),
  );
  Employee _employee = Employee(workshops: []);
  Car _car = Car();
  int _step = 1;

  final GlobalKey<FormState> _roleSelectFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _userDetailsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _clientFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _employeeFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _ownerFormKey = GlobalKey<FormState>();

  List<Workshop> testWorkshops = <Workshop>[
    Workshop(
        name: '123',
        email: 'email',
        phoneNumber: 'phoneNumber',
        address: Address(
            street: 'street',
            streetNumber: 'streetNum',
            zipCode: '11-111',
            city: 'City')),
    Workshop(
        name: '234',
        email: 'email',
        phoneNumber: 'phoneNumber',
        address: Address(
            street: 'street',
            streetNumber: 'streetNum',
            zipCode: '11-111',
            city: 'City')),
  ];

  void setEmployeeWorkshop(workshop) {
    _employee.workshops = [workshop];
  }

  void setEmployeePosition(postion) {
    _employee.position = postion;
  }

  void changeCarProductionYear(productionYear) {
    _car.productionYear = productionYear;
  }

  void changeCarFuelType(fuelType) {
    _car.fuelType = fuelType;
  }

  Widget getStepView() {
    switch (_step) {
      case 1:
        return Form(key: _userDetailsFormKey, child: buildUserDetailsForm());
      case 2:
        return Form(key: _roleSelectFormKey, child: buildRoleSelect());
      case 3:
        if (_user.roles!.contains(ROLES.CLIENT))
          return Form(key: _clientFormKey, child: buildClientForm());
        else if (_user.roles!.contains(ROLES.EMPLOYEE))
          return Form(key: _employeeFormKey, child: buildEmployeeForm());
        return Form(key: _ownerFormKey, child: buildOwnerForm());
      default:
        return Form(key: _roleSelectFormKey, child: buildRoleSelect());
    }
  }

  Future<void> skipOnboarding() async {
    await databaseService.updateAppUserOnboardingStep(4);
  }

  @override
  Widget build(BuildContext context) {
    void initateOnbordingStep() {
      setState(() => _step = widget.user!.onboardingStep!);
    }

    final appUser = Provider.of<AppUser?>(context);
    databaseService = DatabaseService(uid: appUser!.uid);

    if (widget.user?.onboardingStep != null) {
      setState(() => _user = widget.user!);
      initateOnbordingStep();
    } else {
      setState(() => _user =
          AppUser(uid: appUser.uid, roles: [ROLES.CLIENT], onboardingStep: 2));
    }

    bool isValidStep() {
      if (_step == 1) {
        return _userDetailsFormKey.currentState!.validate();
      }
      if (_step == 2) {
        return true;
      } else {
        switch (_user.roles![0]) {
          case ROLES.CLIENT:
            return _clientFormKey.currentState!.validate();
          case ROLES.EMPLOYEE:
            return _employeeFormKey.currentState!.validate();
          case ROLES.OWNER:
            return _ownerFormKey.currentState!.validate();
          default:
            return _userDetailsFormKey.currentState!.validate();
        }
      }
    }

    Future<void> saveStepState() async {
      if (_step == 1) {
        await databaseService.createAppUser(_user);
      } else if (_step == 2) {
        await databaseService.updateAppUserRole(_user.roles ?? [ROLES.CLIENT]);
      } else {
        // switch (_user.role) {
        //   case AppUserRole.client:
        //     return _clientFormKey.currentState!.validate();
        //   case AppUserRole.employee:
        //     return _employeeFormKey.currentState!.validate();
        //   case AppUserRole.owner:
        //     return _ownerFormKey.currentState!.validate();
        //   default:
        //     return _userDetailsFormKey.currentState!.validate();
        // }
      }
    }

    Future<void> goNext() async {
      if (isValidStep()) {
        await saveStepState();
        setState(() => _step = _step + 1);
      }
    }

    return Container(
        padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          CircularStepProgressIndicator(
            totalSteps: 4,
            currentStep: _step,
            stepSize: 5,
            selectedColor: Colors.amber[700],
            unselectedColor: Colors.grey[200],
            padding: 0,
            width: 60,
            height: 60,
            selectedStepSize: 8,
            roundedCap: (_, __) => true,
          ),
          getStepView(),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: _step < 3
                  ? Button(text: 'Next', onPressed: goNext)
                  : Button(text: 'Save', onPressed: saveStepState)),
        ])));
  }

  Widget buildRoleSelect() {
    return (Container(
        child: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Who you are?',
            style: TextStyle(fontSize: 14),
          )),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Later you will be able to add new role to your account',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )),
      buildRadioButton(
          'Client',
          ROLES.CLIENT,
          (value) => setState(() {
                _user.roles = [value];
              })),
      buildRadioButton(
          'Employee',
          ROLES.EMPLOYEE,
          (value) => setState(() {
                _user.roles = [value];
              })),
      buildRadioButton(
          'Owner',
          ROLES.OWNER,
          (value) => setState(() {
                _user.roles = [value];
              })),
    ])));
  }

  Widget buildUserDetailsForm() {
    return (Container(
        child: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Tell something more about yourself',
            style: TextStyle(fontSize: 14),
          )),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Later you will be able to edit that information',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )),
      buildTextField('First name', _user.firstName,
          (val) => setState(_user.firstName = val)),
      buildTextField(
          'Last name', _user.lastName, (val) => setState(_user.lastName = val)),
      buildTextField('Phone number', _user.phoneNumber,
          (val) => setState(_user.phoneNumber = val),
          onlyDigits: true),
    ])));
  }

  Widget buildClientForm() {
    return (Container(
        child: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Add your car',
            style: TextStyle(fontSize: 14),
          )),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Later you will be able to edit that information',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )),
      buildTextField('Car mark', _car.mark, (val) => setState(_car.mark = val)),
      buildTextField(
          'Car model', _car.model, (val) => setState(_car.model = val)),
      buildDropdown('Fuel', _car.fuelType, enumToList(FuelType.values),
          changeCarFuelType),
      buildDropdown('Production year', _car.productionYear, getYearsToNow(1950),
          changeCarProductionYear),
      GestureDetector(
          onTap: skipOnboarding,
          child: Text("Finish, I'll do it later",
              style: TextStyle(fontWeight: FontWeight.bold))),
    ])));
  }

  Widget buildEmployeeForm() {
    return (Container(
        child: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Find your workshop and specify your position',
            style: TextStyle(fontSize: 14),
          )),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Later you will be able to edit that information',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )),
      buildWorkshopDropdownSearch(
          'Workshop',
          _employee.workshops!.length > 0 ? _employee.workshops![0] : null,
          testWorkshops,
          setEmployeeWorkshop),
      buildDropdown('Position', _employee.position,
          enumToList(EmployeePositions.values), setEmployeePosition),
    ])));
  }

  Widget buildOwnerForm() {
    return (Container(
        child: Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Add your workshop',
            style: TextStyle(fontSize: 14),
          )),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Later you will be able to edit that information',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )),
      buildTextField('Workshop name', _workshop.name,
          (val) => setState(_workshop.name = val)),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Workshop contact',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )),
      buildTextField(
          'Email', _workshop.email, (val) => setState(_workshop.email = val)),
      buildTextField('Phone number', _workshop.phoneNumber,
          (val) => setState(_workshop.phoneNumber = val),
          onlyDigits: true),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Workshop address',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )),
      buildTextField('Street', _workshop.address!.street,
          (val) => setState(_workshop.address!.street = val)),
      buildTextField('Street Number', _workshop.address!.streetNumber,
          (val) => setState(_workshop.address!.streetNumber = val)),
      buildTextField(
        'Zip code',
        _workshop.address!.zipCode,
        (val) => setState(_workshop.address!.zipCode = val),
        onlyDigits: true,
      ),
      buildTextField('City', _workshop.address!.city,
          (val) => setState(_workshop.address!.city = val)),
    ])));
  }

  Widget buildTextField(String text, String? value, onChanged,
      {bool? onlyDigits}) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormFieldWidget(
        labelText: text,
        onChanged: (val) {
          onChanged(val);
        },
        onlyDigits: onlyDigits ?? false,
        functionValidate: (String? value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $text';
          }
          return null;
        },
      ),
    );
  }

  Widget buildRadioButton(String text, String value, onChanged) {
    return RadioListTile<String>(
        title: Text(text),
        value: value,
        groupValue: _user.roles![0],
        onChanged: (val) => onChanged(val));
  }

  Widget buildDropdown(String label, selectedItem, items, onChanged) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: DropdownSearch(
            label: label,
            items: items,
            validator: (v) => v == null ? "This field is required" : null,
            hint: "Select a country",
            showClearButton: true,
            onChanged: onChanged));
  }

  Widget buildWorkshopDropdownSearch(
      String label, selectedItem, items, onChanged) {
    print(selectedItem);
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: DropdownSearch<Workshop?>(
          label: label,
          validator: (v) => v == null ? "This field is required" : null,
          showClearButton: true,
          mode: Mode.BOTTOM_SHEET,
          dropdownBuilder: _workshopDropDown,
          popupItemBuilder: _customPopupItemBuilder,
          onChanged: onChanged,
          selectedItem: selectedItem,
          filterFn: (workshop, filter) => workshop!.userFilterByName(filter),
          onFind: (filter) async => testWorkshops,
          itemAsString: (workshop) => workshop!.workshopAsString(),
          searchBoxController: TextEditingController(text: ''),
          showSearchBox: true,
        ));
  }

  Widget _workshopDropDown(BuildContext context, item, String itemDesignation) {
    return Container(
      child: (item == null)
          ? ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text("Workshp"),
            )
          : ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: WorkshopAvatar(),
              title: Text(item.name),
            ),
    );
  }

  Widget _customPopupItemBuilder(BuildContext context, item, bool isSelected) {
    final address = item.address;
    String subtitle = address != null
        ? "${address.city} ${address.street} ${address.streetNumber}"
        : "";

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
        title: Text(item.name),
        subtitle: Text(subtitle),
        dense: true,
        leading: WorkshopAvatar(avatar: item.avatar, size: 35.0),
      ),
    );
  }
}
