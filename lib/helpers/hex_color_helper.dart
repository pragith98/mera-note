import 'dart:ui';

class HexColorHelper extends Color {
  HexColorHelper(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    try {
      hexColor = hexColor.trim().toUpperCase().replaceAll('#', '');
      if (hexColor.length == 6) hexColor = 'FF$hexColor';
      return int.parse(hexColor, radix: 16);
    } catch (e) {
      return 0xFF000000;
    }
  }
}