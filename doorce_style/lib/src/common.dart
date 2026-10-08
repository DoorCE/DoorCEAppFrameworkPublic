import 'package:intl/intl.dart';

class DoorCommon {
  bool isValidType(String value, Object type) {
  switch (type) {
    case const (int):
      return int.tryParse(value) != null;
    case const (double):
      return double.tryParse(value) != null;
    case const (DateTime):
      return DateFormat("dd.MM.yyyy HH:mm").tryParse(value) != null;
    case const (bool):
      final v = value.toLowerCase();
      return v == 'true' || v == 'false';
    case const ((double, double)):
      return tryParsePoint(value) != null;
    case const (String):
      return true;
    default:
      return false;
  }
}

  dynamic parseValue(String value, Object type) {
    switch (type) {
      case const (int):
        return int.parse(value);
      case const (double):
        return double.parse(value);
      case const (DateTime):
        return DateFormat("dd.MM.yyyy HH:mm").parse(value);
      case const (bool):
        return bool.parse(value.toLowerCase());
      case const ((double, double)):
        return tryParsePoint(value);
      default:
        return value;
    }
  }

  (double, double)? tryParsePoint(String input) {
    final cleaned = input.replaceAll(RegExp(r'[()]'), '');
    final parts = cleaned.split(',');

    if (parts.length != 2) return null;

    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());

    if (lat == null || lng == null) return null;

    return (lat, lng);
  }
}