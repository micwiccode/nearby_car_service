import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearby_car_service/utils/authentication.dart';

import '../widgets/text_form_field.dart';
import '../widgets/button.dart';
import 'google_sign_in_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  Widget formInner() {
    return Container(
      margin: new EdgeInsets.all(25.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
          Widget>[
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
        FutureBuilder(
          future: Authentication.initializeFirebase(context: context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error initializing Firebase');
            } else if (snapshot.connectionState == ConnectionState.done) {
              return GoogleSignInButton();
            }
            return CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.amber,
              ),
            );
          },
        ),
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
              functionValidate: (String? emial) {
                if (emial == null || emial.trim().isEmpty) {
                  return 'Please enter valid email';
                }
                return null;
              },
            )),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextFormFieldWidget(
            labelText: "Password",
            obscureText: !_isPasswordVisible,
            functionValidate: (String? password) {
              if (password == null || password.trim().isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
            child: Button(
              text: 'Log in',
              onPressed: () {
                if (_loginFormKey.currentState!.validate()) {}
              },
            )),
        Text("Don't have an account?"),
        GestureDetector(
            onTap: () {
              print('nav');
              Navigator.pushNamed(
                context,
                '/signup',
              );
            },
            child:
                Text("Sign up", style: TextStyle(fontWeight: FontWeight.bold))),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(key: _loginFormKey, child: formInner()),
      ),
    );
  }
}
