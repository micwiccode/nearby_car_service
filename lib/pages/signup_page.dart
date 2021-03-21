import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearby_car_service/utils/authentication.dart';

import '../widgets/text_form_field.dart';
import '../widgets/button.dart';
import 'google_sign_in_button.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isRepeatPasswordVisible = false;

  Widget formInner() {
    return Container(
      margin: new EdgeInsets.all(25.0),
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
                labelText: "Name",
                functionValidate: (String? name) {
                  if (name == null || name.trim().isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
              ),
            ),
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
                functionValidate: (String? password) {
                  if (password == null || password.trim().isEmpty) {
                    return 'Please enter repeated password';
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
                      _isRepeatPasswordVisible = !_isRepeatPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Button(
                  text: 'Sign up',
                  onPressed: () {
                    if (_signupFormKey.currentState!.validate()) {}
                  },
                )),
            Text("Already have an account?"),
            GestureDetector(
                onTap: () {
                  print('nav');
                  Navigator.pushNamed(
                    context,
                    '/',
                  );
                },
                child: Text("Log in",
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(key: _signupFormKey, child: formInner()),
      ),
    );
  }
}
