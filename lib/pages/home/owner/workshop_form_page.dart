import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearby_car_service/helpers/upload_image.dart';
import 'package:nearby_car_service/models/address.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/error_message.dart';
import 'package:nearby_car_service/pages/shared/shared_preferences.dart';
import 'package:nearby_car_service/pages/shared/workshop_avatar.dart';
import 'package:nearby_car_service/utils/database.dart';
import 'package:nearby_car_service/utils/workshop_service.dart';
import 'package:nearby_car_service/utils/services_service.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:nearby_car_service/consts/app_user_roles.dart' as ROLES;

class WorkshopFormPage extends StatefulWidget {
  final Workshop? workshop;
  WorkshopFormPage({required this.workshop, Key? key}) : super(key: key);

  @override
  _WorkshopFormPageState createState() => _WorkshopFormPageState();
}

class _WorkshopFormPageState extends State<WorkshopFormPage> {
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

        if (avatarUrl != null) {
          _avatar = avatarUrl;
        }

        Address address = Address(
          street: _streetController.text,
          streetNumber: _streetNumberController.text,
          city: _cityController.text,
          zipCode: _cityController.text,
        );

        Workshop workshop = Workshop(
          name: _nameController.text,
          email: _emailController.text,
          phoneNumber: _phoneNumberController.text,
          address: address,
          avatar: _avatar,
        );

        if (widget.workshop != null) {
          workshop.uid = widget.workshop!.uid;
          await workshopDatabaseService.updateWorkshop(workshop);
        } else {
          Workshop savedWorkshop =
              await workshopDatabaseService.createWorkshop(workshop);
          servicesDatabaseService =
              ServicesDatabaseService(workshopUid: savedWorkshop.uid);
          await servicesDatabaseService.addDefaultServices();
          await await databaseService.addAppUserRole(ROLES.OWNER);
        }

        await setPreferencesUserRole(ROLES.OWNER);
        Navigator.of(context).pop();
        setState(() => _isLoading = false);
      }
    }

    return Container(
      margin: new EdgeInsets.all(25.0),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              WorkshopAvatar(_avatar, changeWorkshopAvatar),
              buildTextField('Workshop name', _nameController),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Workshop contact',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  )),
              buildTextField('Email', _emailController),
              buildTextField(
                'Phone number',
                _phoneNumberController,
                onlyDigits: true,
              ),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Workshop address',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  )),
              buildTextField('Street', _streetController),
              buildTextField(
                'Street Number',
                _streetNumberController,
                numberKeyboardType: true,
              ),
              buildTextField(
                'Zip code',
                _zipCodeController,
                numberKeyboardType: true,
              ),
              buildTextField('City', _cityController),
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

  Widget buildTextField(String text, controller,
      {bool? onlyDigits, bool? numberKeyboardType}) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        validator: (String? value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $text';
          }
          return null;
        },
        inputFormatters: onlyDigits != null && onlyDigits
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : [],
        keyboardType: (onlyDigits != null && onlyDigits) ||
                (numberKeyboardType != null && numberKeyboardType)
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(
          labelText: text,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 0.8,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 0.8,
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
          filled: true,
          fillColor: Colors.white,
        ),
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

    return Scaffold(
      appBar: AppBar(
          title: Text(
              widget.workshop == null ? 'Add new workshop' : 'Edit workshop'),
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.amber,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          )),
      body: Center(
        child:
            Form(key: _workshopFormFormFormKey, child: formInner(appUser.uid)),
      ),
    );
  }
}
