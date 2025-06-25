import 'package:flutter/material.dart';

import 'grx_color.dart';

sealed class GrxColors {
  static const primary = GrxColor(0xff28b3f9, {
    50: Color(0xffddf1fc),
    100: Color(0xffb7e6fd),
    200: Color(0xff93d9fc),
    300: Color(0xff70ccfb),
    400: Color(0xff4cc0fa),
    500: Color(0xff07a5f5),
    600: Color(0xff068cd0),
    700: Color(0xff0574ab),
    800: Color(0xff045b87),
    900: Color(0xff034262),
  });

  static const secondary = GrxColor(0xff00ed97, {
    50: Color(0xffd8fff1),
    100: Color(0xffb1ffe3),
    200: Color(0xff8affd5),
    300: Color(0xff63ffc6),
    400: Color(0xff3cffb8),
    500: Color(0xff15ffaa),
    600: Color(0xff00ca81),
    700: Color(0xff00a76a),
    800: Color(0xff008354),
    900: Color(0xff00603d),
  });

  static const neutrals = GrxColor(0xfffafafa, {
    50: Color(0xffe7e7e7),
    100: Color(0xffd5d5d5),
    200: Color(0xffc2c2c2),
    300: Color(0xffb0b0b0),
    400: Color(0xff9d9d9d),
    500: Color(0xff8b8b8b),
    600: Color(0xff787878),
    700: Color(0xff666666),
    800: Color(0xff535353),
    900: Color(0xff414141),
    1000: Color(0xff2e2e2e),
  });

  static const success = GrxColor(0xffb4f9d9, {
    200: Color(0xff1eed8c),
    300: Color(0xff0ead62),
  });

  static const error = GrxColor(0xffe4626f, {
    200: Color(0xffc03744),
    300: Color(0xff8c1823),
  });

  static const warning = GrxColor(0xfff4c790, {
    200: Color(0xffeda145),
    300: Color(0xffcc7914),
  });

  static const background = Color(0xffdfeaf6);
  static const transparent = Color(0x00000000);
}
