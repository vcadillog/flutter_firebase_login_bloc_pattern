import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  primaryColorDark: const Color(0xFF0097A7),
  primaryColorLight: const Color(0xFFB2EBF2),
  primaryColor: Colors.purple,
  colorScheme: const ColorScheme.light(secondary: Color(0xFF009688)),
  visualDensity: VisualDensity.standard,
  scaffoldBackgroundColor: const Color.fromARGB(255, 53, 104, 197),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
