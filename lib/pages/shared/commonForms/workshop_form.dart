import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/is_email_valid.dart';
import 'package:nearby_car_service/helpers/upload_image.dart';
import 'package:nearby_car_service/models/address.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/coords.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/error_message.dart';
import 'package:nearby_car_service/pages/shared/shared_preferences.dart';
import 'package:nearby_car_service/pages/shared/text_form_field.dart';
import 'package:nearby_car_service/pages/shared/workshop_avatar.dart';
import 'package:nearby_car_service/utils/database.dart';
import 'package:nearby_car_service/utils/location_service.dart';
import 'package:nearby_car_service/utils/workshop_service.dart';
import 'package:nearby_car_service/utils/services_service.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:nearby_car_service/consts/app_user_roles.dart' as ROLES;

class WorkshopForm extends StatefulWidget {
  final Workshop? workshop;
  final Function? onSubmitSuccess;

  WorkshopForm({this.workshop, this.onSubmitSuccess, Key? key})
      : super(key: key);

  @override
  _WorkshopFormState createState() => _WorkshopFormState();
}

class _WorkshopFormState extends State<WorkshopForm> {
  String error = '';
  bool _isLoading = false;
  String _avatar = '';
  TextEditingController _nameController = TextEditingController(text: '');
  TextEditingController _phoneNumberController =
      TextEditingController(text: '');
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _zipCodeController = TextEditingController(text: '');
  TextEditingController _cityController = TextEditingController(text: '');
  TextEditingController _streetController = TextEditingController(text: '');
  TextEditingController _streetNumberController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    if (widget.workshop != null) {
      _avatar = widget.workshop!.avatar!;
      _nameController.text = widget.workshop!.name;
      _emailController.text = widget.workshop!.email;
      _phoneNumberController.text = widget.workshop!.phoneNumber;
      _zipCodeController.text = widget.workshop!.address!.zipCode;
      _cityController.text = widget.workshop!.address!.city;
      _streetController.text = widget.workshop!.address!.street;
      _streetNumberController.text = widget.workshop!.address!.streetNumber;
    }
  }

  late ServicesDatabaseService servicesDatabaseService;
  late WorkshopDatabaseService workshopDatabaseService;
  late DatabaseService databaseService;
  late DatabaseService appUserService;
  final GlobalKey<FormState> _workshopFormFormFormKey = GlobalKey<FormState>();

  void changeWorkshopAvatar(avatar) {
    setState(() {
      _avatar = avatar;
    });
  }

  Widget formInner(String appUserUid) {
    bool isValidStep() {
      return _workshopFormFormFormKey.currentState!.validate();
    }

    Future<void> handleUpdateWorkshopForm() async {
      if (isValidStep()) {
        setState(() => _isLoading = true);
        String? avatarUrl =
            await uploadImage(_avatar, 'workshops/$appUserUid/${Uuid().v1()}');

        String street = _streetController.text.trim();
        String streetNumber = _streetNumberController.text.trim();
        String city = _cityController.text.trim();

        Coords coords = await getCoordsFromAddress(street, streetNumber, city);

        Address address = Address(
            street: street,
            streetNumber: streetNumber,
            city: city,
            zipCode: _zipCodeController.text.trim(),
            coords: coords);

        Workshop workshop = Workshop(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          address: address,
          avatar: avatarUrl,
        );

        if (widget.workshop != null) {
          workshop.uid = widget.workshop!.uid;
          await workshopDatabaseService.updateWorkshop(workshop);
        } else {
          DocumentReference doc =
              await workshopDatabaseService.createWorkshop(workshop);

          servicesDatabaseService =
              ServicesDatabaseService(workshopUid: doc.id);

          await servicesDatabaseService.addDefaultServices();
          await databaseService.addAppUserRole(ROLES.OWNER);
          await databaseService.updateAppUserOnboardingStep(4);
        }

        await setPreferencesUserRole(ROLES.OWNER, appUserUid);

        setState(() => _isLoading = false);

        if (widget.onSubmitSuccess != null) {
          widget.onSubmitSuccess!();
        }
      }
    }

    return Container(
      margin: new EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              WorkshopAvatar(_avatar, changeWorkshopAvatar),
              TextFormFieldWidget(
                  controller: _nameController, labelText: 'Workshop name'),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Workshop contact',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  )),
              TextFormFieldWidget(
                controller: _emailController,
                labelText: 'Email',
                functionValidate: () {
                  if (!isEmailValid(_emailController.text.trim())) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),
              TextFormFieldWidget(
                controller: _phoneNumberController,
                labelText: 'Phone number',
                onlyDigits: true,
              ),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Workshop address',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  )),
              TextFormFieldWidget(
                  controller: _streetController, labelText: 'Street'),
              TextFormFieldWidget(
                  controller: _streetNumberController,
                  labelText: 'Street Number',
                  numberKeyboardType: true),
              TextFormFieldWidget(
                  controller: _zipCodeController,
                  labelText: 'Zip code',
                  numberKeyboardType: true),
              TextFormFieldWidget(
                  controller: _cityController,
                  labelText: 'City',
                  isLastFormInput: true),
              ErrorMessage(error: error),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Button(
                      text: 'Save',
                      onPressed: handleUpdateWorkshopForm,
                      isLoading: _isLoading)),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    databaseService = DatabaseService(
      uid: appUser!.uid,
    );

    workshopDatabaseService = WorkshopDatabaseService(
      appUserUid: appUser.uid,
    );

    return Form(key: _workshopFormFormFormKey, child: formInner(appUser.uid));
  }
}
