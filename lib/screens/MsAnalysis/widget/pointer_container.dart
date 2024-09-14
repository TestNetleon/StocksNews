import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class MsPointerContainer extends StatelessWidget {
  final bool isDownwards;
  final String title;
  final Color? color;
  final TextStyle? style;
  final double width;
  const MsPointerContainer({
    super.key,
    this.isDownwards = false,
    required this.title,
    this.style,
    this.width = 80,
    this.color = ThemeColors.greyText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: !isDownwards,
          child: CustomPaint(
            size: Size(10, 6),
            painter: TrianglePointer(
              isDownwards: isDownwards,
              color: color ?? ThemeColors.greyText,
            ),
          ),
        ),
        Container(
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Text(
            textAlign: TextAlign.center,
            title,
            style: style ?? styleGeorgiaRegular(color: ThemeColors.background),
          ),
        ),
        Visibility(
          visible: isDownwards,
          child: CustomPaint(
            size: Size(10, 6),
            painter: TrianglePointer(
              isDownwards: isDownwards,
              color: color ?? ThemeColors.greyText,
            ),
          ),
        ),
      ],
    );
  }
}

class TrianglePointer extends CustomPainter {
  final bool isDownwards;
  final Color color;

  TrianglePointer({
    this.isDownwards = true,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    Path path = Path();

    if (isDownwards) {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
