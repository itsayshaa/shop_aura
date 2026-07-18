import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF2E2926);
  static const Color primaryDark = Color.fromARGB(255, 31, 28, 26);
  static const Color primaryHover = Color(0xFF1E1A16);

  // Background
  static const Color background = Color(0xFFF7F3EE);
  static const Color surface = Color(0xFFFFFFFF);

  // Secondary
  static const Color secondary = Color(0xFFEFDDC8);
  static const Color secondarySoft = Color(0xFFF7EEE1);

  // Status
  static const Color success = Color(0xFF3F9D5E);
  static const Color successBackground = Color(0xFFE8F5EC);

  static const Color warning = Color(0xFFD98A2B);
  static const Color warningBackground = Color(0xFFFBF0DF);

  static const Color danger = Color(0xFFC24B3F);
  static const Color dangerBackground = Color(0xFFFBEAE7);

  // Border
  static const Color border = Color(0xFFE7E0D6);

  // Text
  static const Color text = Color(0xFF2E2926);
  static const Color textSoft = Color(0xFF7A736A);

  // Extra
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  
    static const LinearGradient loginGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
}