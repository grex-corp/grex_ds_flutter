import 'package:get/get.dart';

import '../localization/app_localizations.dart';

extension StringExtension on String {
  String get translate =>
      AppLocalizations.of(Get.context!)?.translate(this) ?? this;
}
