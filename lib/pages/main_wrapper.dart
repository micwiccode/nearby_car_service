import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'authentication/authentication.dart';
import 'home/home.dart';

class MainWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<User?>(context);

    return Home();
    // return user == null ? Authentication() : Home();
  }
}
