import 'package:nearby_car_service/helpers/enum_to_list.dart';
import 'package:test/test.dart';

enum Enum1 { petrol, gas, diesel, hybrid, electric }
enum Enum2 { s }
enum Enum3 { a, s, d, f }
enum Enum4 {
  something123,
  something124,
  something125,
  something126,
  something127
}
enum Enum5 { aa, bb, cc, dd, ee }

void main() {
  test('Function returns list of strings from enum object', () {
    expect(enumToList(Enum1.values, camelCase: false),
        equals(['petrol', 'gas', 'diesel', 'hybrid', 'electric']));
    expect(enumToList(Enum1.values),
        equals(['Petrol', 'Gas', 'Diesel', 'Hybrid', 'Electric']));
    expect(enumToList(Enum2.values, camelCase: false), equals(['s']));
    expect(enumToList(Enum3.values, camelCase: false),
        equals(['a', 's', 'd', 'f']));
    expect(
        enumToList(Enum4.values, camelCase: false),
        equals([
          'something123',
          'something124',
          'something125',
          'something126',
          'something127'
        ]));
    expect(enumToList(Enum5.values, camelCase: false),
        equals(['aa', 'bb', 'cc', 'dd', 'ee']));
    expect(enumToList(Enum5.values), equals(['Aa', 'Bb', 'Cc', 'Dd', 'Ee']));
    expect(enumToList(Enum3.values),
        equals(['A', 'S', 'D', 'F']));
    expect(enumToList(Enum2.values), equals(['S']));
  });
}
