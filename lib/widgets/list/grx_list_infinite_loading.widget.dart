import 'package:flutter/material.dart';

import '../grx_spinner_loading.widget.dart';

class GrxListInfiniteLoading extends StatelessWidget {
  const GrxListInfiniteLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 16.0,
        ),
        child: Center(
          child: GrxSpinnerLoading(),
        ),
      );
}
