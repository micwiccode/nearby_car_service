import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/service.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/error_message.dart';
import 'package:nearby_car_service/pages/shared/price_input.dart';
import 'package:nearby_car_service/utils/services_service.dart';

class ServiceFormPage extends StatefulWidget {
  final Service? service;
  final String workshopUid;
  ServiceFormPage({required this.service, required this.workshopUid, Key? key})
      : super(key: key);

  @override
  _ServiceFormPageState createState() => _ServiceFormPageState();
}

class _ServiceFormPageState extends State<ServiceFormPage> {
  String error = '';
  bool _isLoading = false;
  bool _isActive = true;
  int _minPrice = 0;
  TextEditingController _nameController = TextEditingController(text: '');
  MoneyMaskedTextController _minPriceController =
      MoneyMaskedTextController(initialValue: 0.0, rightSymbol: ' \€');

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      _isActive = widget.service!.isActive;
      _nameController.text = widget.service!.name;
      _minPriceController.updateValue(widget.service!.minPrice / 100);
    }
  }

  late ServicesDatabaseService servicesDatabaseService;
  final GlobalKey<FormState> _serviceFormFormFormKey = GlobalKey<FormState>();

  void toggleServiceActive(bool value) {
    setState(() {
      _isActive = value;
    });
  }

  Widget formInner() {
    bool isValidStep() {
      return _serviceFormFormFormKey.currentState!.validate();
    }

    Future<void> handleUpdateService() async {
      if (isValidStep()) {
        setState(() {
          _isLoading = true;
        });

        Service service = Service(
          name: _nameController.text,
          minPrice: (_minPriceController.numberValue * 100).toInt(),
          isActive: _isActive,
        );

        if (widget.service != null) {
          service.uid = widget.service!.uid;
          await servicesDatabaseService.updateService(service);
        } else {
          await servicesDatabaseService.createService(service);
        }
        Navigator.of(context).pop();
        setState(() {
          _isLoading = false;
        });
      }
    }

    return Container(
      margin: new EdgeInsets.all(25.0),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(children: [
                Switch(
                  value: _isActive,
                  onChanged: toggleServiceActive,
                ),
                Text('Active')
              ]),
              TextFormField(
                controller: _nameController,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter service name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Service name',
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
              PriceInput(controller: _minPriceController, label: "Min price"),
              ErrorMessage(error: error),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Button(
                      text: 'Save',
                      onPressed: handleUpdateService,
                      isLoading: _isLoading)),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    servicesDatabaseService = ServicesDatabaseService(
      workshopUid: widget.workshopUid,
    );

    return Scaffold(
      appBar: AppBar(
          title:
              Text(widget.service == null ? 'Add new service' : 'Edit service'),
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.amber,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          )),
      body: Center(
        child: Form(key: _serviceFormFormFormKey, child: formInner()),
      ),
    );
  }
}
