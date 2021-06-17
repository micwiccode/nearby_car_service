import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/pages/home/employee/services_menu_page.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/pages/shared/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'employee_workshops_page.dart';
import 'orders_menu_page.dart';

class MainMenuPage extends StatefulWidget {
  final AppUser user;
  const MainMenuPage({required this.user, Key? key}) : super(key: key);

  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    EmployeeWorkshopsMenuPage(),
    OrdersMenuPage(),
    SerivcesMenuPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
       return FutureBuilder<StreamingSharedPreferences>(
        future: StreamingSharedPreferences.instance,
        builder: (BuildContext context,
            AsyncSnapshot<StreamingSharedPreferences> prefsSnapshot) {
          if (!prefsSnapshot.hasData) {
            return LoadingSpinner();
          }

          return PreferenceBuilder<String>(
              preference: getSteamPreferencesEmployeeWorkshopUid(
                  prefsSnapshot.data!, widget.user.uid),
              builder: (BuildContext context, String workshopUid) {
                return Scaffold(
                  body: Provider<String?>.value(
                      value: workshopUid,
                      child: Center(
                        child: _widgetOptions.elementAt(_selectedIndex),
                      )),
                  bottomNavigationBar: BottomNavigationBar(
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.business_center_outlined),
                        label: 'My workshops',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.calendar_today),
                        label: 'Orders',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.car_repair),
                        label: 'Services',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: Colors.amber[800],
                    unselectedItemColor: Colors.grey,
                    onTap: _onItemTapped,
                  ),
                );
              });
        });
  }
}
