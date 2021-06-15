import 'package:nearby_car_service/helpers/get_year_to_now.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Get years to now function returns list of years from defined year to now',
      () {
    expect(getYearsToNow(-1), equals([]));
    expect(getYearsToNow(2022), equals([]));
    expect(getYearsToNow(2021), equals([2021]));
    expect(getYearsToNow(2020), equals([2021, 2020]));
    expect(getYearsToNow(2019), equals([2021, 2020, 2019]));
    expect(
        getYearsToNow(2010),
        equals([
          2021,
          2020,
          2019,
          2018,
          2017,
          2016,
          2015,
          2014,
          2013,
          2012,
          2011,
          2010,
        ]));
    expect(
        getYearsToNow(1990),
        equals([
          2021,
          2020,
          2019,
          2018,
          2017,
          2016,
          2015,
          2014,
          2013,
          2012,
          2011,
          2010,
          2009,
          2008,
          2007,
          2006,
          2005,
          2004,
          2003,
          2002,
          2001,
          2000,
          1999,
          1998,
          1997,
          1996,
          1995,
          1994,
          1993,
          1992,
          1991,
          1990,
        ]));
  });
}
