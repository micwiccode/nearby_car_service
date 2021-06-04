import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'models/app_user.dart';
import 'pages/main_wrapper.dart';
import 'pages/shared/error_message.dart';
import 'pages/shared/loading_spinner.dart';
import 'utils/auth_service.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.amber));

    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorMessage(
                error: 'Error while await Firebase.initializeApp()');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            FirebaseMessaging.onBackgroundMessage(
                _firebaseMessagingBackgroundHandler);
            return _buildApp();
          }

          return LoadingSpinner();
        });
  }

  Widget _buildApp() {
    return StreamProvider<AppUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        title: 'Nearby car service app',
        theme: ThemeData(
          primaryColor: Colors.amber[600],
          accentColor: Colors.amber[600],
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
}
