import 'package:flutter/material.dart';

class GrxDismissibleScaffold extends GestureDetector {
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
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
