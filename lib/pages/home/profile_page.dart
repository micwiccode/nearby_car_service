import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/upload_image.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/error_message.dart';
import 'package:nearby_car_service/pages/shared/text_form_field.dart';
import 'package:nearby_car_service/pages/shared/user_avatar.dart';
import 'package:nearby_car_service/utils/database.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final AppUser user;
  ProfilePage({required this.user, Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String error = '';
  late AppUser _appUser;
  late DatabaseService databaseService;
  final GlobalKey<FormState> _profileFormFormKey = GlobalKey<FormState>();

  Widget formInner() {
    _appUser = widget.user;

    bool isValidStep() {
      return _profileFormFormKey.currentState!.validate();
    }

    Future<void> handleUpdateProfile() async {
      if (isValidStep()) {

        String? avatarUrl =
            await uploadImage(_appUser.avatar, 'appUsers/avatars/${_appUser.uid}');
        _appUser.avatar = avatarUrl;

        await databaseService.updateAppUser(_appUser);
      }
    }

    print(_appUser.avatar);

    return Container(
      margin: new EdgeInsets.all(25.0),
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UserAvatar(_appUser.avatar, (val) {
                setState(() => _appUser.avatar = val);
              }),
              buildTextField(
                  'First name',
                  _appUser.firstName,
                  (val) => setState(_appUser.firstName = val),
                  _appUser.firstName),
              buildTextField(
                  'Last name',
                  _appUser.lastName,
                  (val) => setState(_appUser.lastName = val),
                  _appUser.lastName),
              buildTextField(
                  'Phone number',
                  _appUser.phoneNumber,
                  (val) => setState(_appUser.phoneNumber = val),
                  _appUser.phoneNumber,
                  onlyDigits: true),
              // Padding(
              //     padding: EdgeInsets.all(10.0),
              //     child: TextFormFieldWidget(
              //       labelText: 'Email',
              //       onChanged: (value) {
              //         setState(() => _appUser.email = value);
              //       },
              //       functionValidate: (String? email) {
              //         if (email == null || email.trim().isEmpty) {
              //           return 'Please enter email';
              //         }
              //         return null;
              //       },
              //     )),
              // Padding(
              //   padding: EdgeInsets.all(10.0),
              //   child: TextFormFieldWidget(
              //     labelText: "Password",
              //     obscureText: !_isPasswordVisible,
              //     onChanged: (value) {
              //       setState(() => password = value);
              //     },
              //     functionValidate: (String? password) {
              //       if (password == null || password.trim().isEmpty) {
              //         return 'Please enter password';
              //       }
              //       return null;
              //     },
              //     suffixIcon: IconButton(
              //       icon: Icon(
              //         _isPasswordVisible
              //             ? Icons.visibility
              //             : Icons.visibility_off,
              //       ),
              //       onPressed: () {
              //         setState(() {
              //           _isPasswordVisible = !_isPasswordVisible;
              //         });
              //       },
              //     ),
              //   ),
              // ),
              ErrorMessage(error: error),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Button(
                    text: 'Save',
                    onPressed: handleUpdateProfile,
                  )),
            ]),
      ),
    );
  }

  Widget buildTextField(
      String text, String? value, onChanged, String? initialValue,
      {bool? onlyDigits}) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormFieldWidget(
        labelText: text,
        initialValue: initialValue,
        onChanged: (val) {
          onChanged(val);
        },
        onlyDigits: onlyDigits ?? false,
        functionValidate: (String? value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $text';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);
    databaseService = DatabaseService(uid: appUser!.uid);

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
        child: Form(key: _profileFormFormKey, child: formInner()),
      ),
    );
  }
}
