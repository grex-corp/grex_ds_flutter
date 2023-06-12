import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';

class PeopleListPage extends StatelessWidget {
  const PeopleListPage({
    super.key,
    required this.animationController,
  });

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    animationController.forward();

    return Scaffold(
      body: GrxSliverAnimatedList(
        animationController: animationController,
        title: 'Title',
        list: List.filled(100, 1),
        padding: const EdgeInsets.only(
          bottom: 120.0,
        ),
        itemBuilder: (item, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GrxCard(
              child: Padding(
                padding: const EdgeInsets.all(
                  40.0,
                ),
                child: Text('$index'),
              ),
            ),
          );
        },
      ),
    );
  }
}
