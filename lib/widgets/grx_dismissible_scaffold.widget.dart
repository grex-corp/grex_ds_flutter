import 'package:material_ui/material_ui.dart';

import 'grx_dismissible_keyboard.widget.dart';

class GrxDismissibleScaffold extends GrxDismissibleKeyboard {
  GrxDismissibleScaffold({
    super.key,
    required Widget body,
    PreferredSizeWidget? appBar,
    bool extendBody = false,
    bool extendBodyBehindAppBar = false,
    Color? backgroundColor,
    Widget? bottomNavigationBar,
    Widget? floatingActionButton,
  }) : super(
         child: Scaffold(
           backgroundColor: backgroundColor,
           appBar: appBar,
           extendBody: extendBody,
           extendBodyBehindAppBar: extendBodyBehindAppBar,
           body: body,
           bottomNavigationBar: bottomNavigationBar,
           floatingActionButton: floatingActionButton,
         ),
       );
}
