import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/enum_to_list.dart';
import 'package:nearby_car_service/helpers/get_year_to_now.dart';
import 'package:nearby_car_service/models/car.dart';
import 'package:nearby_car_service/pages/shared/text_form_field.dart';

class ClientForm extends StatefulWidget {
  final Function skipOnboarding;

  const ClientForm({Key? key, required this.skipOnboarding}) : super(key: key);

  @override
  _ClientFormState createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final GlobalKey<FormState> _clientFormKey = GlobalKey<FormState>();
  final TextEditingController _carMarkController =
      TextEditingController(text: '');
  final TextEditingController _carModelController =
      TextEditingController(text: '');
  final String fuelType = 'Petrol';
  final int? productionYear = null;

  void _changeCarProductionYear(productionYear) {
    productionYear = productionYear;
  }

  void _changeCarFuelType(fuelType) {
    fuelType = fuelType;
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

  Widget _buildClientForm() {
    return (Container(
        child: Column(children: <Widget>[
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
      _buildDropdown(
          'Fuel', fuelType, enumToList(FuelType.values), _changeCarFuelType),
      _buildDropdown('Production year', productionYear, getYearsToNow(1950),
          _changeCarProductionYear),
      GestureDetector(
          onTap: () => widget.skipOnboarding,
          child: Text("Finish, I'll do it later",
              style: TextStyle(fontWeight: FontWeight.bold))),
    ])));
  }

  @override
  Widget build(BuildContext context) {
    return Form(key: _clientFormKey, child: _buildClientForm());
  }
}
