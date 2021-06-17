import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nearby_car_service/helpers/is_email_valid.dart';
import 'package:nearby_car_service/utils/auth_service.dart';

import '../shared/text_form_field.dart';
import '../shared/button.dart';
import '../shared/error_message.dart';
import '../shared/google_sign_in_button.dart';

class SignUpPage extends StatefulWidget {
  final Function toggleAuthPage;
  SignUpPage({required this.toggleAuthPage, Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');
  TextEditingController _repeatPasswordController =
      TextEditingController(text: '');
  final AuthService _auth = AuthService();
  bool _isPasswordVisible = false;
  bool _isRepeatPasswordVisible = false;
  String _error = '';
  bool _isLoading = false;

  handleSignUp() async {
    if (_signUpFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _auth.signUp(
            _emailController.text.trim(), _passwordController.text.trim());
      } on FirebaseAuthException catch (error) {
        setState(() {
          _error = error.message!;
        });
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget formInner() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
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
            functionValidate: () {
              String trimmedPassword = _passwordController.text.trim();
              if (trimmedPassword.length < 6) {
                return 'Please enter password 6 <= characters';
              }
              if (_repeatPasswordController.text.trim() != trimmedPassword) {
                return 'Passwords are not eqaul';
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
          TextFormFieldWidget(
            labelText: "Repeat password",
            obscureText: !_isRepeatPasswordVisible,
            controller: _repeatPasswordController,
            isLastFormInput: true,
            functionValidate: () {
              String trimmedRepeatPassword =
                  _repeatPasswordController.text.trim();
              if (trimmedRepeatPassword.length < 1) {
                return 'Please enter password repeat';
              }
              if (trimmedRepeatPassword != _passwordController.text.trim()) {
                return 'Passwords are not eqaul';
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
          ErrorMessage(error: _error),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Button(
                  text: 'Sign up',
                  onPressed: handleSignUp,
                  isLoading: _isLoading)),
          Text("Already have an account?"),
          GestureDetector(
              onTap: () {
                widget.toggleAuthPage();
              },
              child: Text("Log in",
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(key: _signUpFormKey, child: formInner()),
      ),
    );
  }
}
