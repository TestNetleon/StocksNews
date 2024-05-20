import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/trending_res.dart';
import 'package:stocks_news_new/providers/trending_provider.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/popup_menu.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

//
class MostBullishItem extends StatelessWidget {
  final bool up;
  final MostBullishData data;
  final int index;
  final int alertForBullish;
  final int alertForBearish;
  final int watlistForBullish;
  final int watlistForBearish;
  const MostBullishItem({
    required this.data,
    this.up = true,
    super.key,
    required this.index,
    this.alertForBullish = 0,
    this.alertForBearish = 0,
    this.watlistForBullish = 0,
    this.watlistForBearish = 0,
  });

  @override
  Widget build(BuildContext context) {
    // UserProvider provider = context.watch<UserProvider>();
    return LayoutBuilder(builder: (BuildContext ctx, BoxConstraints ctrt) {
      return InkWell(
        onTap: () {
          Navigator.pushNamed(context, StockDetails.path,
              arguments: data.symbol);
        },
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StockDetails(symbol: data.symbol),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.sp),
                child: Container(
                  padding: EdgeInsets.all(5.sp),
                  width: 43.sp,
                  height: 43.sp,
                  child: ThemeImageView(url: data.image ?? ""),
                ),
              ),
            ),

            const SpacerHorizontal(width: 10),
            SizedBox(
              width: ctrt.maxWidth * .16,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StockDetails(symbol: data.symbol),
                    ),
                  );
                },
                child: Text(
                  data.symbol,
                  style: stylePTSansBold(fontSize: 14),
                ),
              ),
            ),
            // InkWell(
            //     onTap: provider.user == null
            //         ? () {
            //             // if (provider.user == null) {
            //             //   showConfirmAlertDialog(
            //             //       context: context,
            //             //       message: "Please login to continue",
            //             //       okText: "Login",
            //             //       title: "",
            //             //       onclick: () =>
            //             //           Navigator.pushNamed(context, Login.path));
            //             // } else {

            // // }
            //             showConfirmAlertDialog(
            //                 context: context,
            //                 message: "Please login to continue",
            //                 okText: "Login",
            //                 title: "",
            //                 onclick: () =>
            //                     Navigator.pushNamed(context, Login.path));
            //           }
            //         : up
            //             ? alertForBullish == 1
            //                 ? null
            //                 : () => _showAlertPopup(context)
            //             : alertForBearish == 1
            //                 ? null
            //                 : () => _showAlertPopup(context),
            //     child: Padding(
            //       padding: EdgeInsets.all(5.sp),
            //       child: Icon(
            //         Icons.add_alert,
            //         color: up
            //             ? alertForBullish == 1
            //                 ? ThemeColors.greyBorder
            //                 : ThemeColors.border
            //             : alertForBearish == 1
            //                 ? ThemeColors.greyBorder
            //                 : ThemeColors.border,
            //       ),
            //     )),

            // Text(
            //   up ? "Very\nBullish" : "Very\nBearish",
            //   style: stylePTSansRegular(
            //     fontSize: 12,
            //     color: up ? ThemeColors.accent : Colors.red,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            const SpacerHorizontal(width: 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          // "\$201.99",
                          data.price ?? "",
                          style: stylePTSansBold(fontSize: 13),
                          maxLines: 1,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SpacerHorizontal(width: 4),
                      Expanded(
                        child: Text(
                          // "\$201.99",
                          textAlign: TextAlign.end,

                          "${data.mention}",
                          style: stylePTSansBold(fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // child: Text(
                        //   "${data.changes.toCurrency()}%",
                        //   style: stylePTSansRegular(
                        //     color: data.changes == 0
                        //         ? Colors.white
                        //         : data.changes > 0
                        //             ? ThemeColors.accent
                        //             : Colors.red,
                        //     fontSize: 11,
                        //   ),
                        //   maxLines: 1,
                        //   textAlign: TextAlign.end,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        // child: Text(
                        //   // "\$201.99",
                        //   textAlign: TextAlign.end,

                        //   "${data.mention}",
                        //   style: stylePTSansBold(fontSize: 11),
                        //   maxLines: 1,
                        //   overflow: TextOverflow.ellipsis,
                        // ),

                        child: Text(
                          "${data.changes.toCurrency()}%",
                          style: stylePTSansRegular(
                            color: data.changes == 0
                                ? Colors.white
                                : data.changes > 0
                                    ? ThemeColors.accent
                                    : Colors.red,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SpacerHorizontal(width: 4),
                      Expanded(
                        child: Text(
                          "${data.mentionChange.toCurrency()}%",
                          style: stylePTSansRegular(
                            color: data.mentionChange == 0
                                ? Colors.white
                                : data.mentionChange > 0
                                    ? ThemeColors.accent
                                    : Colors.red,
                            fontSize: 11,
                          ),
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // const SpacerHorizontal(width: 10),
            // Text(
            //   "${data.mention}",
            //   style: stylePTSansRegular(
            //     fontSize: 13,
            //   ),
            // ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Text(
            //       "+0.00%",
            //       style: stylePTSansRegular(
            //         fontSize: 12,
            //         color: ThemeColors.accent,
            //       ),
            //     ),
            //     const SpacerVertical(height: 5),
            //     Text(
            //       "-0.00%",
            //       style: stylePTSansRegular(
            //         fontSize: 12,
            //         color: Colors.red,
            //       ),
            //     ),
            //   ],
            // )
            PopUpMenuButtonCommon(
              symbol: data.symbol,
              onClickAlert: () => _alertElse(context),
              onClickWatchlist: () => _watchlistElse(context),
              watchlistString: up
                  ? watlistForBullish == 1
                      ? 'Watchlist Added'
                      : 'Add to Watchlist'
                  : watlistForBearish == 1
                      ? 'Watchlist Added'
                      : 'Add to Watchlist',
              alertString: up
                  ? alertForBullish == 1
                      ? 'Alert Added'
                      : 'Add to Alert'
                  : alertForBearish == 1
                      ? 'Alert Added'
                      : 'Add to Alert',
            ),
          ],
        ),
      );
    });
  }

  void _showAlertPopup(BuildContext context) {
    showPlatformBottomSheet(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
      context: context,
      showClose: false,
      content: AlertPopup(
        insetPadding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
        symbol: data.symbol,
        up: up,
        index: index,
        fromTrending: true,
      ),
    );

    // Navigator.push(
    //   context,
    //   createRoute(
    //     AlertPopUpDialog(
    //       content: AlertPopup(
    //         insetPadding:
    //             EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
    //         symbol: data.symbol,
    //         up: up,
    //         index: index,
    //         fromTrending: true,
    //       ),
    //     ),
    //   ),
    // );
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertPopup(
    //         insetPadding:
    //             EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
    //         symbol: data.symbol,
    //         up: up,
    //         index: index,
    //         fromTrending: true,
    //       );
    //     });
  }

  void _addToWatchlist(BuildContext context) {
    context.read<TrendingProvider>().addToWishList(
          symbol: data.symbol,
          index: index,
          up: up,
        );
  }

  void _navigateToAlert(BuildContext context) {
    Navigator.pushNamed(context, Alerts.path);
  }

  void _navigateToWatchlist(BuildContext context) {
    Navigator.pushNamed(context, WatchList.path);
  }

  void _alertElse(BuildContext context) {
    if (up) {
      if (alertForBullish == 1) {
        _navigateToAlert(context);
      } else {
        _showAlertPopup(context);
      }
    } else {
      if (alertForBearish == 1) {
        _navigateToAlert(context);
      } else {
        _showAlertPopup(context);
      }
    }
  }

  void _watchlistElse(BuildContext context) {
    if (up) {
      if (watlistForBullish == 1) {
        _navigateToWatchlist(context);
      } else {
        _addToWatchlist(context);
      }
    } else {
      if (watlistForBearish == 1) {
        _navigateToWatchlist(context);
      } else {
        _addToWatchlist(context);
      }
    }
  }
}
