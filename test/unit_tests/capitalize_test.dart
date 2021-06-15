import 'package:nearby_car_service/helpers/capitalize.dart';
import 'package:test/test.dart';

void main() {
  test('Function returns only first letter capitalized string', () {
    expect(capitalize(''), equals(''));
    expect(capitalize('Some text'), equals('Some text'));
    expect(capitalize('my name'), equals('My name'));
    expect(capitalize('holidays'), equals('Holidays'));
    expect(capitalize('COMPUTER'), equals('Computer'));
    expect(capitalize('_COMPUTER'), equals('_computer'));
    expect(capitalize(' mouse'), equals(' mouse'));
  });
}
