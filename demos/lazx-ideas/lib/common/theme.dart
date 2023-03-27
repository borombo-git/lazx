import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazx_idea/common/constants.dart';

final theme = ThemeData(
  accentColor: kAccentColor,
  bottomSheetTheme:
      BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: kAccentColor),
    ),
    labelStyle: GoogleFonts.montserrat(
      fontSize: 20,
      color: Colors.red,
      fontWeight: FontWeight.w100,
    ),
  ),
);
