import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'colors/grx_colors.dart';
import 'grx_text_theme.theme.dart';
import 'typography/utils/grx_font_families.dart';

abstract class GrxThemeData {
  static final textTheme = const GrxTextTheme();

  static final inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: GrxColors.neutrals.shade200),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: GrxColors.neutrals.shade200),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: GrxColors.neutrals.shade50),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: GrxColors.primary.shade900, width: 1.25),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: GrxColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: GrxColors.error.shade200, width: 1.25),
    ),
    hintStyle: textTheme.bodyMedium?.copyWith(
      color: GrxColors.neutrals.shade700,
    ),
    labelStyle: textTheme.labelMedium?.copyWith(
      color: GrxColors.primary.shade900,
    ),
    errorStyle: textTheme.bodyMedium?.copyWith(color: GrxColors.error),
    floatingLabelBehavior: FloatingLabelBehavior.always,
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    // primarySwatch: GrxColors.primary,
    fontFamily: GrxFontFamilies.montserrat,
    // splashColor: GrxColors.primary.shade200,
    // highlightColor: GrxColors.primary.shade200,
    textTheme: textTheme,
    // progressIndicatorTheme: ProgressIndicatorThemeData(
    //   color: GrxColors.primary.shade700,
    // ),
    inputDecorationTheme: inputDecorationTheme,
    iconTheme: IconThemeData(color: GrxColors.primary.shade900),
    colorScheme: ColorScheme.fromSeed(
      seedColor: GrxColors.primary,
      error: GrxColors.error,
      secondary: GrxColors.secondary,
      surface: GrxColors.neutrals,
      surfaceContainer: GrxColors.neutrals,
      outline: GrxColors.neutrals.shade200,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    // primarySwatch: GrxColors.primary,
    fontFamily: GrxFontFamilies.montserrat,
    // splashColor: GrxColors.primary.shade200,
    // highlightColor: GrxColors.primary.shade200,
    textTheme: textTheme,
    // progressIndicatorTheme: ProgressIndicatorThemeData(
    //   color: GrxColors.primary.shade700,
    // ),
    inputDecorationTheme: inputDecorationTheme,
    iconTheme: IconThemeData(color: GrxColors.primary.shade900),
    colorScheme: ColorScheme.fromSeed(
      seedColor: GrxColors.primary,
      error: GrxColors.error,
      secondary: GrxColors.secondary,
      surface: GrxColors.neutrals,
      surfaceContainer: GrxColors.neutrals,
      outline: GrxColors.neutrals.shade200,
    ),
  );

  static final brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;
  static final isDarkMode = brightness == Brightness.dark;

  static ThemeData get theme => isDarkMode ? darkTheme : lightTheme;
}
