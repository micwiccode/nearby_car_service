import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/text_form_field.dart';
import 'widgets/button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearby car service app',
      theme: ThemeData(
        primaryColor: Colors.yellow[800],
        accentColor: Colors.yellow[800],
        fontFamily: 'Georgia',
        scaffoldBackgroundColor: Colors.grey[50],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.yellow,
          textTheme: ButtonTextTheme.primary,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.blueGrey[900],
          ),
        ),
      ),
      home: LoginePage(),
    );
  }
}

class LoginePage extends StatefulWidget {
  LoginePage({Key? key}) : super(key: key);

  @override
  _LoginePageState createState() => _LoginePageState();
}

class _LoginePageState extends State<LoginePage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  Widget formInner() {
    return Container(
      margin: new EdgeInsets.all(25.0),
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
            Container(
              margin: EdgeInsets.all(6.0),
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.amber[600]),
              child: Icon(
                Icons.login,
                color: Colors.black,
                size: 30.0,
              ),
            ),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Log in',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
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
                child: Button(
                  text: 'Log in',
                  onPressed: () {
                    if (_loginFormKey.currentState!.validate()) {}
                  },
                ))
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
