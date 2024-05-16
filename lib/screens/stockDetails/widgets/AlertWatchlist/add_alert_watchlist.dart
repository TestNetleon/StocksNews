// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import 'alert_popup.dart';
import 'button.dart';

//
class AddToAlertWatchlist extends StatelessWidget {
  const AddToAlertWatchlist({super.key});

  @override
  Widget build(BuildContext context) {
    String? symbol =
        context.watch<StockDetailProvider>().data?.keyStats?.symbol ?? "";
    num alertOn = context.watch<StockDetailProvider>().data?.isAlertAdded ?? 0;
    num watchlistOn =
        context.watch<StockDetailProvider>().data?.isWatchlistAdded ?? 0;
    UserProvider userProvider = context.watch<UserProvider>();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.sp),
      child: Row(
        children: [
          AlertWatchlistButton(
            backgroundColor:
                alertOn == 0 ? ThemeColors.accent : ThemeColors.background,
            iconData: Icons.add_alert_outlined,
            name: alertOn == 0 ? "Add to Alerts" : "Alert Added",
            onTap: userProvider.user == null
                ? () async {
                    // await Navigator.push(
                    //   context,
                    //   createRoute(const Login()),
                    // );

                    await loginSheet();

                    if (context.read<UserProvider>().user == null) {
                      return;
                    }
                    await context
                        .read<StockDetailProvider>()
                        .getStockDetails(symbol: symbol, loadOther: false);
                    num alrtOn = context
                            .read<StockDetailProvider>()
                            .data
                            ?.isAlertAdded ??
                        0;
                    if (alrtOn == 0) {
                      await Future.delayed(const Duration(milliseconds: 200));
                      _showAlertPopup(navigatorKey.currentContext!, symbol);
                    } else {
                      Navigator.pushNamed(context, Alerts.path);
                    }
                  }
                : alertOn == 0
                    ? () {
                        _showAlertPopup(navigatorKey.currentContext!, symbol);
                      }
                    : () {
                        Navigator.pushNamed(context, Alerts.path);
                      },
          ),
          const SpacerHorizontal(width: 10),
          AlertWatchlistButton(
            backgroundColor:
                watchlistOn == 0 ? ThemeColors.accent : ThemeColors.background,
            iconData: Icons.star_border,
            name: watchlistOn == 0 ? "Add to Watchlist" : "Watchlist Added",
            onTap: userProvider.user == null
                ? () async {
                    // await Navigator.push(
                    //   context,
                    //   createRoute(const Login()),
                    // );

                    await loginSheet();
                    if (context.read<UserProvider>().user == null) {
                      return;
                    }
                    await context
                        .read<StockDetailProvider>()
                        .getStockDetails(symbol: symbol, loadOther: false);

                    num wlistOn = context
                            .read<StockDetailProvider>()
                            .data
                            ?.isWatchlistAdded ??
                        0;
                    if (wlistOn == 0) {
                      context.read<StockDetailProvider>().addToWishList();
                    } else {
                      Navigator.pushNamed(context, WatchList.path);
                    }
                  }
                : watchlistOn == 0
                    ? () {
                        context.read<StockDetailProvider>().addToWishList();
                      }
                    : () {
                        Navigator.pushNamed(context, WatchList.path);
                      },
          ),
        ],
      ),
    );
  }

  void _showAlertPopup(BuildContext context, String symbol) {
    // Navigator.push(
    //   context,
    //   createRoute(
    // AlertPopUpDialog(
    //   content: AlertPopup(
    //     fromStockDetail: true,
    //     symbol: symbol,
    //   ),
    // ),
    //   ),
    // );

    showPlatformBottomSheet(
      context: context,
      showClose: false,
      content: AlertPopup(
        fromStockDetail: true,
        symbol: symbol,
      ),
    );

    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertPopup(
    //         fromStockDetail: true,
    //         symbol: symbol,
    //       );
    //     });
  }
}
