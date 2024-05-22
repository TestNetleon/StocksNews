import 'package:flutter/material.dart';

class SpacerVertical extends StatelessWidget {
  const SpacerVertical({this.height = 20, super.key});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
//