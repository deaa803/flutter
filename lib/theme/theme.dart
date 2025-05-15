// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:vetlink1/colors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.lightPrimary,
  scaffoldBackgroundColor: AppColors.lightBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.lightPrimary,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  colorScheme: const ColorScheme.light(
    primary: AppColors.lightPrimary,
    secondary: AppColors.lightAccent,
    background: AppColors.lightBackground,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: AppColors.lightBackground,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black87),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.darkPrimary,
  scaffoldBackgroundColor: AppColors.darkBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkPrimary,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: const ColorScheme.dark(
    primary: AppColors.darkPrimary,
    secondary: AppColors.darkAccent,
    background: AppColors.darkBackground,
  ),
  drawerTheme: const DrawerThemeData(backgroundColor: AppColors.darkBackground),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
);
