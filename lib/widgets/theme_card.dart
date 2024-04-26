import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ThemeCard extends StatelessWidget {
  const ThemeCard({
    required this.child,
    this.elevation = .5,
    this.radius = 4,
    this.color = Colors.white,
    this.margin = EdgeInsets.zero,
    super.key,
  });

  final double elevation, radius;
  final EdgeInsets margin;
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.sp),
      ),
      color: color,
      margin: margin,
      shadowColor: Colors.grey[100],
      elevation: elevation,
      child: child,
    );
  }
}
