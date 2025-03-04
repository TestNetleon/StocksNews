// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/models/ai_analysis.dart';
// import 'package:stocks_news_new/ui/base/border_container.dart';
// import 'package:stocks_news_new/ui/base/heading.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import '../../../../utils/constants.dart';

// class AIOverviewPerformance extends StatelessWidget {
//   final AIPerformanceRes? performance;
//   const AIOverviewPerformance({super.key, this.performance});

//   @override
//   Widget build(BuildContext context) {
//     // num price = performance?.price ?? 0;
//     // num yearHigh = performance?.yearHigh ?? 0;
//     // num yearLow = performance?.yearLow ?? 0;
//     // num dayHigh = performance?.dayHigh ?? 0;
//     // num dayLow = performance?.dayLow ?? 0;

//     num price = 10;
//     num yearHigh = 100;
//     num yearLow = 0;
//     num dayHigh = 50;
//     num dayLow = 10;

//     Utils().showLog('Year High: $yearHigh, Low: $yearLow ');
//     Utils().showLog('Day High: $dayHigh, Low: $dayLow ');

//     return Container(
//       padding: EdgeInsets.only(
//         left: Pad.pad16,
//         right: Pad.pad16,
//         top: Pad.pad32,
//         bottom: Pad.pad10,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           BaseHeading(
//             title: performance?.title,
//             margin: EdgeInsets.only(
//               bottom: Pad.pad10,
//             ),
//           ),
//           BaseBorderContainer(
//             padding: EdgeInsets.zero,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 LayoutBuilder(
//                   builder: (context, constraints) {
//                     double width = constraints.maxWidth;

//                     num minValue = yearLow;
//                     num maxValue = yearHigh;
//                     num lowerBound = dayLow.clamp(minValue, maxValue);
//                     num upperBound = dayHigh.clamp(minValue, maxValue);

//                     double startPosition =
//                         ((lowerBound - minValue) / (maxValue - minValue)) *
//                             width;
//                     double endPosition =
//                         ((upperBound - minValue) / (maxValue - minValue)) *
//                             width;

//                     double greenBarWidth =
//                         (endPosition - startPosition).clamp(0, width);

//                     return SizedBox(
//                       height: 35,
//                       child: Stack(
//                         alignment: Alignment.bottomCenter,
//                         children: [
//                           Container(
//                             height: 8,
//                             decoration: BoxDecoration(
//                               color: ThemeColors.neutral5,
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Stack(
//                               children: [
//                                 Positioned(
//                                   left: startPosition,
//                                   child: Container(
//                                     width: greenBarWidth,
//                                     height: 8,
//                                     decoration: BoxDecoration(
//                                       color: Colors.green,
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Positioned(
//                             top: 0,
//                             left: ((price - yearLow) / (yearHigh - yearLow)) *
//                                 (width - 45),
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 Container(
//                                   margin: EdgeInsets.only(bottom: 5),
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 8, vertical: 2),
//                                   decoration: BoxDecoration(
//                                     color: ThemeColors.neutral5,
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Text(price.toFormattedPrice()),
//                                 ),
//                                 Positioned(
//                                   bottom: 0,
//                                   child: ClipPath(
//                                     clipper: TriangleClipper(),
//                                     child: Container(
//                                       width: 10,
//                                       height: 6,
//                                       color: ThemeColors.neutral5,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Flexible(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             yearLow.toFormattedPrice(),
//                             style: styleBaseBold(fontSize: 14),
//                           ),
//                           Text(
//                             '52 Week Low',
//                             style: styleBaseRegular(
//                               color: ThemeColors.neutral80,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Flexible(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             yearHigh.toFormattedPrice(),
//                             style: styleBaseBold(fontSize: 14),
//                           ),
//                           Text(
//                             '52 Week High',
//                             style: styleBaseRegular(
//                               color: ThemeColors.neutral80,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TriangleClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.moveTo(size.width / 2, size.height); // Bottom center
//     path.lineTo(0, 0); // Left corner
//     path.lineTo(size.width, 0); // Right corner
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(TriangleClipper oldClipper) => false;
// }

import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/ai_analysis.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../../../utils/constants.dart';

class AIOverviewPerformance extends StatelessWidget {
  final AIPerformanceRes? performance;
  const AIOverviewPerformance({super.key, this.performance});

  @override
  Widget build(BuildContext context) {
    // num price = performance?.price ?? 0;
    // num yearHigh = performance?.yearHigh ?? 0;
    // num yearLow = performance?.yearLow ?? 0;
    // num dayHigh = performance?.dayHigh ?? 0;
    // num dayLow = performance?.dayLow ?? 0;

    num price = 10;
    num yearHigh = 100;
    num yearLow = 0;
    num dayHigh = 50;
    num dayLow = 10;

    Utils().showLog('Year High: $yearHigh, Low: $yearLow ');
    Utils().showLog('Day High: $dayHigh, Low: $dayLow ');

    return Container(
      padding: EdgeInsets.only(
        left: Pad.pad16,
        right: Pad.pad16,
        top: Pad.pad32,
        bottom: Pad.pad10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseHeading(
            title: performance?.title,
            margin: EdgeInsets.only(
              bottom: Pad.pad10,
            ),
          ),
          BaseBorderContainer(
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            yearLow.toFormattedPrice(),
                            style: styleBaseBold(fontSize: 14),
                          ),
                          Text(
                            '52 Week Low',
                            style: styleBaseRegular(
                              color: ThemeColors.neutral80,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            yearHigh.toFormattedPrice(),
                            style: styleBaseBold(fontSize: 14),
                          ),
                          Text(
                            '52 Week High',
                            style: styleBaseRegular(
                              color: ThemeColors.neutral80,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, size.height); // Bottom center
    path.lineTo(0, 0); // Left corner
    path.lineTo(size.width, 0); // Right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
