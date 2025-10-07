import 'package:flutter/material.dart';
import 'package:grex_ds/grex_ds.dart';

class ButtonsSample extends StatefulWidget {
  const ButtonsSample({super.key});

  @override
  State<ButtonsSample> createState() => _ButtonsSampleState();
}

class _ButtonsSampleState extends State<ButtonsSample> {
  bool isLoading = false;

  void _onPressed() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16.0,
        children: [
          GrxPrimaryButton(
            text: 'Primary Button Full Width',
            mainAxisSize: MainAxisSize.max,
            onPressed: () {},
          ),
          GrxPrimaryButton(text: 'Primary Button', onPressed: () {}),
          GrxPrimaryButton(
            text: 'Primary Button with Icon',
            icon: GrxIcons.check,
            onPressed: () {},
          ),
          GrxPrimaryButton(
            text: 'Primary Button Loading',
            isLoading: isLoading,
            onPressed: _onPressed,
          ),
          GrxSecondaryButton(
            text: 'Secondary Button Full Width',
            mainAxisSize: MainAxisSize.max,
            onPressed: () {},
          ),
          GrxSecondaryButton(text: 'Secondary Button', onPressed: () {}),
          GrxSecondaryButton(
            text: 'Secondary Button with Icon',
            icon: GrxIcons.check,
            onPressed: () {},
          ),
          GrxSecondaryButton(
            text: 'Secondary Button Loading',
            isLoading: isLoading,
            onPressed: _onPressed,
          ),
          GrxIconButton(icon: GrxIcons.check, onPressed: () {}),
          GrxIconButton(
            icon: GrxIcons.check,
            isLoading: isLoading,
            onPressed: _onPressed,
          ),
          GrxTertiaryButton(
            text: 'Tertiary Button Full Width',
            mainAxisSize: MainAxisSize.max,
            onPressed: () {},
          ),
          GrxTertiaryButton(text: 'Tertiary Button', onPressed: () {}),
          GrxTertiaryButton(
            text: 'Tertiary Button with Icon',
            icon: GrxIcons.check,
            onPressed: () {},
          ),
          GrxTertiaryButton(
            text: 'Tertiary Button Loading',
            isLoading: isLoading,
            onPressed: _onPressed,
          ),
          GrxFilterButton(text: 'Filter Button', onPressed: () {}),
          GrxCircleButton(child: Icon(GrxIcons.check), onPressed: () {}),
          GrxCircleButton(
            isLoading: isLoading,
            onPressed: _onPressed,
            child: Icon(GrxIcons.check),
          ),
        ],
      ),
    );
  }
}
