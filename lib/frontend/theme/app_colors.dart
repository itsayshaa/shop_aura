import 'package:flutter/material.dart';

class AppColors {
  AppColors._();


  static const Color primary = Color(0xFF7B1E3A);
  static const Color primaryHover = Color(0xFF64182F);


  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color secondary = Color(0xFFF8E9ED);
  static const Color secondarySoft = Color(0xFFFDF5F7);


  static const Color accent = Color(0xFFA02C52);
  static const Color accentHover = Color(0xFF7B1E3A);
  static const Color accentSoft = Color(0xFFF8E9ED);


  static const Color success = Color(0xFF22C55E);
  static const Color successBackground = Color(0xFFDCFCE7);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBackground = Color(0xFFFEF3C7);

  static const Color danger = Color(0xFFEF4444);
  static const Color dangerBackground = Color(0xFFFEE2E2);


  static const Color border = Color(0xFFE5E7EB);


  static const Color text = Color(0xFF1F2937);
  static const Color textSoft = Color(0xFF6B7280);


  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primary,
      primaryHover,
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      accent,
      primary,
    ],
  );
}