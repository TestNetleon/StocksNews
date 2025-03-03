// import 'dart:math';

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

// import '../../../stockDetail/scanner.dart';

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
//       child: Stack(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             decoration: BoxDecoration(
//               color: ThemeColors.background,
//               borderRadius: BorderRadius.circular(5),
//             ),
//             child: Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(0.sp),
//                   child: Container(
//                     padding: const EdgeInsets.all(5),
//                     width: 48,
//                     height: 48,
//                     child: ThemeImageView(url: trending.image),
//                   ),
//                 ),
//                 const SpacerHorizontal(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         trending.symbol,
//                         style: styleGeorgiaBold(fontSize: 18),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SpacerVertical(height: 5),
//                       Text(
//                         trending.name,
//                         style: styleGeorgiaRegular(
//                           color: ThemeColors.greyText,
//                           fontSize: 12,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SpacerVertical(height: 5),
//                       RichText(
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                               text: "Mentions: ${trending.sentiment.toInt()}",
//                               style: stylePTSansRegular(fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 const SpacerHorizontal(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(trending.price, style: stylePTSansBold(fontSize: 18)),
//                     const SpacerVertical(height: 5),
//                     RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text:
//                                 "${trending.displayChange} (${trending.displayPercentage.toCurrency()}%)",
//                             style: stylePTSansRegular(
//                               fontSize: 14,
//                               color: trending.displayPercentage > 0
//                                   ? Colors.green
//                                   : Colors.red,
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

// class HalfCirclePainter extends CustomPainter {
//   final Color color;

//   HalfCirclePainter({required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..color = color;
//     canvas.drawArc(
//       Rect.fromLTWH(0, 0, size.width / 2.5, size.height * 2),
//       pi,
//       pi,
//       true,
//       paint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/home_res.dart';
import 'package:stocks_news_new/modals/top_trending_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/slidable_menu.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/common_item_ui.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/dialogs.dart';

class StocksItemTrending extends StatelessWidget {
  final HomeTrendingData trending;
  final int index;

  const StocksItemTrending({
    required this.trending,
    required this.index,
    super.key,
  });
//
  @override
  Widget build(BuildContext context) {
    return SlidableMenuWidget(
      index: index,
      alertForBullish: trending.isAlertAdded?.toInt() ?? 0,
      watlistForBullish: trending.isWatchlistAdded?.toInt() ?? 0,
      onClickAlert: () => _onAlertClick(context),
      onClickWatchlist: () => _onWatchListClick(context),
      child: CommonItemUi(
        data: TopTrendingDataRes(
            lastSentiment: trending.sentiment.toInt(),
            image: trending.image,
            symbol: trending.symbol,
            isAlertAdded: trending.isAlertAdded ?? 0,
            isWatchlistAdded: trending.isWatchlistAdded ?? 0,
            name: trending.name,
            change: trending.displayChange,
            changePercentage: trending.displayPercentage,
            price: trending.price),
      ),
    );
    // return InkWell(
    //   onTap: () {
    //     Navigator.push(
    //       navigatorKey.currentContext!,
    //       MaterialPageRoute(
    //           builder: (_) => StockDetail(symbol: trending.symbol)),
    //     );
    //   },
    //   child: Stack(
    //     children: [
    //       Container(
    //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //         decoration: BoxDecoration(
    //           color: ThemeColors.background,
    //           borderRadius: BorderRadius.circular(5),
    //         ),
    //         child: Row(
    //           children: [
    //             ClipRRect(
    //               borderRadius: BorderRadius.circular(0.sp),
    //               child: Container(
    //                 padding: const EdgeInsets.all(5),
    //                 width: 48,
    //                 height: 48,
    //                 child: ThemeImageView(url: trending.image),
    //               ),
    //             ),
    //             const SpacerHorizontal(width: 12),
    //             Expanded(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text(
    //                     trending.symbol,
    //                     style: styleGeorgiaBold(fontSize: 18),
    //                     maxLines: 1,
    //                     overflow: TextOverflow.ellipsis,
    //                   ),
    //                   const SpacerVertical(height: 5),
    //                   Text(
    //                     trending.name,
    //                     style: styleGeorgiaRegular(
    //                       color: ThemeColors.greyText,
    //                       fontSize: 12,
    //                     ),
    //                     maxLines: 2,
    //                     overflow: TextOverflow.ellipsis,
    //                   ),
    //                   const SpacerVertical(height: 5),
    //                   RichText(
    //                     text: TextSpan(
    //                       children: [
    //                         TextSpan(
    //                           text: "Mentions: ${trending.sentiment.toInt()}",
    //                           style: stylePTSansRegular(fontSize: 12),
    //                         ),
    //                       ],
    //                     ),
    //                   )
    //                 ],
    //               ),
    //             ),
    //             const SpacerHorizontal(width: 10),
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.end,
    //               children: [
    //                 Text(trending.price, style: stylePTSansBold(fontSize: 18)),
    //                 const SpacerVertical(height: 5),
    //                 RichText(
    //                   text: TextSpan(
    //                     children: [
    //                       TextSpan(
    //                         text:
    //                             "${trending.displayChange} (${trending.displayPercentage.toCurrency()}%)",
    //                         style: stylePTSansRegular(
    //                           fontSize: 14,
    //                           color: trending.displayPercentage > 0
    //                               ? Colors.green
    //                               : Colors.red,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             )
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  void _onAlertClick(BuildContext context) async {
    if ((trending.isAlertAdded?.toInt() ?? 0) == 1) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const Alerts()),
      );
    } else {
      if (context.read<UserProvider>().user != null) {
        showPlatformBottomSheet(
          backgroundColor: const Color.fromARGB(255, 23, 23, 23),
          context: context,
          showClose: false,
          content: AlertPopup(
            insetPadding:
                EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
            symbol: trending.symbol,
            companyName: trending.name,
            index: index,
            homeTrending: true,
          ),
        );
        // _showAlertPopup(
        //     context: navigatorKey.currentContext!, symbol: symbol);
        return;
      }
      try {
        ApiResponse res =
            await context.read<HomeProvider>().getHomeTrendingData();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<HomeProvider>()
                  .homeTrendingRes!
                  .trending[index]
                  .isAlertAdded ??
              0;
          if (alertOn == 0) {
            showPlatformBottomSheet(
              backgroundColor: const Color.fromARGB(255, 23, 23, 23),
              context: context,
              showClose: false,
              content: AlertPopup(
                insetPadding:
                    EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
                symbol: trending.symbol,
                companyName: trending.name,
                index: index,
                fromTrending: true,
              ),
            );
          } else {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => const Alerts()),
            );
          }
        }
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  void _onWatchListClick(BuildContext context) async {
    if (trending.isWatchlistAdded == 1) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const WatchList()),
      );
    } else {
      if (context.read<UserProvider>().user != null) {
        await navigatorKey.currentContext!.read<HomeProvider>().addToWishList(
              type: "homeTrending",
              symbol: trending.symbol,
              companyName: trending.name,
              index: index,
              up: true,
            );
        return;
      }
      try {
        ApiResponse res = await navigatorKey.currentContext!
            .read<HomeProvider>()
            .getHomeTrendingData();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<HomeProvider>()
                  .homeTrendingRes!
                  .trending[index]
                  .isWatchlistAdded ??
              0;
          if (alertOn == 0) {
            await navigatorKey.currentContext!
                .read<HomeProvider>()
                .addToWishList(
                  type: "homeTrending",
                  symbol: trending.symbol,
                  companyName: trending.name,
                  index: index,
                  up: true,
                );
          } else {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => const WatchList()),
            );
          }
        }
      } catch (e) {
        //
      }
    }
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
