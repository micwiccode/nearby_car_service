import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearby_car_service/helpers/is_email_valid.dart';
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
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');
  final AuthService _auth = AuthService();
  bool _isPasswordVisible = false;
  String _error = '';
  bool _isLoading = false;

  handleSignIn() async {
    if (_signInFormKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      dynamic result = await _auth.signIn(
          _emailController.text.trim(), _passwordController.text.trim());
      if (result == null) {
        setState(() {
          _error = 'Invalid credentials';
          _isLoading = false;
        });
      }
    }
  }

  Widget formInner() {
    return Container(
      margin: EdgeInsets.all(15.0),
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
              TextFormFieldWidget(
                labelText: 'Email',
                controller: _emailController,
                functionValidate: () {
                  if (!isEmailValid(_emailController.text.trim())) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),
              TextFormFieldWidget(
                labelText: "Password",
                obscureText: !_isPasswordVisible,
                controller: _passwordController,
                isLastFormInput: true,
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
              ErrorMessage(error: _error),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Button(
                      text: 'Log in',
                      onPressed: handleSignIn,
                      isLoading: _isLoading)),
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
