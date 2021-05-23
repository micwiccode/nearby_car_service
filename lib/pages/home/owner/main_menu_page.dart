import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/pages/home/owner/workshop_menu_page.dart';

class MainMenuPage extends StatefulWidget {
  final AppUser user;
  const MainMenuPage({required this.user, Key? key}) : super(key: key);

  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    WorkshopMenuPage(),
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'My workshop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_repair),
            label: 'Employees',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
