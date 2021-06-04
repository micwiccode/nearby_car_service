import 'package:shared_preferences/shared_preferences.dart';

Future<String?>? getPreferencesUserRole(String userUid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('CURRENT_ROLE_$userUid');
}

Future<void> setPreferencesUserRole(String role, String userUid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('CURRENT_ROLE_$userUid', role);
}
