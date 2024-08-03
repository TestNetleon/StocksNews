import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/modals/stockDetailRes/competitor.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/alerts/alerts.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/common_heading.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/competitors/compatitor_item.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/AlertWatchlist/alert_popup.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/slidable_menu.dart';
import 'package:stocks_news_new/screens/watchlist/watchlist.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SdCompetitor extends StatefulWidget {
  final String symbol;
  const SdCompetitor({super.key, required this.symbol});

  @override
  State<SdCompetitor> createState() => _SdCompetitorState();
}

class _SdCompetitorState extends State<SdCompetitor> {
  int openIndex = -1;
  void changeOpenIndex(int index) {
    setState(() {
      openIndex = openIndex == index ? -1 : index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
      if (provider.competitorRes == null) {
        _callApi();
      }
    });
  }

  _callApi() {
    context
        .read<StockDetailProviderNew>()
        .getCompetitorData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    List<TickerList>? data = provider.competitorRes?.tickerList;
    return BaseUiContainer(
      isFull: true,
      hasData: !provider.isLoadingCompetitor && provider.competitorRes != null,
      isLoading: provider.isLoadingCompetitor,
      showPreparingText: true,
      error: provider.errorCompetitor,
      onRefresh: _callApi,
      child: SlidableAutoCloseBehavior(
        child: CommonRefreshIndicator(
          onRefresh: () async {
            _callApi();
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(
                        Dimen.padding, Dimen.padding, Dimen.padding, 0),
                    child: const SdCommonHeading(showRating: true)),
                Padding(
                  padding: const EdgeInsets.only(
                    // bottom: Dimen.padding,
                    left: Dimen.padding,
                    right: Dimen.padding,
                  ),
                  child: const Divider(
                    color: ThemeColors.white,
                    thickness: 2,
                    height: 20,
                  ),
                ),

                // ScreenTitle(
                //   title: "${provider.tabRes?.keyStats?.name} Earnings - FAQs",
                // ),
                ListView.separated(
                  padding: const EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return SlidableMenuWidget(
                      index: index,
                      alertForBullish: data?[index].isAlertAdded?.toInt() ?? 0,
                      watlistForBullish:
                          data?[index].isWatchlistAdded?.toInt() ?? 0,
                      onClickAlert: () => _onAlertClick(
                          context,
                          data?[index].symbol,
                          data?[index].isAlertAdded,
                          index),
                      onClickWatchlist: () => _onWatchListClick(
                          context,
                          data?[index].symbol,
                          data?[index].isWatchlistAdded,
                          index),
                      child: SdCompetitorItem(
                        data: data?[index],
                        isOpen: openIndex == index,
                        onTap: () => changeOpenIndex(index),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SpacerVertical(height: 12);
                  },
                  itemCount: provider.competitorRes?.tickerList.length ?? 0,
                ),
                const SpacerVertical(height: 10),
                if (provider.extraCompetitor?.disclaimer != null)
                  DisclaimerWidget(data: provider.extraCompetitor!.disclaimer!),
                const SpacerVertical(height: 20),
              ],
            ),
          ),
        ),
      ),
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
            competitorsDetail: true,
          ),
        );

        return;
      }
      try {
        ApiResponse res =
            await context.read<StockDetailProviderNew>().getCompetitorData();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<StockDetailProviderNew>()
                  .competitorRes
                  ?.tickerList[index ?? 0]
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
                competitorsDetail: true,
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
              type: "compititor",
              symbol: symbol,
              index: index,
              up: true,
            );
        return;
      }
      try {
        ApiResponse res = await navigatorKey.currentContext!
            .read<StockDetailProviderNew>()
            .getCompetitorData();
        if (res.status) {
          num alertOn = navigatorKey.currentContext!
                  .read<StockDetailProviderNew>()
                  .competitorRes
                  ?.tickerList[index]
                  .isWatchlistAdded ??
              0;
          if (alertOn == 0) {
            await navigatorKey.currentContext!
                .read<StockDetailProviderNew>()
                .addToWishListPeer(
                  type: "compititor",
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
