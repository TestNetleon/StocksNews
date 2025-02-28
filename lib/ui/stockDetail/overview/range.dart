// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import '../../../widgets/spacer_horizontal.dart';

// class StocksDetailRange extends StatelessWidget {
//   final String title;
//   final num startValue, endValue, mainValue;
//   final String startString, endString;

//   const StocksDetailRange({
//     super.key,
//     required this.title,
//     required this.startValue,
//     required this.endValue,
//     required this.mainValue,
//     required this.startString,
//     required this.endString,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: ThemeColors.neutral5),
//       ),
//       padding: EdgeInsets.all(12),
//       margin: EdgeInsets.symmetric(vertical: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style:
//                 styleBaseSemiBold(fontSize: 12, color: ThemeColors.neutral80),
//           ),
//           const SpacerVertical(height: 5),
//           Row(
//             children: [
//               Text(
//                 startString,
//                 style: styleBaseSemiBold(fontSize: 13),
//               ),
//               const SpacerHorizontal(width: 8),
//               Expanded(
//                 child: Container(
//                   color: Colors.amber,
//                   height: 9,
//                   child: Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           color: ThemeColors.neutral5,
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         height: 5.sp,
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         child: CustomPaint(
//                           painter: LineBarWithPointerPainter(
//                             startPoint: startValue.toDouble(),
//                             endPoint: endValue.toDouble(),
//                             value: mainValue.toDouble(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SpacerHorizontal(width: 8),
//               Text(
//                 endString,
//                 style: styleBaseSemiBold(fontSize: 13),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class LineBarWithPointerPainter extends CustomPainter {
//   final double startPoint;
//   final double endPoint;
//   final double value;

//   LineBarWithPointerPainter({
//     required this.startPoint,
//     required this.endPoint,
//     required this.value,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     double adjustedValue = value.clamp(startPoint, endPoint);

//     Paint linePaint = Paint()
//       ..color = ThemeColors.neutral5
//       ..strokeWidth = 2;
//     canvas.drawLine(
//         Offset(0.0, size.height), Offset(size.width, size.height), linePaint);

//     Paint pointerPaint = Paint()
//       ..color = ThemeColors.accent
//       ..strokeWidth = 2.0
//       ..strokeCap = StrokeCap.round
//       ..style = PaintingStyle.fill;

//     double pointerPosition =
//         (adjustedValue - startPoint) / (endPoint - startPoint) * size.width;
//     Path path = Path()
//       ..moveTo(pointerPosition, size.height / 2 + 5)
//       ..lineTo(pointerPosition - 5, size.height / 2 + 15)
//       ..lineTo(pointerPosition + 5, size.height / 2 + 15)
//       ..close();
//     canvas.drawPath(path, pointerPaint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../widgets/spacer_horizontal.dart';

class StocksDetailRange extends StatelessWidget {
  final String title;
  final num startValue, endValue, mainValue;
  final String startString, endString;

  const StocksDetailRange({
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
            style:
                styleBaseSemiBold(fontSize: 12, color: ThemeColors.neutral80),
          ),
          const SpacerVertical(height: 5),
          Row(
            children: [
              Text(
                startString,
                style: styleBaseSemiBold(fontSize: 12),
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
                            painter:
                                TrianglePainter(color: ThemeColors.neutral80),
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
                style: styleBaseSemiBold(fontSize: 12),
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
