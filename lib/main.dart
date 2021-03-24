import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/main_wrapper.dart';
import 'pages/shared/error_message.dart';
import 'pages/shared/loading_spinner.dart';
import 'utils/auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorMessage(
                error: 'Error while await Firebase.initializeApp()');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return App();
          }

          return LoadingSpinner();
        });
  }
}

Widget App() {
  return StreamProvider<User?>.value(
    initialData: null,
    value: AuthService().user,
    child: MaterialApp(
      title: 'Nearby car service app',
      theme: ThemeData(
        primaryColor: Colors.yellow[900],
        accentColor: Colors.yellow[800],
        fontFamily: 'Montserrat',
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
        '/': (context) => MainWrapper(),
      },
    ),
  );
}
