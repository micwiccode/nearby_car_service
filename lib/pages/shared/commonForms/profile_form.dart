import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/upload_image.dart';
import 'package:nearby_car_service/pages/shared/button.dart';
import 'package:nearby_car_service/pages/shared/error_message.dart';
import 'package:nearby_car_service/pages/shared/text_form_field.dart';
import 'package:nearby_car_service/pages/shared/user_avatar.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/utils/user_service.dart';
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
  late AppUserDatabaseService databaseService;
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

  Future<void> handleUpdateProfile(
      BuildContext context, String appUserUid, AppUser? currentAppUser) async {
    if (isValid()) {
      setState(() => _isLoading = true);
      String? avatarUrl =
          await uploadImage(_avatar, 'appUsers/avatars/$appUserUid');

      AppUser appUser = AppUser(
        uid: appUserUid,
        email: currentAppUser?.email?.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        avatar: avatarUrl,
        roles: currentAppUser?.roles ?? [],
        onboardingStep: currentAppUser == null ? 2 : 4,
      );

      await databaseService.updateAppUser(appUser);

      setState(() => _isLoading = false);

      final _snackBar =
          SnackBar(content: Text('Saved successfully'));
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);

      if (widget.goNext != null) {
        widget.goNext!();
      }
    }
  }

  Widget _buildProfileForm(
      BuildContext context, String appUserUid, AppUser? currentAppUser) {
    return Container(
        margin: EdgeInsets.all(5.0),
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
                      onPressed: () => handleUpdateProfile(
                          context, appUserUid, currentAppUser),
                      isLoading: _isLoading)),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser?>(context);

    databaseService = AppUserDatabaseService(uid: appUser!.uid);

    return Form(
        key: _profileFormKey,
        child: _buildProfileForm(context, appUser.uid, widget.user));
  }
}
