import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/models/workshop.dart';
import 'package:nearby_car_service/pages/home/owner/orders_menu_page.dart';
import 'package:nearby_car_service/pages/home/owner/services_menu_page.dart';
import 'package:nearby_car_service/pages/home/owner/transactions_page.dart';
import 'package:nearby_car_service/pages/home/owner/employees_menu_page.dart';
import 'package:nearby_car_service/pages/home/owner/workshop_menu_page.dart';
import 'package:nearby_car_service/utils/workshop_service.dart';
import 'package:provider/provider.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    WorkshopMenuPage(),
    OrdersMenuPage(),
    SerivcesMenuPage(),
    EmployeesMenuPage(),
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
      body: StreamProvider<Workshop?>.value(
          initialData: null,
          value: WorkshopDatabaseService(appUserUid: appUser!.uid).myWorkshop,
          child: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          )),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'My workshop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_repair),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Employees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Transactions',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
