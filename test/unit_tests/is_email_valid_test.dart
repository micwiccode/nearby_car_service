import 'package:nearby_car_service/helpers/is_email_valid.dart';
import 'package:test/test.dart';

void main() {
  test('Function checks if email is valid', () {
    expect(isEmailValid(''), equals(false));
    expect(isEmailValid('       '), equals(false));
    expect(isEmailValid('a       a'), equals(false));
    expect(isEmailValid('a@       a'), equals(false));
    expect(isEmailValid('a@a'), equals(false));
    expect(isEmailValid('mysite.ourearth.com'), equals(false));
    expect(isEmailValid('mysite@.com.my'), equals(false));
    expect(isEmailValid('@you.me.net'), equals(false));
    expect(isEmailValid('mysite123@gmail.b'), equals(false));
    expect(isEmailValid('mysite@.org.org'), equals(false));
    expect(isEmailValid('m.kowalski@wp.pl'), equals(true));
    expect(isEmailValid('m.kowalski@wp .pl'), equals(false));
    expect(isEmailValid('m.kowalski@wp.pl '), equals(false));
    expect(isEmailValid('mysite@ourearth.com'), equals(true));
    expect(isEmailValid('my.ownsite@ourearth.org'), equals(true));
    expect(isEmailValid('mysite@you.me.net'), equals(true));
  });
}
