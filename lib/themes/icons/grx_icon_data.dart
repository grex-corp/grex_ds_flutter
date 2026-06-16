import '../../utils/grx_utils.util.dart';

/// Font metadata for [GrxIcons].
///
/// [IconData] is final as of Flutter 3.44, so custom icons are created via
/// [IconData] directly using these constants.
abstract final class GrxIconData {
  static const fontFamily = 'GrxIcons';
  static const fontPackage = GrxUtils.packageName;
}
