import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/pages/shared/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'employee_workshops_page.dart';
import 'orders_page.dart';
import 'transactions_page.dart';

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
    TransactionsMenuPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    return Scaffold(
      body: FutureProvider<String?>.value(
          initialData: null,
          value: getPreferencesEmployeeWorkshopUid(appUser!.uid),
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
            icon: Icon(Icons.payment),
            label: 'Transactions',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
