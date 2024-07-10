import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/home_res.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../../../stockDetail/index.dart';

class StocksItemTrending extends StatelessWidget {
  final HomeTrendingData trending;

  const StocksItemTrending({
    required this.trending,
    super.key,
  });
//
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
              builder: (_) => StockDetail(symbol: trending.symbol)),
        );
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: ThemeColors.background,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(0.sp),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    width: 48,
                    height: 48,
                    child: ThemeImageView(url: trending.image),
                  ),
                ),
                const SpacerHorizontal(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trending.symbol,
                        style: styleGeorgiaBold(fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SpacerVertical(height: 5),
                      Text(
                        trending.name,
                        style: styleGeorgiaRegular(
                          color: ThemeColors.greyText,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SpacerVertical(height: 5),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Mentions: ${trending.sentiment.toInt()}",
                              style: stylePTSansRegular(fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(trending.price, style: stylePTSansBold(fontSize: 18)),
                    const SpacerVertical(height: 5),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "${trending.displayChange} (${trending.displayPercentage.toCurrency()}%)",
                            style: stylePTSansRegular(
                              fontSize: 14,
                              color: trending.displayPercentage > 0
                                  ? Colors.green
                                  : Colors.red,
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
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: CustomPaint(
          //     painter: HalfCirclePainter(
          //       color: trending.displayPercentage > 0
          //           ? Colors.green.withOpacity(0.2)
          //           : Colors.red.withOpacity(0.2),
          //     ),
          //     child: Container(
          //       height: 35,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class HalfCirclePainter extends CustomPainter {
  final Color color;

  HalfCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width / 2.5, size.height * 2),
      pi,
      pi,
      true,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}











// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/modals/home_res.dart';
// import 'package:stocks_news_new/route/my_app.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:stocks_news_new/widgets/theme_image_view.dart';

// import '../../../stockDetail/index.dart';

// class StocksItemTrending extends StatelessWidget {
//   final HomeTrendingData trending;

//   const StocksItemTrending({
//     required this.trending,
//     super.key,
//   });
// //
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           navigatorKey.currentContext!,
//           MaterialPageRoute(
//               builder: (_) => StockDetail(symbol: trending.symbol)),
//         );
//       },
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(0.sp),
//             child: Container(
//               padding: const EdgeInsets.all(5),
//               width: 43,
//               height: 43,
//               child: ThemeImageView(url: trending.image),
//             ),
//           ),
//           const SpacerHorizontal(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   trending.symbol,
//                   style: styleGeorgiaBold(fontSize: 14),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SpacerVertical(height: 5),
//                 Text(
//                   trending.name,
//                   style: styleGeorgiaRegular(
//                     color: ThemeColors.greyText,
//                     fontSize: 12,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SpacerVertical(height: 3),
//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       // TextSpan(
//                       //   text: "Mentions: ${trending.sentiment.toInt()} (",
//                       //   style: stylePTSansRegular(fontSize: 12),
//                       // ),
//                       TextSpan(
//                         text: "Mentions: ${trending.sentiment.toInt()}",
//                         style: stylePTSansRegular(fontSize: 12),
//                       ),
//                       // WidgetSpan(
//                       //   child: Padding(
//                       //     padding: EdgeInsets.zero,
//                       //     child: trending.sentiment > trending.lastSentiment
//                       //         ? Icon(
//                       //             Icons.arrow_drop_up,
//                       //             color: Colors.green,
//                       //             size: 18.sp,
//                       //           )
//                       //         : Icon(
//                       //             Icons.arrow_drop_down,
//                       //             color: Colors.red,
//                       //             size: 18.sp,
//                       //           ),
//                       //   ),
//                       // ),
//                       // TextSpan(
//                       //   text: "${trending.rank})",
//                       //   style: stylePTSansRegular(fontSize: 12),
//                       // ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//           const SpacerHorizontal(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(trending.price, style: stylePTSansBold(fontSize: 14)),
//               const SpacerVertical(height: 2),
//               RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text:
//                           "${trending.displayChange} (${trending.displayPercentage.toCurrency()}%)",
//                       style: stylePTSansRegular(
//                         fontSize: 11,
//                         color: trending.displayPercentage > 0
//                             ? Colors.green
//                             : Colors.red,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );

//     // return InkWell(
//     //   onTap: () {
//     //     Navigator.push(context, StockDetails.path,
//     //         arguments: trending.symbol);
//     //   },
//     //   child: Row(
//     //     children: [
//     //       ClipRRect(
//     //         borderRadius: BorderRadius.circular(0.sp),
//     //         child: Container(
//     //           padding: EdgeInsets.all(5.sp),
//     //           width: 43.sp,
//     //           height: 43.sp,
//     //           // Replace 'app_logo.png' with your app logo image path
//     //           child: ThemeImageView(url: trending.image),
//     //           // Image.network(
//     //           //   trending.image,
//     //           //   fit: BoxFit.cover,
//     //           // ),
//     //         ),
//     //       ),
//     //       const SpacerHorizontal(width: 12),
//     //       Expanded(
//     //         child: Column(
//     //           crossAxisAlignment: CrossAxisAlignment.start,
//     //           children: [
//     //             Text(
//     //               trending.symbol,
//     //               style: styleGeorgiaBold(fontSize: 14),
//     //               maxLines: 1,
//     //               overflow: TextOverflow.ellipsis,
//     //             ),
//     //             const SpacerVertical(height: 5),
//     //             Text(
//     //               trending.name,
//     //               style: styleGeorgiaRegular(
//     //                 color: ThemeColors.greyText,
//     //                 fontSize: 12,
//     //               ),
//     //               maxLines: 2,
//     //               overflow: TextOverflow.ellipsis,
//     //             ),
//     //           ],
//     //         ),
//     //       ),
//     //       const SpacerHorizontal(width: 10),
//     //       Column(
//     //         crossAxisAlignment: CrossAxisAlignment.end,
//     //         children: [
//     //           Text(trending.price, style: stylePTSansBold(fontSize: 14)),
//     //           const SpacerVertical(height: 2),
//     //           RichText(
//     //             text: TextSpan(
//     //               children: [
//     //                 TextSpan(
//     //                   text:
//     //                       "${trending.change > 0 ? '+' : ''}${trending.change.toCurrency()}",
//     //                   style: stylePTSansRegular(
//     //                     fontSize: 12,
//     //                     color: trending.change > 0 ? Colors.green : Colors.red,
//     //                   ),
//     //                 ),
//     //                 TextSpan(
//     //                   text: " ${trending.sentiment.toInt()} (",
//     //                   style: stylePTSansRegular(fontSize: 12),
//     //                 ),
//     //                 WidgetSpan(
//     //                   child: Padding(
//     //                     padding: EdgeInsets.zero,
//     //                     child: trending.sentiment > trending.lastSentiment
//     //                         ? Icon(
//     //                             Icons.arrow_drop_up,
//     //                             color: Colors.green,
//     //                             size: 18.sp,
//     //                           )
//     //                         : Icon(
//     //                             Icons.arrow_drop_down,
//     //                             color: Colors.red,
//     //                             size: 18.sp,
//     //                           ),
//     //                   ),
//     //                 ),
//     //                 TextSpan(
//     //                   text: "${trending.rank})",
//     //                   style: stylePTSansRegular(fontSize: 12),
//     //                 ),
//     //               ],
//     //             ),
//     //           )
//     //         ],
//     //       )
//     //     ],
//     //   ),
//     // );
//   }
// }
