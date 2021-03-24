import 'package:flutter/material.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/utils/auth_service.dart';

import '../shared/text_form_field.dart';
import '../shared/button.dart';
import '../shared/error_message.dart';
import '../shared/google_sign_in_button.dart';

class SignUpPage extends StatefulWidget {
  final Function toggleAuthPage;
  SignUpPage({required this.toggleAuthPage, Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool _isPasswordVisible = false;
  bool _isRepeatPasswordVisible = false;
  String email = '';
  String password = '';
  String passwordRepeat = '';
  String error = '';
  bool isLoading = false;

  handleSignUp() async {
    if (_signUpFormKey.currentState!.validate()) {
      setState(() => isLoading = true);
      dynamic result = await _auth.signUp(email, password);
      if (result == null) {
        setState(() {
          error = 'Please enter a valid email';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(key: _signUpFormKey, child: formInner()),
      ),
    );
  }

  Widget formInner() {
    return isLoading
        ? LoadingSpinner()
        : Container(
            margin: new EdgeInsets.all(25.0),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.account_circle,
                      color: Colors.amber[600],
                      size: 80.0,
                    ),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Sign up  to join',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        )),
                    GoogleSignInButton(),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Or use your email account',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        )),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextFormFieldWidget(
                          labelText: 'Email',
                          onChanged: (value) {
                            setState(() => email = value);
                          },
                          functionValidate: (String? emial) {
                            if (emial == null || emial.trim().isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                        )),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormFieldWidget(
                        labelText: "Password",
                        obscureText: !_isPasswordVisible,
                        onChanged: (value) {
                          setState(() => password = value);
                        },
                        functionValidate: (String? password) {
                          if (password == null) {
                            return 'Please enter password';
                          }
                          String trimmedPassword = password.trim();
                          if (trimmedPassword.length < 5) {
                            return 'Please enter password 5+ characters';
                          }
                          if (trimmedPassword != passwordRepeat) {
                            return 'Passwords are not eqaul';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextFormFieldWidget(
                        labelText: "Repeat password",
                        obscureText: !_isRepeatPasswordVisible,
                        onChanged: (value) {
                          setState(() => passwordRepeat = value);
                        },
                        functionValidate: (String? passwordRepeat) {
                          if (passwordRepeat == null) {
                            return 'Please enter password repeat';
                          }
                          if (password != passwordRepeat) {
                            return 'Passwords are not eqaul';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isRepeatPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isRepeatPasswordVisible =
                                  !_isRepeatPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    ErrorMessage(error: error),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child:
                            Button(text: 'Sign up', onPressed: handleSignUp)),
                    Text("Already have an account?"),
                    GestureDetector(
                        onTap: () {
                          widget.toggleAuthPage();
                        },
                        child: Text("Log in",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ]),
            ),
          );
  }
}
