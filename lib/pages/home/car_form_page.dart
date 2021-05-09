import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/enum_to_list.dart';
import 'package:nearby_car_service/helpers/get_year_to_now.dart';
import 'package:nearby_car_service/helpers/upload_image.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/car.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/car_avatar.dart';
import 'package:nearby_car_service/pages/shared/error_message.dart';
import 'package:nearby_car_service/utils/cars_database.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CarFormPage extends StatefulWidget {
  final Car? car;
  CarFormPage({required this.car, Key? key}) : super(key: key);

  @override
  _CarFormPageState createState() => _CarFormPageState();
}

class _CarFormPageState extends State<CarFormPage> {
  String error = '';
  bool _isLoading = false;
  String _avatar = '';
  int? _productionYear;
  String _fuelType = 'Petrol';
  TextEditingController _markController = TextEditingController(text: '');
  TextEditingController _modelController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    if (widget.car != null) {
      _avatar = widget.car!.avatar;
      _productionYear = widget.car!.productionYear;
      _fuelType = widget.car!.fuelType;
      _markController.text = widget.car!.mark;
      _modelController.text = widget.car!.model;
    }
  }

  late CarDatabaseService carDatabaseService;
  final GlobalKey<FormState> _carFormFormFormKey = GlobalKey<FormState>();

  void changeCarProductionYear(productionYear) {
    setState(() {
      _productionYear = productionYear;
    });
  }

  void changeCarFuelType(fuelType) {
    setState(() {
      _fuelType = fuelType;
    });
  }

  void changeCarAvatar(avatar) {
    setState(() {
      _avatar = avatar;
    });
  }

  Widget formInner(String appUserUid) {
    bool isValidStep() {
      return _carFormFormFormKey.currentState!.validate();
    }

    Future<void> handleUpdateCarForm() async {
      if (isValidStep()) {
        setState(() => _isLoading = true);
        String? avatarUrl =
            await uploadImage(_avatar, 'cars/$appUserUid/${Uuid().v1()}');

        if (avatarUrl != null) {
          _avatar = avatarUrl;
        }

        Car car = Car(
          mark: _markController.text,
          model: _modelController.text,
          productionYear: _productionYear,
          fuelType: _fuelType,
          avatar: _avatar,
        );

        if (widget.car != null) {
          car.uid = widget.car!.uid;
          await carDatabaseService.updateCar(car);
        } else {
          await carDatabaseService.createCar(car);
        }
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
              CarAvatar(_avatar, changeCarAvatar),
              buildTextField('Car mark', _markController),
              buildTextField('Car model', _modelController),
              buildDropdown('Fuel', _fuelType, enumToList(FuelType.values),
                  changeCarFuelType),
              buildDropdown('Production year', _productionYear,
                  getYearsToNow(1950), changeCarProductionYear),
              ErrorMessage(error: error),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Button(
                      text: 'Save',
                      onPressed: handleUpdateCarForm,
                      isLoading: _isLoading)),
            ]),
      ),
    );
  }

  Widget buildTextField(String text, controller) {
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

  Widget buildDropdown(String label, selectedItem, items, onChanged) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: DropdownSearch(
            label: label,
            items: items,
            selectedItem: selectedItem,
            validator: (v) => v == null ? "This field is required" : null,
            showClearButton: true,
            onChanged: onChanged));
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);
    carDatabaseService = CarDatabaseService(
      appUserUid: appUser!.uid,
    );

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.car == null ? 'Add new car' : 'Edit car'),
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.amber,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          )),
      body: Center(
        child: Form(key: _carFormFormFormKey, child: formInner(appUser.uid)),
      ),
    );
  }
}
