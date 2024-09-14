import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    try {
      return int.parse(hexColor, radix: 16);
    } on FormatException catch (_) {
      Fluttertoast.showToast(
        msg: "Invalid Hex Code For The Color!",
        gravity: ToastGravity.BOTTOM,
      );

      return Colors.blue.value;
    }
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
