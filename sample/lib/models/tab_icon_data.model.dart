import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    required this.imagePath,
    required this.selectedImagePath,
    required this.index,
    this.name,
    this.nameBuilder,
    this.animationController,
    this.isSelected = false,
  }) : assert(
          (name?.isNotEmpty ?? false) || nameBuilder != null,
        );

  String imagePath;
  String selectedImagePath;
  int index;
  String? name;
  String Function()? nameBuilder;
  AnimationController? animationController;
  bool isSelected;
}
