import 'package:shared_preferences/shared_preferences.dart';

import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'package:nearby_car_service/consts/app_user_roles.dart' as ROLES;

Preference<String> getSteamPreferencesUserRole(
    StreamingSharedPreferences prefs, String userUid) {
  return prefs.getString('CURRENT_ROLE_$userUid', defaultValue: ROLES.CLIENT);
}

Future<void> setSteamPreferencesUserRole(String role, String userUid) async {
  final prefs = await StreamingSharedPreferences.instance;
  prefs.setString('CURRENT_ROLE_$userUid', role);
}

Preference<String> getSteamPreferencesEmployeeWorkshopUid(
    StreamingSharedPreferences prefs, String userUid) {
  return prefs.getString('EMLOYEE_WORKSHOP_UID_$userUid', defaultValue: '');
}

Future<void> setSteamPreferencesEmployeeWorkshopUid(
    String workshopUid, String userUid) async {
  final prefs = await StreamingSharedPreferences.instance;
  prefs.setString('EMLOYEE_WORKSHOP_UID_$userUid', workshopUid);
}

Future<String?> getPreferencesUserRole(String userUid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('CURRENT_ROLE_$userUid');
}

Future<void> setPreferencesUserRole(String role, String userUid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await setSteamPreferencesUserRole(role, userUid);
  prefs.setString('CURRENT_ROLE_$userUid', role);
}

Future<String?> getPreferencesEmployeeWorkshopUid(String userUid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('EMLOYEE_WORKSHOP_UID_$userUid');
}

Future<void> setPreferencesEmployeeWorkshopUid(
    String workshopUid, String userUid) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('EMLOYEE_WORKSHOP_UID_$userUid', workshopUid);
}
