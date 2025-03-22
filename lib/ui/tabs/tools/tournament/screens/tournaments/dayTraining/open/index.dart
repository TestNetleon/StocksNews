import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/search.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/trades.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/myTrades/all_index.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/dayTraining/open/details.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/dayTraining/open/stocks_list.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/dayTraining/widgets/tradiding_view_chart.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class TournamentOpenIndex extends StatefulWidget {
  const TournamentOpenIndex({super.key});

  @override
  State<TournamentOpenIndex> createState() => _TournamentOpenIndexState();
}

class _TournamentOpenIndexState extends State<TournamentOpenIndex>
    with SingleTickerProviderStateMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TournamentSearchProvider searchProvider =
          context.read<TournamentSearchProvider>();

      searchProvider.getSearchDefaults();
    });
  }

  _navigateToAllTrades() async {
    SSEManager.instance.disconnectAllScreens();

    await Navigator.push(
      navigatorKey.currentContext!,
      createRoute(AllTradesOrdersIndex(typeOfTrade: "open")),
    );

    TournamentTradesProvider provider =
        context.read<TournamentTradesProvider>();
    provider.setSelectedStock(
      stock: provider.selectedStock,
      clearEverything: true,
    );
  }

  _trade({StockType type = StockType.buy}) async {
    TournamentTradesProvider provider =
        context.read<TournamentTradesProvider>();
    if (provider.selectedStock == null) {
      popUpAlert(title: 'Alert', message: 'Please select a ticker');
      return;
    }

    ApiResponse res = await provider.tradeBuySell(type: type);
    if (res.status) {
      // Handle successful trade response
    }
  }

  _close() {
    TournamentTradesProvider provider =
        navigatorKey.currentContext!.read<TournamentTradesProvider>();

    provider.tradeCancle();
  }


  @override
  void dispose() {
    SSEManager.instance.disconnectAllScreens();
    Utils().showLog('OPEN DISPOSE');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TournamentSearchProvider>(
      builder: (context, searchProvider, child) {
        return BaseScaffold(
          appBar: BaseAppBar(
            showBack: true,
            title: 'Place New Trade',
            showTrade: true,
            onTradeClick: () {
              _navigateToAllTrades();
            },

          ),
          body: BaseLoaderContainer(
            hasData: searchProvider.topSearch != null &&
                searchProvider.topSearch?.isNotEmpty == true,
            isLoading: searchProvider.isLoading,
            showPreparingText: true,
            child: Theme(
              data: lightTheme.copyWith(
                tabBarTheme: TabBarTheme(
                  overlayColor: WidgetStateProperty.resolveWith<Color?>(
                    (states) {
                      return Colors.transparent;
                    },
                  ),
                  splashFactory: InkRipple.splashFactory,
                ),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              ),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OpenTopStock(),
                    ],
                  ),
                  Expanded(
                    child: Consumer<TournamentTradesProvider>(
                      builder: (context, provider, child) {
                        TournamentTickerHolder? detailHolder =
                            provider.detail[provider.selectedStock?.symbol];

                        return BaseLoaderContainer(
                          hasData: detailHolder?.data != null,
                          isLoading: detailHolder?.loading == true,
                          error: detailHolder?.error,
                          showPreparingText: true,
                          child: Column(
                            children: [
                              SpacerVertical(height:15),
                              BaseListDivider(height: 20),
                              SingleChildScrollView(
                                child: TournamentOpenDetail(
                                  data: detailHolder?.data?.ticker,
                                ),
                              ),
                              BaseListDivider(height: 20),
                              Expanded(
                                  child: TradingViewChart(
                                      symbol: detailHolder
                                              ?.data?.ticker?.symbol ??
                                          "")
                              ),
                              if (detailHolder
                                      ?.data?.showButton?.alreadyTraded ==
                                  false)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal:Pad.pad16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: BaseButton(
                                          radius: 10,
                                          text: 'Sell',
                                          onPressed: () =>
                                              _trade(type: StockType.sell),
                                          color: ThemeColors.error120,

                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Sell At',
                                                style: styleBaseBold(color: ThemeColors.white),
                                              ),
                                              SpacerHorizontal(width: 10),
                                              Visibility(
                                                visible: detailHolder
                                                        ?.data
                                                        ?.ticker
                                                        ?.price !=
                                                    null,
                                                child: Flexible(
                                                  child: Text(
                                                    "${detailHolder?.data?.ticker?.price?.toFormattedPrice()}",
                                                    style: styleBaseBold(color: ThemeColors.white),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SpacerHorizontal(width: 10),
                                      Expanded(
                                        child: BaseButton(
                                          radius: 10,
                                          text: 'Buy',
                                          onPressed: _trade,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Buy At',
                                                style: styleBaseBold(),
                                              ),
                                              SpacerHorizontal(width: 10),
                                              Visibility(
                                                visible: detailHolder
                                                        ?.data
                                                        ?.ticker
                                                        ?.price !=
                                                    null,
                                                child: Flexible(
                                                  child: Text(
                                                    "${detailHolder?.data?.ticker?.price?.toFormattedPrice()}",
                                                    style: styleBaseBold(),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (detailHolder
                                      ?.data?.showButton?.alreadyTraded ==
                                  true)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal:Pad.pad16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: BaseButton(
                                          radius: 10,
                                          text: 'Open Trades',
                                          onPressed: () {
                                            _navigateToAllTrades();
                                          },
                                         // color: ThemeColors.themeGreen,
                                        ),
                                      ),
                                      SpacerHorizontal(width: 10),
                                      Expanded(
                                        child: BaseButton(
                                          radius: 10,
                                          text: 'Close',
                                          onPressed: _close,
                                          color: ThemeColors.black,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Close',
                                                style: styleBaseBold(color: ThemeColors.white),
                                              ),
                                              SpacerHorizontal(width: 10),
                                              Flexible(
                                                child: Text(
                                                  '${detailHolder?.data?.showButton?.orderChange?.toCurrency()}%',
                                                  style: styleBaseBold(
                                                      color: (detailHolder
                                                                      ?.data
                                                                      ?.showButton
                                                                      ?.orderChange ??
                                                                  0) >
                                                              0
                                                          ? ThemeColors.success120
                                                          : detailHolder
                                                                      ?.data
                                                                      ?.showButton
                                                                      ?.orderChange ==
                                                                  0
                                                              ? ThemeColors
                                                                  .white
                                                              : ThemeColors.error120
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              SpacerVertical(height: 10),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
