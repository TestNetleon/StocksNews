import 'dart:io';
import 'package:flutter/material.dart';

class SpacerHorizontal extends StatelessWidget {
  const SpacerHorizontal({this.width = 22, super.key});
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: Platform.isAndroid ? width : width);
  }
}
//