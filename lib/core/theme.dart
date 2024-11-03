import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    primaryColor: Colors.purpleAccent,
    scaffoldBackgroundColor: Colors.white,
    dividerColor: Colors.grey,
    iconTheme: const IconThemeData(color: Colors.black38),
    textTheme: TextTheme(
      displayMedium: GoogleFonts.poppins(),
      titleMedium: GoogleFonts.poppins(),
    ),
  );
}
