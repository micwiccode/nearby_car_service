import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearby_car_service/pages/shared/loading_spinner.dart';
import 'package:nearby_car_service/utils/auth_service.dart';

import '../shared/text_form_field.dart';
import '../shared/button.dart';
import '../shared/error_message.dart';
import '../shared/google_sign_in_button.dart';

class SignInPage extends StatefulWidget {
  final Function toggleAuthPage;
  SignInPage({required this.toggleAuthPage, Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _signInFormKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  bool _isPasswordVisible = false;
  String email = '';
  String password = '';
  String error = '';
  bool isLoading = false;

  handleSignIn() async {
    if (_signInFormKey.currentState!.validate()) {
      setState(() => isLoading = true);
      dynamic result = await _auth.signIn(email, password);
      if (result == null) {
        setState(() {
          error = 'Invalid credentials';
          isLoading = false;
        });
      }
    }
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
                    Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Nearby car service',
                          style: GoogleFonts.lato(
                              color: Colors.black,
                              letterSpacing: .5,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        )),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Sign in using',
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
                          functionValidate: (String? email) {
                            if (email == null || email.trim().isEmpty) {
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
                          if (password == null || password.trim().isEmpty) {
                            return 'Please enter password';
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
                    ErrorMessage(error: error),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Button(
                          text: 'Log in',
                          onPressed: handleSignIn,
                        )),
                    Text("Don't have an account?"),
                    GestureDetector(
                        onTap: () {
                          widget.toggleAuthPage();
                        },
                        child: Text("Sign up",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ]),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(key: _signInFormKey, child: formInner()),
      ),
    );
  }
}
