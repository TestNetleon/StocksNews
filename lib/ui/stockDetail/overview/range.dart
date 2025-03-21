import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../widgets/spacer_horizontal.dart';

class SDRange extends StatelessWidget {
  final String title;
  final num startValue, endValue, mainValue;
  final String startString, endString;

  const SDRange({
    super.key,
    required this.title,
    required this.startValue,
    required this.endValue,
    required this.mainValue,
    required this.startString,
    required this.endString,
  });

  @override
  Widget build(BuildContext context) {
    double barHeight = 5.sp;
    double triangleSize = 10.sp;

    bool isDark = context.watch<ThemeManager>().isDarkMode;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ThemeColors.neutral5),
      ),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: styleBaseRegular(fontSize: 12, color: ThemeColors.neutral20),
          ),
          const SpacerVertical(height: 16),
          Row(
            children: [
              Text(
                startString,
                // style: styleBaseSemiBold(fontSize: 12),
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontSize: 12),
              ),
              const SpacerHorizontal(width: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double barWidth = constraints.maxWidth;
                    double relativePosition =
                        ((mainValue - startValue) / (endValue - startValue))
                            .clamp(0.0, 1.0);
                    double trianglePosition = relativePosition * barWidth;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: barHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: ThemeColors.neutral5,
                          ),
                        ),
                        Positioned(
                          left: trianglePosition - (triangleSize / 2),
                          top: -(triangleSize - barHeight) / 1.2,
                          child: CustomPaint(
                            size: Size(triangleSize, triangleSize),
                            painter: TrianglePainter(
                              color: isDark
                                  ? ThemeColors.selectedBG
                                  : ThemeColors.neutral80,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SpacerHorizontal(width: 8),
              Text(
                endString,
                // style: styleBaseSemiBold(fontSize: 12),
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
