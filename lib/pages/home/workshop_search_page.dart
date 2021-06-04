import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/utils/workshop_service.dart';
import 'workshops_map.dart';
import 'workshops_search_list.dart';

class WorkshopSearchPage extends StatefulWidget {
  const WorkshopSearchPage({Key? key}) : super(key: key);

  @override
  _WorkshopSearchPageState createState() => _WorkshopSearchPageState();
}

class _WorkshopSearchPageState extends State<WorkshopSearchPage> {
  TextEditingController _inputController = TextEditingController(text: '');
  bool _isMapDisplayed = false;
  List<Workshop> _resultWorkshops = [];
  List<dynamic> _resultPrompt = [];

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_handleSearchWorkshopsPrompt);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _handleSearchWorkshopsPrompt() async {
    String input = _inputController.text;
    if (input.length > 2) {
      List<dynamic> results =
          await WorkshopDatabaseService.searchWorkshopsPrompt(input);
      print(results);
      for (final workshop in results) {
        _resultPrompt.add(workshop);
      }
    } else {
      setState(() {
        _resultWorkshops = [];
      });
    }
  }

  Future<void> _handleSearchWorkshops() async {
    String input = _inputController.text;
    if (input.length > 2) {
      List<dynamic> results =
          await WorkshopDatabaseService.searchWorkshops(input);
      for (final workshop in results) {
        _resultWorkshops.add(workshop);
      }
    } else {
      setState(() {
        _resultWorkshops = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
            top: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  textInputAction: TextInputAction.search,
                  controller: _inputController,
                  onFieldSubmitted: (String value) {
                    _handleSearchWorkshops();
                  },
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.blueAccent,
                  ),
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      prefixIcon: Icon(Icons.people),
                      hintText: "Search workshop",
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 32.0),
                          borderRadius: BorderRadius.circular(25.0)))),
            )),
        Expanded(
            child: _isMapDisplayed
                ? WorkshopsMap(workshops: _resultWorkshops)
                : WorkshopsSearchList(workshops: _resultWorkshops))
      ],
    );
  }
}
