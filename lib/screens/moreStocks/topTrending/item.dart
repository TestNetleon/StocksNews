import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/top_trending_res.dart';
import 'package:stocks_news_new/providers/top_trending_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/popup_menu.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../../../utils/dialogs.dart';
import '../../stockDetail/index.dart';

//
class TopTrendingItem extends StatefulWidget {
  final int index;
  final TopTrendingDataRes data;
  final bool alertAdded;
  final bool watchlistAdded;
  final String type;

  const TopTrendingItem({
    super.key,
    required this.data,
    required this.index,
    this.alertAdded = false,
    this.watchlistAdded = false,
    this.type = "Cap",
  });

  @override
  State<TopTrendingItem> createState() => _TopTrendingItemState();
}

class _TopTrendingItemState extends State<TopTrendingItem> {
  bool userPresent = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userPresent = context.read<UserProvider>().user != null;
      Utils().showLog("USER PRESENT $userPresent");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: ThemeColors.background,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      navigatorKey.currentContext!,
                      MaterialPageRoute(
                        builder: (_) => StockDetail(symbol: widget.data.symbol),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0.sp),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          width: 48,
                          height: 48,
                          child: ThemeImageView(url: widget.data.image ?? ""),
                        ),
                      ),
                      const SpacerHorizontal(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.data.symbol,
                              style: stylePTSansBold(fontSize: 18),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SpacerVertical(height: 5),
                            Text(
                              widget.data.name,
                              style: stylePTSansBold(
                                color: ThemeColors.greyText,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SpacerVertical(height: 5),
                            Row(
                              children: [
                                Text(
                                  textAlign: TextAlign.end,
                                  "Mentions: ${widget.data.sentiment}",
                                  style: stylePTSansBold(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SpacerHorizontal(width: 8),
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "(",
                                          style: stylePTSansBold(fontSize: 12),
                                        ),
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.zero,
                                            child: (widget.data.sentiment ??
                                                        0) >
                                                    (widget.data
                                                            .lastSentiment ??
                                                        0)
                                                ? Icon(
                                                    Icons.arrow_drop_up,
                                                    color: ThemeColors.accent,
                                                    size: 14.sp,
                                                  )
                                                : Icon(
                                                    Icons.arrow_drop_down,
                                                    color: ThemeColors.sos,
                                                    size: 14.sp,
                                                  ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: "${widget.data.rank})",
                                          style: stylePTSansBold(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SpacerHorizontal(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.data.price ?? "",
                    style: stylePTSansBold(fontSize: 18),
                    maxLines: 2,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    "${widget.data.change?.toCurrency()} (${widget.data.changePercentage?.toCurrency()}%)",
                    style: stylePTSansBold(
                      color: widget.data.change == 0
                          ? ThemeColors.white
                          : (widget.data.change ?? 0) > 0
                              ? ThemeColors.accent
                              : ThemeColors.sos,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SpacerHorizontal(width: 4),
              PopUpMenuButtonCommon(
                symbol: widget.data.symbol,
                onClickAlert: () => _alertElse(context),
                onClickWatchlist: () => _watchlistElse(context),
                watchlistString: widget.watchlistAdded
                    ? 'Watchlist Added'
                    : 'Add to Watchlist',
                alertString: widget.alertAdded ? 'Alert Added' : 'Add to Alert',
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAlertPopup(BuildContext context) {
    log("message");
    showPlatformBottomSheet(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
      context: context,
      showClose: false,
      content: AlertPopup(
        fromTopStock: true,
        insetPadding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
        symbol: widget.data.symbol,
        index: widget.index,
      ),
    );

    // Navigator.push(
    //   context,
    //   createRoute(
    //     AlertPopUpDialog(
    //       content: AlertPopup(
    //         fromTopStock: true,
    //         insetPadding:
    //             EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
    //         symbol: data.symbol,
    //         index: index,
    //       ),
    //     ),
    //   ),
    // );

    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertPopup(
    //         fromTopStock: true,
    //         insetPadding:
    //             EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
    //         symbol: data.symbol,
    //         index: index,
    //       );
    //     });
  }

  void _addToWatchlist(BuildContext context) {
    context.read<TopTrendingProvider>().addToWishList(
          symbol: widget.data.symbol,
          index: widget.index,
        );
  }

  void _navigateToAlert(BuildContext context) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const Alerts()),
    );
  }

  void _navigateToWatchlist(BuildContext context) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const WatchList()),
    );
  }

  Future _alertElse(BuildContext context) async {
    if (widget.alertAdded) {
      _navigateToAlert(context);
    } else {
      if (userPresent) {
        log("set HERE");
        _showAlertPopup(navigatorKey.currentContext!);
        return;
      }

      try {
        if (widget.type == 'Cap') {
          ApiResponse res =
              await context.read<TopTrendingProvider>().getCapData();
          if (res.status) {
            num alrtOn = navigatorKey.currentContext!
                    .read<TopTrendingProvider>()
                    .capData?[widget.index]
                    .isAlertAdded ??
                0;

            if (alrtOn == 0) {
              _showAlertPopup(navigatorKey.currentContext!);
            } else {
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(builder: (_) => const Alerts()),
              );
            }
          }
        } else if (widget.type == 'Recent') {
          ApiResponse res = await context
              .read<TopTrendingProvider>()
              .getNowRecentlyData(type: "recently");
          if (res.status) {
            num alrtOn = navigatorKey.currentContext!
                    .read<TopTrendingProvider>()
                    .data?[widget.index]
                    .isAlertAdded ??
                0;

            if (alrtOn == 0) {
              _showAlertPopup(navigatorKey.currentContext!);
            } else {
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(builder: (_) => const Alerts()),
              );
            }
          }
        } else {
          log("else");
          ApiResponse res = await context
              .read<TopTrendingProvider>()
              .getNowRecentlyData(type: "now");
          log("-----${res.status}");
          if (res.status) {
            num alrtOn = navigatorKey.currentContext!
                    .read<TopTrendingProvider>()
                    .data?[widget.index]
                    .isAlertAdded ??
                0;
            if (alrtOn == 0) {
              _showAlertPopup(navigatorKey.currentContext!);
            } else {
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(builder: (_) => const Alerts()),
              );
            }
          }
        }
      } catch (e) {
        //
        log("ERROR -> $e");
      }
    }
  }

  Future _watchlistElse(BuildContext context) async {
    if (widget.watchlistAdded) {
      _navigateToWatchlist(context);
    } else {
      if (userPresent) {
        log("set HERE");
        // _showAlertPopup(navigatorKey.currentContext!);
        _addToWatchlist(context);
        return;
      }
      Utils().showLog("Screen type is ${widget.type}");
      try {
        if (widget.type == 'Cap') {
          ApiResponse res =
              await context.read<TopTrendingProvider>().getCapData();
          if (res.status) {
            num watchOn = navigatorKey.currentContext!
                    .read<TopTrendingProvider>()
                    .capData?[widget.index]
                    .isWatchlistAdded ??
                0;

            if (watchOn == 0) {
              _addToWatchlist(context);
            } else {
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(builder: (_) => const WatchList()),
              );
            }
          }
        } else if (widget.type == 'Recent') {
          ApiResponse res = await context
              .read<TopTrendingProvider>()
              .getNowRecentlyData(type: "recently");
          if (res.status) {
            num watchOn = navigatorKey.currentContext!
                    .read<TopTrendingProvider>()
                    .data?[widget.index]
                    .isWatchlistAdded ??
                0;

            if (watchOn == 0) {
              _addToWatchlist(context);
            } else {
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(builder: (_) => const WatchList()),
              );
            }
          }
        } else if (widget.type == "Now") {
          log("else");
          ApiResponse res = await context
              .read<TopTrendingProvider>()
              .getNowRecentlyData(type: "now");
          log("-----${res.status}");
          if (res.status) {
            num watchOn = navigatorKey.currentContext!
                    .read<TopTrendingProvider>()
                    .data?[widget.index]
                    .isWatchlistAdded ??
                0;
            if (watchOn == 0) {
              _addToWatchlist(context);
            } else {
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(builder: (_) => const Alerts()),
              );
            }
          }
        }
      } catch (e) {
        //
        log("ERROR -> $e");
      }

      // _addToWatchlist(context);
    }
  }
}


















// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/top_trending_res.dart';
// import 'package:stocks_news_new/providers/top_trending_provider.dart';
// import 'package:stocks_news_new/route/my_app.dart';
// import 'package:stocks_news_new/screens/alerts/alerts.dart';
// import 'package:stocks_news_new/screens/stockDetails/widgets/AlertWatchlist/alert_popup.dart';
// import 'package:stocks_news_new/screens/tabs/trending/menuButton/popup_menu.dart';
// import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';

// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/theme_image_view.dart';

// import '../../../utils/dialogs.dart';
// import '../../stockDetail/index.dart';

// //
// class TopTrendingItem extends StatelessWidget {
//   final int index;
//   final TopTrendingDataRes data;
//   final bool alertAdded;
//   final bool watchlistAdded;

//   const TopTrendingItem({
//     super.key,
//     required this.data,
//     required this.index,
//     this.alertAdded = false,
//     this.watchlistAdded = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return SizedBox(
//           // padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
//           // decoration: BoxDecoration(
//           //     borderRadius: BorderRadius.circular(10.sp),
//           //     border: Border.all(color: ThemeColors.greyBorder),
//           //     color: ThemeColors.primaryLight),
//           child: Row(
//             children: [
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     navigatorKey.currentContext!,
//                     MaterialPageRoute(
//                       builder: (_) => StockDetail(symbol: data.symbol),
//                     ),
//                   );
//                 },
//                 child: Row(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(0.sp),
//                       child: Container(
//                         padding: const EdgeInsets.all(5),
//                         width: 43,
//                         height: 43,
//                         child: ThemeImageView(url: data.image ?? ""),
//                       ),
//                     ),
//                     const SpacerHorizontal(width: 4),
//                     SizedBox(
//                       width: constraints.maxWidth * .25,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             data.symbol,
//                             style: stylePTSansBold(fontSize: 10),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(
//                             data.name,
//                             style: stylePTSansBold(
//                               color: ThemeColors.greyText,
//                               fontSize: 10,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SpacerHorizontal(width: 4),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             data.price ?? "",
//                             style: stylePTSansBold(fontSize: 10),
//                             maxLines: 2,
//                             textAlign: TextAlign.end,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const SpacerHorizontal(width: 4),
//                         Expanded(
//                           // child: Text(
//                           //   "${data.change?.toCurrency()} (${data.changePercentage?.toCurrency()}%)",
//                           //   style: stylePTSansBold(
//                           //     color: data.change == 0
//                           //         ? ThemeColors.white
//                           //         : (data.change ?? 0) > 0
//                           //             ? ThemeColors.accent
//                           //             : ThemeColors.sos,
//                           //     fontSize: 10,
//                           //   ),
//                           //   maxLines: 2,
//                           //   textAlign: TextAlign.end,
//                           //   overflow: TextOverflow.ellipsis,
//                           // ),
//                           child: Text(
//                             // "\$201.99",
//                             textAlign: TextAlign.end,

//                             "${data.sentiment}",
//                             style: stylePTSansBold(fontSize: 10),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Expanded(
//                           // child: Text(
//                           //   // "\$201.99",
//                           //   textAlign: TextAlign.end,

//                           //   "${data.sentiment}",
//                           //   style: stylePTSansBold(fontSize: 10),
//                           //   maxLines: 1,
//                           //   overflow: TextOverflow.ellipsis,
//                           // ),
//                           child: Text(
//                             "${data.change?.toCurrency()} (${data.changePercentage?.toCurrency()}%)",
//                             style: stylePTSansBold(
//                               color: data.change == 0
//                                   ? ThemeColors.white
//                                   : (data.change ?? 0) > 0
//                                       ? ThemeColors.accent
//                                       : ThemeColors.sos,
//                               fontSize: 10,
//                             ),
//                             maxLines: 2,
//                             textAlign: TextAlign.end,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         const SpacerHorizontal(width: 4),
//                         Expanded(
//                           child: Align(
//                             alignment: Alignment.centerRight,
//                             child: RichText(
//                               text: TextSpan(
//                                 children: [
//                                   TextSpan(
//                                     text: "(",
//                                     style: stylePTSansBold(fontSize: 10),
//                                   ),
//                                   WidgetSpan(
//                                     child: Padding(
//                                       padding: EdgeInsets.zero,
//                                       child: (data.sentiment ?? 0) >
//                                               (data.lastSentiment ?? 0)
//                                           ? Icon(
//                                               Icons.arrow_drop_up,
//                                               color: ThemeColors.accent,
//                                               size: 13.sp,
//                                             )
//                                           : Icon(
//                                               Icons.arrow_drop_down,
//                                               color: ThemeColors.sos,
//                                               size: 13.sp,
//                                             ),
//                                     ),
//                                   ),
//                                   TextSpan(
//                                     text: "${data.rank})",
//                                     style: stylePTSansBold(fontSize: 10),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SpacerHorizontal(width: 4),
//               PopUpMenuButtonCommon(
//                 symbol: data.symbol,
//                 onClickAlert: () => _alertElse(context),
//                 onClickWatchlist: () => _watchlistElse(context),
//                 watchlistString:
//                     watchlistAdded ? 'Watchlist Added' : 'Add to Watchlist',
//                 alertString: alertAdded ? 'Alert Added' : 'Add to Alert',
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showAlertPopup(BuildContext context) {
//     showPlatformBottomSheet(
//       backgroundColor: const Color.fromARGB(255, 23, 23, 23),
//       context: context,
//       showClose: false,
//       content: AlertPopup(
//         fromTopStock: true,
//         insetPadding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
//         symbol: data.symbol,
//         index: index,
//       ),
//     );

//     // Navigator.push(
//     //   context,
//     //   createRoute(
//     //     AlertPopUpDialog(
//     //       content: AlertPopup(
//     //         fromTopStock: true,
//     //         insetPadding:
//     //             EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
//     //         symbol: data.symbol,
//     //         index: index,
//     //       ),
//     //     ),
//     //   ),
//     // );

//     // showDialog(
//     //     context: context,
//     //     builder: (context) {
//     //       return AlertPopup(
//     //         fromTopStock: true,
//     //         insetPadding:
//     //             EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
//     //         symbol: data.symbol,
//     //         index: index,
//     //       );
//     //     });
//   }

//   void _addToWatchlist(BuildContext context) {
//     context.read<TopTrendingProvider>().addToWishList(
//           symbol: data.symbol,
//           index: index,
//         );
//   }

//   void _navigateToAlert(BuildContext context) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(builder: (_) => const Alerts()),
//     );
//   }

//   void _navigateToWatchlist(BuildContext context) {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(builder: (_) => const WatchList()),
//     );
//   }

//   void _alertElse(BuildContext context) {
//     if (alertAdded) {
//       _navigateToAlert(context);
//     } else {
//       _showAlertPopup(context);
//     }
//   }

//   void _watchlistElse(BuildContext context) {
//     if (watchlistAdded) {
//       _navigateToWatchlist(context);
//     } else {
//       _addToWatchlist(context);
//     }
//   }
// }
