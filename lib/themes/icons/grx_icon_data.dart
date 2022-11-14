import 'package:flutter/widgets.dart';

import '../../utils/grx_utils.util.dart';

class GrxIconData extends IconData {
  static const _kFontFam = 'GrxIcons';
  static const String _kFontPkg = GrxUtils.packageName;

  const GrxIconData(super.codePoint)
      : super(
          fontFamily: GrxIconData._kFontFam,
          fontPackage: GrxIconData._kFontPkg,
        );
}
