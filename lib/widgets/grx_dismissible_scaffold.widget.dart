import 'package:flutter/material.dart';

import 'grx_dismissible_keyboard.widget.dart';

class GrxDismissibleScaffold extends GrxDismissibleKeyboard {
  GrxDismissibleScaffold({
    super.key,
    required final Widget body,
    final PreferredSizeWidget? appBar,
    final bool extendBody = false,
    final bool extendBodyBehindAppBar = false,
    final Color? backgroundColor,
    final Widget? bottomNavigationBar,
    final Widget? floatingActionButton,
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
