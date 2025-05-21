import 'dart:ui';

class HexColorHelper extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Add opacity if missing
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColorHelper(final String hexColor) : super(_getColorFromHex(hexColor));
}