import 'package:flutter/material.dart';
import 'package:nearby_car_service/pages/home/owner/pending_employee_menu_page.dart';
import 'confirmed_employee_menu_page.dart';

class EmployeesMenuPage extends StatefulWidget {
  const EmployeesMenuPage({Key? key}) : super(key: key);

  @override
  _EmployeesMenuPageState createState() => _EmployeesMenuPageState();
}

class _EmployeesMenuPageState extends State<EmployeesMenuPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          child: TabBar(
        indicatorColor: Colors.amber[600],
        controller: _tabController,
        tabs: [
          Tab(child: Text('Active employees')),
          Tab(child: Text('Pending invitations'))
        ],
      )),
      Expanded(
          child: TabBarView(
        controller: _tabController,
        children: [
          Container(child: ConfirmedEmployeesMenuPage()),
          Container(child: PendingEmployeesMenuPage())
        ],
      )),
    ]);
  }
}
