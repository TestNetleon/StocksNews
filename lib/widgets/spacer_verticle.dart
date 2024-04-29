import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpacerVerticel extends StatelessWidget {
  const SpacerVerticel({this.height = 20, super.key});
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height.sp);
  }
}
//