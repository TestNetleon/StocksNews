import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class StockDetailTopWidgetRange extends StatelessWidget {
  const StockDetailTopWidgetRange({super.key});

  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();

    KeyStats? keyStats = provider.data?.keyStats;
    return Container(
      margin: EdgeInsets.only(top: 10.sp, bottom: 5.sp),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.sp),
          border: Border.all(color: ThemeColors.gradientLight)),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 15.sp, horizontal: 5.sp),
                child: StockDetailRangeBar(
                  title: "Day's Range",
                  startValue: keyStats?.dayLowValue ?? 0,
                  endValue: keyStats?.dayHighValue ?? 100,
                  mainValue: keyStats?.priceValue ?? 50,
                  startString: "${keyStats?.dayLow ?? 0}",
                  endString: "${keyStats?.dayHigh ?? 0}",
                ),
              ),
            ),
            // SpacerHorizontal(width: 10),
            VerticalDivider(
              width: 10.sp,
              color: ThemeColors.gradientLight,
              thickness: 1,
            ),

            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 15.sp, horizontal: 5.sp),
                child: StockDetailRangeBar(
                  title: "52 wk Range",
                  startValue: keyStats?.yearLowValue ?? 0,
                  endValue: keyStats?.yearHighValue ?? 100,
                  mainValue: keyStats?.priceValue ?? 50,
                  startString: "${keyStats?.yearLow ?? 0}",
                  endString: "${keyStats?.yearHigh ?? 0}",
                ),
              ),
            ),
          ],
        ),

        // child: Column(
        //   children: [
        //     Padding(
        //       padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 10.sp),
        //       child: StockDetailRangeBar(
        //         title: "Day's Range",
        //         startValue: 0,
        //         endValue: 100,
        //         mainValue: 5,
        //         startString: "${keyStats?.dayLow ?? 0}",
        //         endString: "${keyStats?.dayHigh ?? 0}",
        //       ),
        //     ),
        //     // SpacerHorizontal(width: 10),
        //     Divider(
        //       height: 10.sp,
        //       color: ThemeColors.gradientLight,
        //       thickness: 1,
        //     ),

        //     Padding(
        //       padding: EdgeInsets.symmetric(vertical: 15.sp, horizontal: 10.sp),
        //       child: StockDetailRangeBar(
        //         title: "52 wk Range",
        //         startValue: 0,
        //         endValue: 100,
        //         mainValue: 70,
        //         startString: "${keyStats?.yearLow ?? 0}",
        //         endString: "${keyStats?.yearHigh ?? 0}",
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}

class StockDetailRangeBar extends StatelessWidget {
  final String title;
  final num startValue, endValue, mainValue;
  final String startString, endString;

  const StockDetailRangeBar({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: stylePTSansBold(fontSize: 12, color: ThemeColors.greyText),
        ),
        const SpacerVerticel(height: 5),
        Row(
          children: [
            Text(
              startString,
              style: stylePTSansRegular(fontSize: 10),
            ),
            const SpacerHorizontal(width: 5),
            Expanded(
              child: SizedBox(
                height: 2.sp,
                child: CustomPaint(
                  painter: LineBarWithPointerPainter(
                    startPoint: startValue.toDouble(),
                    endPoint: endValue.toDouble(),
                    value: mainValue.toDouble(),
                  ),
                ),
              ),
            ),
            const SpacerHorizontal(width: 5),
            Text(
              endString,
              style: stylePTSansRegular(fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }
}

class LineBarWithPointerPainter extends CustomPainter {
  final double startPoint;
  final double endPoint;
  final double value;

  LineBarWithPointerPainter({
    required this.startPoint,
    required this.endPoint,
    required this.value,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double adjustedValue = value.clamp(startPoint, endPoint);

    Paint linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    canvas.drawLine(
        Offset(0.0, size.height), Offset(size.width, size.height), linePaint);

    Paint pointerPaint = Paint()
      ..color = ThemeColors.accent
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    double pointerPosition =
        (adjustedValue - startPoint) / (endPoint - startPoint) * size.width;
    Path path = Path()
      ..moveTo(pointerPosition, size.height / 2 + 5)
      ..lineTo(pointerPosition - 5, size.height / 2 + 15)
      ..lineTo(pointerPosition + 5, size.height / 2 + 15)
      ..close();
    canvas.drawPath(path, pointerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
