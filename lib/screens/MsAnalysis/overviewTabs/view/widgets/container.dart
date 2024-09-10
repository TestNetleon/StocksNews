import 'package:flutter/material.dart';

class MsOverviewContainer extends StatelessWidget {
  final Widget? animatedChild;
  final Widget? baseChild;
  final EdgeInsets? margin;

  final bool open;
  const MsOverviewContainer({
    super.key,
    this.animatedChild,
    this.margin,
    this.baseChild,
    required this.open,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: margin ?? EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF2F2F2F),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            baseChild ?? SizedBox(),
            AnimatedSize(
              duration: const Duration(milliseconds: 100),
              alignment: Alignment.topCenter,
              child: open ? animatedChild : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
