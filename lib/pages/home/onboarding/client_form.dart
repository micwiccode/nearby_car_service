import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/enum_to_list.dart';
import 'package:nearby_car_service/helpers/get_year_to_now.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/car.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/pages/shared/text_form_field.dart';
import 'package:nearby_car_service/utils/cars_database.dart';
import 'package:nearby_car_service/utils/user_service.dart';
import 'package:provider/provider.dart';

class ClientForm extends StatefulWidget {
  final Function skipOnboarding;

  const ClientForm({Key? key, required this.skipOnboarding}) : super(key: key);

  @override
  _ClientFormState createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  late AppUserDatabaseService databaseService;
  late CarDatabaseService carDatabaseService;
  final GlobalKey<FormState> _clientFormKey = GlobalKey<FormState>();
  final TextEditingController _carMarkController =
      TextEditingController(text: '');
  final TextEditingController _carModelController =
      TextEditingController(text: '');
  String _fuelType = 'Petrol';
  int? _productionYear;
  bool _isLoading = false;

  void _changeCarProductionYear(productionYear) {
    setState(() {
      _productionYear = productionYear;
    });
  }

  void _changeCarFuelType(fuelType) {
    setState(() {
      _fuelType = fuelType;
    });
  }

  Widget _buildDropdown(String label, selectedItem, items, onChanged) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: DropdownSearch(
            label: label,
            items: items,
            validator: (v) => v == null ? "This field is required" : null,
            showClearButton: true,
            onChanged: onChanged));
  }

  Future<void> handleSaveCar(BuildContext context) async {
    setState(() => _isLoading = true);

    bool isValid() {
      return _clientFormKey.currentState!.validate();
    }

    if (isValid()) {
      Car car = Car(
        mark: _carMarkController.text,
        model: _carModelController.text,
        productionYear: _productionYear,
        fuelType: _fuelType,
      );

      await carDatabaseService.createCar(car);
      await databaseService.updateAppUserOnboardingStep(4);

      final _snackBar = SnackBar(content: Text('Car saved'));
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    }

    setState(() => _isLoading = false);
  }

  Widget _buildClientForm(BuildContext context) {
    return (Container(
        child: _isLoading
            ? LoadingSpinner()
            : Column(children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Add your car',
                      style: TextStyle(fontSize: 14),
                    )),
                Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      'Later you will be able to edit that information',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )),
                TextFormFieldWidget(
                    controller: _carMarkController, labelText: 'Car mark'),
                TextFormFieldWidget(
                    controller: _carModelController, labelText: 'Car model'),
                _buildDropdown('Fuel', _fuelType, enumToList(FuelType.values),
                    _changeCarFuelType),
                _buildDropdown('Production year', _productionYear,
                    getYearsToNow(1950), _changeCarProductionYear),
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Button(
                        text: 'Save',
                        onPressed: () => handleSaveCar(context),
                        isLoading: _isLoading)),
                GestureDetector(
                    onTap: () => widget.skipOnboarding(),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Finish, I'll do it later",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    )),
              ])));
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    databaseService = AppUserDatabaseService(
      uid: appUser!.uid,
    );

    carDatabaseService = CarDatabaseService(appUserUid: appUser.uid);

    return Form(key: _clientFormKey, child: _buildClientForm(context));
  }
}
