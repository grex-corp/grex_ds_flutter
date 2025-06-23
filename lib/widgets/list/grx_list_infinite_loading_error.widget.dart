import 'package:flutter/material.dart';

import '../../themes/icons/grx_icons.dart';
import '../typography/grx_label_large_text.widget.dart';

class GrxListInfiniteLoadingError extends StatelessWidget {
  const GrxListInfiniteLoadingError({
    super.key,
    required this.text,
    this.onTap,
  });

  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GrxLabelLargeText(
                  text,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 4.0,
                ),
                const Icon(
                  GrxIcons.refresh,
                ),
              ],
            ),
          ),
        ),
      );
}
