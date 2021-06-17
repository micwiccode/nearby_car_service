import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_car_service/pages/authentication/sign_in_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  testWidgets('Sign up page has proper structure', (WidgetTester tester) async {
    await tester.pumpWidget(SignInPage(toggleAuthPage: () => null));
  });
}
