import 'package:flutter/material.dart';

import 'sign_in_page.dart';
import 'sign_up_page.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool showSignUp = false;

  void toggleAuthPage() {
    setState(() => showSignUp = !showSignUp);
  }

  @override
  Widget build(BuildContext context) {
    return showSignUp ? SignUpPage(toggleAuthPage: toggleAuthPage) : SignInPage(toggleAuthPage: toggleAuthPage);
  }
}
