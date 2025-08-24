import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      colorSchemeSeed: Colors.indigo,
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
