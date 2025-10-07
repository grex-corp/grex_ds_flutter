import 'package:flutter/widgets.dart';

const mobileWidth = 900;
const desktopWidth = 1180;

class GrxResponsiveLayout extends StatelessWidget {
  const GrxResponsiveLayout({
    super.key,
    required this.mobileView,
    required this.desktopView,
  });

  final Widget mobileView;
  final Widget desktopView;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, dimensions) {
        if (dimensions.maxWidth <= mobileWidth) {
          return mobileView;
        } else {
          return desktopView;
        }
      },
    );
  }
}
