import 'package:flutter/foundation.dart';
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          GrxSearchableSliverHeader(
            animationController: animationController,
            title: 'Title',
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final begin =
                    clampDouble((1 / (100 / index * 12)) * index, 0, 1);

                final contentAnimation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animationController,
                    curve: Interval(begin, 1.0, curve: Curves.fastOutSlowIn),
                  ),
                );

                animationController.forward();

                return AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: contentAnimation,
                      child: Transform(
                        transform: Matrix4.translationValues(
                            0.0, 30 * (1.0 - contentAnimation.value), 0.0),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(
                                40,
                              ),
                              child: Text('22'),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              childCount: 100,
            ),
          ),
        ],
      ),
    );
  }
}
