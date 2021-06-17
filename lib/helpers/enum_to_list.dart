import 'package:enum_to_string/enum_to_string.dart';

List<String> enumToList(enumeration, {camelCase = true}) {
  return EnumToString.toList(enumeration, camelCase: camelCase);
}
