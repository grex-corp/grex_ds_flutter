import 'package:flutter/material.dart';

import '../themes/colors/grx_colors.dart';
import '../widgets/bottom_sheet/grx_bottom_sheet_grabber.widget.dart';

class GrxBottomSheetService {
  GrxBottomSheetService({
    required this.context,
    required this.builder,
    this.title,
    this.backgroundColor = GrxColors.cffffffff,
  });

  final BuildContext context;
  final Widget Function(ScrollController?) builder;
  final String? title;
  final Color backgroundColor;

  bool isOpened = false;

  Widget _buildBottomSheet({
    ScrollController? controller,
    final bool hideGrabber = false,
  }) {
    return Container(
      decoration: _border(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: !hideGrabber,
            child: GrxBottomSheetGrabber(
              title: title,
            ),
          ),
          _buildChild(controller),
        ],
      ),
    );
  }

  BoxDecoration _border() {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(22.0),
        topRight: Radius.circular(22.0),
      ),
    );
  }

  Widget _buildChild(ScrollController? controller) {
    return Flexible(
      child: builder(controller),
    );
  }

  Future<T?> showDraggable<T>({
    final double minSize = 0.25,
    final double initSize = 1.0,
  }) {
    isOpened = true;

    return showModalBottomSheet<T>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 1,
          minChildSize: minSize,
          initialChildSize: initSize,
          builder: (_, controller) => _buildBottomSheet(controller: controller),
        );
      },
    ).then((value) {
      isOpened = false;
      return value;
    });
  }

  Future<T?> showUndisposable<T>({
    final bool isScrollControlled = true,
  }) {
    isOpened = true;

    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled,
      enableDrag: false,
      isDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: _buildBottomSheet(
          hideGrabber: true,
        ),
      ),
    ).then((value) {
      isOpened = false;
      return value;
    });
  }

  Future<T?> show<T>({
    final bool isScrollControlled = true,
  }) {
    isOpened = true;

    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled,
      useSafeArea: true,
      builder: (_) => _buildBottomSheet(),
    ).then((value) {
      isOpened = false;
      return value;
    });
  }

  void dispose() {
    if (isOpened) {
      Navigator.of(context).pop();
    }
  }
}
