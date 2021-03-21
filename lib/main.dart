import 'package:flutter/material.dart';

import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearby car service app',
      theme: ThemeData(
        primaryColor: Colors.yellow[900],
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
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
