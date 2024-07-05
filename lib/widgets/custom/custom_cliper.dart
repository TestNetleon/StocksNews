import 'package:flutter/material.dart';

class CustomClipPathTopContainerOne extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path0 = Path();
    path0.moveTo(0, size.height);
    path0.lineTo(0, size.height * 0.4890143);
    path0.lineTo(0, 0);
    path0.lineTo(size.width * 0.8545167, 0);
    path0.lineTo(size.width, size.height * 0.4991714);
    path0.lineTo(size.width * 0.8551250, size.height);
    path0.lineTo(0, size.height);
    path0.lineTo(size.width * 0.0013417, size.height);
    path0.lineTo(0, size.height);
    path0.close();
    return path0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
