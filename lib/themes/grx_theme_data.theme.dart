import 'package:flutter/material.dart';

import 'colors/grx_colors.dart';
import 'grx_text_theme.theme.dart';
import 'typography/utils/grx_font_families.dart';

abstract class GrxThemeData {
  static get theme => ThemeData(
        primarySwatch: GrxColors.primarySwatch,
        fontFamily: GrxFontFamilies.montserrat,
        splashColor: GrxColors.cff7593b5.withOpacity(.3),
        highlightColor: GrxColors.cff7593b5.withOpacity(.2),
        textTheme: const GrxTextTheme(),
      );
}
