import 'package:flutter/material.dart';

class CellulesListPage extends StatelessWidget {
  const CellulesListPage({
    super.key,
    required this.animationController,
  });

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Cellules Page - Nothing to show'),
    );
  }
}
