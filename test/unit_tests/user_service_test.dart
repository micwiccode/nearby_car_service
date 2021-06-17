import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';
import 'package:nearby_car_service/models/app_user.dart';
import 'package:nearby_car_service/utils/auth_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

import 'mock.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  MockFirebaseAuth _auth = MockFirebaseAuth();
  BehaviorSubject<MockUser> _user = BehaviorSubject<MockUser>();
  AuthService _authService = AuthService();

  Firebase.initializeApp();
  // group('AppUserService test', () {
  //   when(_auth.signInWithEmailAndPassword(email: "email", password: "password"))
  //       .thenAnswer((_) async {
  //     _user.add(MockUser());
  //     return MockUserCredential();
  //   });

  //   when(_auth.signInWithEmailAndPassword(email: "mail", password: "pass"))
  //       .thenThrow(() {
  //     return null;
  //   });

  //   test('Sign in with password and email', () async {
  //     AppUser? appUser = await _authService.signIn('email', 'password');
  //     expect(appUser?.email, 'email');
  //   });

  // test('Sign up with password and email', () {});

  // test('Sign out', () {});
  // });
}
