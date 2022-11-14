import 'package:flutter/material.dart';

import '../themes/colors/grx_colors.dart';

class GrxBottomSheetService {
  final BuildContext context;
  final Widget Function(ScrollController?) builder;
  final Widget? fixedHeader;

  GrxBottomSheetService({
    required this.context,
    required this.builder,
    this.fixedHeader,
  });

  Widget _buildBottomSheet({ScrollController? controller}) {
    final window = WidgetsBinding.instance.window;
    
    return Container(
      margin: EdgeInsets.only(
        top: MediaQueryData.fromWindow(window).padding.top + 10,
      ),
      decoration: _border(),
      child: builder(controller),
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

  Future<void> show() {
    return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => _buildBottomSheet(),
    );
  }
}