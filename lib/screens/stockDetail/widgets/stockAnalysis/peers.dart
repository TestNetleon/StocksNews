import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/analysis_res.dart';
import 'package:stocks_news_new/modals/top_trending_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/slidable_menu.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/common_item_ui.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdStockPeers extends StatelessWidget {
  const SdStockPeers({super.key});

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    if (provider.analysis?.peersData?.isEmpty == true ||
        provider.analysis?.peersData == null) {
      return const SizedBox();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ScreenTitle(
          title: "Stock Peers",
        ),
        SlidableAutoCloseBehavior(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              List<PeersDatum>? data = provider.analysis?.peersData;
              if (data == null || data.isEmpty) {
                return const SizedBox();
              }
              return SlidableMenuWidget(
                index: index,
                alertForBullish: data[index].isAlertAdded?.toInt() ?? 0,
                watlistForBullish: data[index].isWatchlistAdded?.toInt() ?? 0,
                onClickAlert: () => _onAlertClick(context, data[index].symbol,
                    data[index].isAlertAdded, index),
                onClickWatchlist: () => _onWatchListClick(context,
                    data[index].symbol, data[index].isWatchlistAdded, index),
                child: CommonItemUi(
                  data: TopTrendingDataRes(
                      image: data[index].image,
                      symbol: data[index].symbol,
                      isAlertAdded: data[index].isAlertAdded ?? 0,
                      isWatchlistAdded: data[index].isWatchlistAdded ?? 0,
                      name: data[index].name,
                      change: data[index].change,
                      changePercentage: data[index].changesPercentage,
                      price: data[index].price),
                ),
                // child: SdPeerItem(
                //   data: data[index],
                //   index: index,
                // ),
              );
              // return SdPeerItem(
              //   data: data?[index],
              //   index: index,
              // );
            },
            separatorBuilder: (context, index) {
              return const Divider(
                color: ThemeColors.greyBorder,
                height: 15,
              );
            },
            itemCount: provider.analysis?.peersData?.length ?? 0,
          ),
        ),
        const SpacerVertical(height: 20),
      ],
    );
  }

  void _onAlertClick(BuildContext context, String symbol, num? isAlertAdded,
      int? index) async {
    if ((isAlertAdded?.toInt() ?? 0) == 1) {
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
            symbol: symbol,
            index: index ?? 0,
            stocksAnalysisPeers: true,
          ),
        );

        return;
      }
      try {
        ApiResponse res =
            await context.read<StockDetailProviderNew>().getAnalysisData();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<StockDetailProviderNew>()
                  .analysis
                  ?.peersData?[index ?? 0]
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
                symbol: symbol,
                index: index ?? 0,
                stocksAnalysisPeers: true,
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

  void _onWatchListClick(BuildContext context, String symbol,
      num? isWatchlistAdded, int index) async {
    if (isWatchlistAdded == 1) {
      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const WatchList()),
      );
    } else {
      if (context.read<UserProvider>().user != null) {
        await navigatorKey.currentContext!
            .read<StockDetailProviderNew>()
            .addToWishListPeer(
              symbol: symbol,
              index: index,
              up: true,
            );
        return;
      }
      try {
        ApiResponse res = await navigatorKey.currentContext!
            .read<StockDetailProviderNew>()
            .getAnalysisData();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<StockDetailProviderNew>()
                  .analysis
                  ?.peersData?[index]
                  .isWatchlistAdded ??
              0;
          if (alertOn == 0) {
            await navigatorKey.currentContext!
                .read<StockDetailProviderNew>()
                .addToWishListPeer(
                  symbol: symbol,
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
      } catch (e) {}
    }
  }
}
