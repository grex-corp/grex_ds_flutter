import 'package:material_ui/material_ui.dart';

class GrxColor extends MaterialColor {
  const GrxColor(super.primary, super.swatch);

  /// The darkest shade.
  Color get shade1000 => this[1000]!;
}
