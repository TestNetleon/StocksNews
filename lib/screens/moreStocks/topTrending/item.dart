import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/top_trending_res.dart';
import 'package:stocks_news_new/providers/top_trending_provider.dart';
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
class TopTrendingItem extends StatelessWidget {
  final int index;
  final TopTrendingDataRes data;
  final bool alertAdded;
  final bool watchlistAdded;

  const TopTrendingItem({
    super.key,
    required this.data,
    required this.index,
    this.alertAdded = false,
    this.watchlistAdded = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              border: Border.all(color: ThemeColors.greyBorder),
              color: ThemeColors.primaryLight),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    StockDetails.path,
                    arguments: data.symbol,
                  );
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25.sp),
                      child: Container(
                        padding: EdgeInsets.all(5.sp),
                        width: 43.sp,
                        height: 43.sp,
                        child: ThemeImageView(url: data.image ?? ""),
                      ),
                    ),
                    const SpacerHorizontal(width: 4),
                    SizedBox(
                      width: constraints.maxWidth * .25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.symbol,
                            style: stylePTSansBold(fontSize: 10),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            data.name.capitalizeWords(),
                            style: stylePTSansBold(
                              color: ThemeColors.greyText,
                              fontSize: 10,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SpacerHorizontal(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            data.price ?? "",
                            style: stylePTSansBold(fontSize: 10),
                            maxLines: 2,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SpacerHorizontal(width: 4),
                        Expanded(
                          // child: Text(
                          //   "${data.change?.toCurrency()} (${data.changePercentage?.toCurrency()}%)",
                          //   style: stylePTSansBold(
                          //     color: data.change == 0
                          //         ? ThemeColors.white
                          //         : (data.change ?? 0) > 0
                          //             ? ThemeColors.accent
                          //             : ThemeColors.sos,
                          //     fontSize: 10,
                          //   ),
                          //   maxLines: 2,
                          //   textAlign: TextAlign.end,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          child: Text(
                            // "\$201.99",
                            textAlign: TextAlign.end,

                            "${data.sentiment}",
                            style: stylePTSansBold(fontSize: 10),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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

                          //   "${data.sentiment}",
                          //   style: stylePTSansBold(fontSize: 10),
                          //   maxLines: 1,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          child: Text(
                            "${data.change?.toCurrency()} (${data.changePercentage?.toCurrency()}%)",
                            style: stylePTSansBold(
                              color: data.change == 0
                                  ? ThemeColors.white
                                  : (data.change ?? 0) > 0
                                      ? ThemeColors.accent
                                      : ThemeColors.sos,
                              fontSize: 10,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SpacerHorizontal(width: 4),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "(",
                                    style: stylePTSansBold(fontSize: 10),
                                  ),
                                  WidgetSpan(
                                    child: Padding(
                                      padding: EdgeInsets.zero,
                                      child: (data.sentiment ?? 0) >
                                              (data.lastSentiment ?? 0)
                                          ? Icon(
                                              Icons.arrow_drop_up,
                                              color: ThemeColors.accent,
                                              size: 13.sp,
                                            )
                                          : Icon(
                                              Icons.arrow_drop_down,
                                              color: ThemeColors.sos,
                                              size: 13.sp,
                                            ),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${data.rank})",
                                    style: stylePTSansBold(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SpacerHorizontal(width: 4),
              PopUpMenuButtonCommon(
                symbol: data.symbol,
                onClickAlert: () => _alertElse(context),
                onClickWatchlist: () => _watchlistElse(context),
                watchlistString:
                    watchlistAdded ? 'Watchlist Added' : 'Add to Watchlist',
                alertString: alertAdded ? 'Alert Added' : 'Add to Alert',
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAlertPopup(BuildContext context) {
    showPlatformBottomSheet(
      context: context,
      showClose: false,
      content: AlertPopup(
        fromTopStock: true,
        insetPadding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
        symbol: data.symbol,
        index: index,
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
          symbol: data.symbol,
          index: index,
        );
  }

  void _navigateToAlert(BuildContext context) {
    Navigator.pushNamed(context, Alerts.path);
  }

  void _navigateToWatchlist(BuildContext context) {
    Navigator.pushNamed(context, WatchList.path);
  }

  void _alertElse(BuildContext context) {
    if (alertAdded) {
      _navigateToAlert(context);
    } else {
      _showAlertPopup(context);
    }
  }

  void _watchlistElse(BuildContext context) {
    if (watchlistAdded) {
      _navigateToWatchlist(context);
    } else {
      _addToWatchlist(context);
    }
  }
}
