import 'package:flutter/material.dart';

import '../themes/colors/grx_colors.dart';
import '../widgets/bottomSheet/bottom_sheet_grabber.widget.dart';

class GrxBottomSheetService {
  GrxBottomSheetService({
    required this.context,
    required this.builder,
    this.title,
  });

  final BuildContext context;
  final Widget Function(ScrollController?) builder;
  final String? title;

  Widget _buildBottomSheet({ScrollController? controller}) {
    final window = WidgetsBinding.instance.window;

    return Container(
      margin: EdgeInsets.only(
        top: MediaQueryData.fromWindow(window).padding.top + 10,
      ),
      decoration: _border(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetGrabber(
            title: title,
          ),
          _buildChild(controller),
        ],
      ),
    );
  }

  BoxDecoration _border() {
    return const BoxDecoration(
      color: GrxColors.cffffffff,
      borderRadius: BorderRadius.only(
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
    );
  }

  Future<T?> show<T>() {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _buildBottomSheet(),
    );
  }
}
