import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

final theme = ThemeData(
  primaryColor: kAccentColor,
  bottomSheetTheme:
      BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.black),
    ),
    labelStyle: GoogleFonts.montserrat(
      fontSize: 20,
      color: Colors.black,
      fontWeight: FontWeight.w100,
    ),
  ),
);
