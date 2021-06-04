import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/upload_image.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/error_message.dart';
import 'package:nearby_car_service/pages/shared/text_form_field.dart';
import 'package:nearby_car_service/pages/shared/user_avatar.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/utils/database.dart';
import 'package:provider/provider.dart';

class ProfileForm extends StatefulWidget {
  final AppUser? user;
  final Function? goNext;

  const ProfileForm({this.user, this.goNext, Key? key}) : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  String _error = '';
  bool _isLoading = false;
  late String _avatar = '';
  late DatabaseService databaseService;
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController(text: '');
  TextEditingController _lastNameController = TextEditingController(text: '');
  TextEditingController _phoneNumberController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _avatar = widget.user!.avatar!;
      _firstNameController.text = widget.user!.firstName!;
      _lastNameController.text = widget.user!.lastName!;
      _phoneNumberController.text = widget.user!.phoneNumber!;
    }
  }

  bool isValid() {
    return _profileFormKey.currentState!.validate();
  }

  Future<void> handleUpdateProfile(AppUser _appUser) async {
    if (isValid()) {
      setState(() => _isLoading = true);
      String? avatarUrl =
          await uploadImage(_avatar, 'appUsers/avatars/${_appUser.uid}');

      AppUser appUser = AppUser(
        uid: _appUser.uid,
        email: _appUser.email,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: _phoneNumberController.text,
        avatar: avatarUrl,
        onboardingStep: widget.goNext == null ? 4 : 2,
      );

      await databaseService.updateAppUser(appUser);

      setState(() => _isLoading = false);

      if (widget.goNext != null) {
        widget.goNext!();
      }
    }
  }

  Widget _buildProfileForm(AppUser appUser) {
    return Container(
        margin: new EdgeInsets.all(15.0),
        child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              UserAvatar(_avatar, (val) {
                setState(() => _avatar = val);
              }),
              TextFormFieldWidget(
                  controller: _firstNameController, labelText: 'First name'),
              TextFormFieldWidget(
                  controller: _lastNameController, labelText: 'Last name'),
              TextFormFieldWidget(
                  controller: _phoneNumberController,
                  labelText: 'Phone number',
                  onlyDigits: true,
                  isLastFormInput: true),
              ErrorMessage(error: _error),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Button(
                      text: widget.goNext == null ? 'Save' : 'Next',
                      onPressed: () => handleUpdateProfile(appUser),
                      isLoading: _isLoading)),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    databaseService = DatabaseService(uid: appUser!.uid);

    return Form(key: _profileFormKey, child: _buildProfileForm(appUser!));
  }
}
