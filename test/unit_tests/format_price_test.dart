import 'package:nearby_car_service/helpers/format_price.dart';
import 'package:test/test.dart';

void main() {
  test('Function formats int to valid price', () {
    expect(formatPrice(-1), equals('-0.01€'));
    expect(formatPrice(-0), equals('0.0€'));
    expect(formatPrice(0), equals('0.0€'));
    expect(formatPrice(1), equals('0.01€'));
    expect(formatPrice(20), equals('0.2€'));
    expect(formatPrice(100), equals('1.0€'));
    expect(formatPrice(121), equals('1.21€'));
    expect(formatPrice(80212), equals('802.12€'));
  });
}
