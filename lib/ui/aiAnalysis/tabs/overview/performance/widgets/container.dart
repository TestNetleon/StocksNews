import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class AIPointerContainer extends StatelessWidget {
  final bool isDownwards;
  final String title;
  final Color? color;
  final TextStyle? style;
  final double width;
  const AIPointerContainer({
    super.key,
    this.isDownwards = false,
    required this.title,
    this.style,
    this.width = 65,
    this.color = ThemeColors.neutral5,
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
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          child: AutoSizeText(
            textAlign: TextAlign.center,
            maxLines: 1,
            title,
            style: style ?? styleBaseRegular(color: ThemeColors.background),
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

class AIPointerContainerNew extends StatelessWidget {
  final bool isDownwards;
  final String title;
  final Color? color;
  final TextStyle? style;
  final double width;
  const AIPointerContainerNew({
    super.key,
    this.isDownwards = false,
    required this.title,
    this.style,
    this.width = 65,
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
          child: AutoSizeText(
            textAlign: TextAlign.center,
            maxLines: 1,
            title,
            style: styleBaseBold(
              color: ThemeColors.background,
              fontSize: 12,
            ),
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
