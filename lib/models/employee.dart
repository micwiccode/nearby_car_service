import 'workshop.dart';

enum EmployeePositions { coowner, mechanic, mechanicMaster, mechanicAssistant }

class Employee {
  List<Workshop>? workshops;
  String position;

  Employee({this.position = '', this.workshops});

  @override
  String toString() => "$workshops, $position";
}
