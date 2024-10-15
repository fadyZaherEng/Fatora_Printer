import 'package:fatora/src/config/theme/color_schemes.dart';
import 'package:flutter/material.dart';

extension ColorExtension on String {
  toColor() {
    if (isEmpty) return ColorSchemes.primary;
    // var hexString = this;
    // int hexValue = int.parse(hexString, radix: 16); // Convert hexadecimal to integer
    //
    // int red = (hexValue >> 24) & 0xFF; // Extract red value
    // int green = (hexValue >> 16) & 0xFF; // Extract green value
    // int blue = (hexValue >> 8) & 0xFF; // Extract blue value
    // double opacity = (hexValue & 0xFF) / 255.0; // Extract opacity value and normalize to 0.0-1.0
    // return Color(int.parse(this.replaceAll("#", "0xFF"), radix: 16));
    return Color(int.parse(replaceAll("#", "ff"), radix: 16) | 0xFF000000);

    //return Color.fromRGBO(red, green, blue, opacity);
  }
}
