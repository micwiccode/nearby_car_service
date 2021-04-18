import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/enum_to_list.dart';
import 'package:nearby_car_service/helpers/get_year_to_now.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/text_form_field.dart';
import 'package:nearby_car_service/pages/shared/workshop_avatar.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:dropdown_search/dropdown_search.dart';

enum UserRole { owner, employee, client }
enum EmployeePositions { coowner, mechanic, mechanicMaster, mechanicAssistant }
enum FuelType { petrol, gas, diesel, hybrid, electric }

class Address {
  String street = '';
  String streetNumber = '';
  String city = '';
  String zipCode = '';

  Address(
      {this.street = '',
      this.streetNumber = '',
      this.city = '',
      this.zipCode = ''});

  @override
  String toString() => "$street, $streetNumber, $city, $zipCode";
}

class Workshop {
  String name;
  Address? address;
  String email;
  String phoneNumber;
  String? avatar;

  Workshop({
    this.name = '',
    this.email = '',
    this.phoneNumber = '',
    this.address,
    this.avatar,
  });

  String workshopAsString() {
    return '#$name $email';
  }

  bool userFilterByName(String filter) {
    return name.contains(filter) ||
        address?.city != null &&
            (address!.city.contains(filter) ||
                address!.street.contains(filter));
  }

  @override
  String toString() => "$name, $email, $phoneNumber, $address $avatar";
}

class Employee {
  List<Workshop>? workshops;
  String position;

  Employee({this.position = '', this.workshops});

  @override
  String toString() => "$workshops, $position";
}

class User {
  String firstName;
  String lastName;
  String phoneNumber;
  UserRole? role;
  String? avatar;

  User({
    this.firstName = '',
    this.lastName = '',
    this.phoneNumber = '',
    this.role,
    this.avatar,
  });

  @override
  String toString() => "$firstName, $lastName, $phoneNumber, $role $avatar";
}

class Car {
  String mark;
  String model;
  FuelType fuelType;
  int? productionYear;

  Car({
    this.mark = '',
    this.model = '',
    this.fuelType = FuelType.petrol,
    this.productionYear,
  });

  @override
  String toString() => "$mark, $model, $fuelType, $productionYear";
}

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  User _user = User(role: UserRole.client);
  Workshop _workshop = Workshop(
    name: '',
    email: '',
    phoneNumber: '',
    address: new Address(street: '', streetNumber: '', city: '', zipCode: ''),
  );
  Employee _employee = Employee(workshops: []);
  Car _car = Car();
  int _step = 2;

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

  void setUser(_userData) {
    setState(() => _user = _userData);
  }

  void setWorkshop(_workshopData) {
    setState(() => _workshop = _workshopData);
  }

  void setEmployee(_employeeData) {
    setState(() => _employee = _employeeData);
  }

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
        if (_user.role == UserRole.client)
          return Form(key: _clientFormKey, child: buildClientForm());
        else if (_user.role == UserRole.employee)
          return Form(key: _employeeFormKey, child: buildEmployeeForm());
        return Form(key: _ownerFormKey, child: buildOwnerForm());
      default:
        return Form(key: _roleSelectFormKey, child: buildRoleSelect());
    }
  }

  void goNext() {
    if (isValidStep()) {
      setState(() => _step = _step + 1);
    }
  }

  void goBack() {
    setState(() => _step < 2 ? 1 : _step--);
  }

  void submitOnboarding() {
    if (isValidStep()) {
      // save into firebase
    }
    print(_user);
    print(_employee);
    print(_car);
    print(_workshop);
  }

  bool isValidStep() {
    if (_step == 1) {
      return _userDetailsFormKey.currentState!.validate();
    }
    if (_step == 2) {
      return true;
    } else {
      switch (_user.role) {
        case UserRole.client:
          return _userDetailsFormKey.currentState!.validate();
        case UserRole.employee:
          return _employeeFormKey.currentState!.validate();
        case UserRole.owner:
          return _ownerFormKey.currentState!.validate();
        default:
          return _userDetailsFormKey.currentState!.validate();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  : Button(text: 'Save', onPressed: submitOnboarding)),
          if (_step > 1)
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Button(text: 'Back', onPressed: goBack))
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
      buildRadioButton('Client', UserRole.client),
      buildRadioButton('Employee', UserRole.employee),
      buildRadioButton('Owner', UserRole.owner),
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
      buildTextField('First name', _user.firstName),
      buildTextField('Last name', _user.lastName),
      buildTextField('Phone number', _user.phoneNumber, onlyDigits: true),
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
      buildTextField('Car mark', _car.mark),
      buildTextField('Car model', _car.model),
      buildDropdown('Fuel', _car.fuelType, enumToList(FuelType.values),
          changeCarFuelType),
      buildDropdown('Production year', _car.productionYear, getYearsToNow(1950),
          changeCarProductionYear)
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
      buildTextField('Workshop name', _workshop.name),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Workshop contact',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )),
      buildTextField('Email', _workshop.email),
      buildTextField('Phone number', _workshop.phoneNumber, onlyDigits: true),
      Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Workshop address',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          )),
      buildTextField('Street', _workshop.address!.street),
      buildTextField('Street Number', _workshop.address!.streetNumber),
      buildTextField('Zip code', _workshop.address!.zipCode, onlyDigits: true),
      buildTextField('City', _workshop.address!.city),
    ])));
  }

  Widget buildTextField(String text, String value, {bool? onlyDigits}) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormFieldWidget(
        labelText: text,
        onChanged: (val) {
          setState(() => value = val);
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

  Widget buildRadioButton(String text, UserRole value) {
    return RadioListTile<UserRole>(
      title: Text(text),
      value: value,
      groupValue: _user.role,
      onChanged: (UserRole? value) {
        setState(() => _user.role = value);
      },
    );
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
