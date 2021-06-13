import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'cars_menu_page.dart';
import 'orders_menu_page.dart';
import 'workshops_menu_page.dart';

class MainMenuPage extends StatefulWidget {
  final AppUser user;
  const MainMenuPage({required this.user, Key? key}) : super(key: key);

  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int _selectedIndex = 0;

  void moveToWrokshopsPage() {
    _onItemTapped(2);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      OrdersMenuPage(changePage: moveToWrokshopsPage),
      CarsMenuPage(),
      WorkshopsMenuPage(),
    ];

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'My cars',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_repair),
            label: 'Workshops',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
