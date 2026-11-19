import '../localization/app_localizations.dart';
import '../services/navigation.service.dart';

extension StringExtension on String {
  String get translate =>
      AppLocalizations.of(
        NavigationService.navigatorKey.currentContext!,
      )?.translate(this) ??
      this;
}
