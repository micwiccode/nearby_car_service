import 'package:flutter/material.dart';
import 'package:nearby_car_service/models/app_user.dart';
import '../shared/commonForms/profile_form.dart';

class ProfilePage extends StatelessWidget {
  final AppUser user;
  ProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Profile'),
          leading: BackButton(color: Colors.black),
          backgroundColor: Colors.amber,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          )),
      body: Center(
        child: ProfileForm(user: user),
      ),
    );
  }
}
