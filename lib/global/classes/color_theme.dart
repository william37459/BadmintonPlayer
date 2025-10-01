import 'package:flutter/material.dart';

class CustomColorTheme {
  Color primaryColor;
  Color secondaryColor;
  Color fontColor;
  Color secondaryFontColor;
  Color backgroundColor;
  Color shadowColor;
  Color inputFieldColor;

  CustomColorTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.fontColor,
    required this.secondaryFontColor,
    required this.backgroundColor,
    required this.shadowColor,
    required this.inputFieldColor,
  });

  factory CustomColorTheme.light() {
    return CustomColorTheme(
      primaryColor: const Color(0xffDF2026),
      secondaryColor: const Color(0xff960E13),
      fontColor: Colors.black,
      secondaryFontColor: Colors.white,
      backgroundColor: Colors.white,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      inputFieldColor: const Color(0xffEBEBEB),
    );
  }

  factory CustomColorTheme.dark() {
    return CustomColorTheme(
      primaryColor: const Color(0xffDF2026),
      secondaryColor: const Color(0xff960E13),
      fontColor: Colors.white,
      secondaryFontColor: Colors.black,
      backgroundColor: const Color(0xFF121212),
      shadowColor: Colors.white.withValues(alpha: 0.3),
      inputFieldColor: const Color.fromARGB(255, 39, 39, 39),
    );
  }
}
