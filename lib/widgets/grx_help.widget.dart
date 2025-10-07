import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

import '../themes/icons/grx_icons.dart';
import '../utils/grx_utils.util.dart';
import 'typography/grx_label_text.widget.dart';

class GrxHelpWidget extends StatelessWidget {
  const GrxHelpWidget({super.key, this.text, this.body, this.width})
    : assert(text != null || body != null);

  final String? text;
  final Widget? body;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      child: const Icon(GrxIcons.help_outline, size: 20.0),
      onTap: () {
        showPopover(
          context: context,
          direction: PopoverDirection.top,
          transitionDuration: GrxUtils.defaultAnimationDuration,
          width: width ?? size.width - 32.0,
          arrowHeight: 15,
          arrowWidth: 30,
          bodyBuilder:
              (context) =>
                  body ??
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    child: GrxLabelText(text!, overflow: TextOverflow.visible),
                  ),
        );
      },
    );
  }
}
