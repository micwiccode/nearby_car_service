import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/utils/authentication.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? Container(
              margin: EdgeInsets.all(3.0),
              width: 55.0,
              height: 55.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.amber[600]),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ))
          : GestureDetector(
              onTap: () async {
                setState(() => {_isSigningIn = true});

                User? user =
                    await Authentication.signInWithGoogle(context: context);

                setState(() => {_isSigningIn = false});

                if (user != null) {
                  print('logged in');
                }
              },
              child: Container(
                margin: EdgeInsets.all(3.0),
                padding: const EdgeInsets.all(15.0),
                width: 55.0,
                height: 55.0,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Image(
                  image: AssetImage("lib/assets/google_logo.png"),
                  height: 20.0,
                ),
              ),
            ),
    );
  }
}
