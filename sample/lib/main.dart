import 'package:grex_ds/grex_ds.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sample/pages/home_page.dart';

import 'localization/app_localizations.dart';
import 'services/navigation.service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: NavigationService.navigatorKey,
      theme: GrxThemeData.theme,
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: const [Locale('pt'), Locale('en'), Locale('es')],
      home: const HomePage(),
    );
  }
}
