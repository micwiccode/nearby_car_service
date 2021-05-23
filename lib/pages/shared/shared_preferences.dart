import 'package:shared_preferences/shared_preferences.dart';

Future<String?>? getPreferencesUserRole() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('CURRENT_ROLE');
}

Future<void> setPreferencesUserRole(currentRole) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('CURRENT_ROLE', currentRole);
}
