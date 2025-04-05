import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/api/api_response.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/search.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/trades.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/myTrades/all_index.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/dayTraining/open/details.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/dayTraining/open/stocks_list.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/dayTraining/widgets/tradiding_view_chart.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/searchTicker/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class LeagueTickersIndex extends StatefulWidget {
  static const path = 'LeagueTickersIndex';
  const LeagueTickersIndex({super.key});

  @override
  State<LeagueTickersIndex> createState() => _LeagueTickersIndexState();
}

class _LeagueTickersIndexState extends State<LeagueTickersIndex> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LeagueSearchManager searchManager = context.read<LeagueSearchManager>();
      searchManager.getTickersList();
    });
  }

  _navigateToAllTrades() async {
    SSEManager.instance.disconnectAllScreens();
    // await Navigator.pushNamed(navigatorKey.currentContext!,
    //     AllTradesIndex.path,
    //     arguments: {
    //       "typeOfTrade":  "open",
    //     });

    await Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
            builder: (context) => AllTradesIndex(
                  typeOfTrade: 'open',
                )));

    TradesManger manger = context.read<TradesManger>();
    manger.setSelectedStock(
      stock: manger.selectedStock,
      clearEverything: true,
    );
  }

  _trade({StockType type = StockType.buy}) async {
    TradesManger manger = context.read<TradesManger>();
    if (manger.selectedStock == null) {
      popUpAlert(title: 'Alert', message: 'Please select a ticker');
      return;
    }
    ApiResponse res = await manger.tradeBuySell(type: type);
    if (res.status) {}
  }

  _close() {
    TradesManger manger = context.read<TradesManger>();
    manger.tradeCancel();
  }

  @override
  void dispose() {
    SSEManager.instance.disconnectAllScreens();
    Utils().showLog('OPEN DISPOSE');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LeagueSearchManager, ThemeManager>(
      builder: (context, searchManager, tm, child) {
        return BaseScaffold(
          appBar: BaseAppBar(
            showBack: true,
            title: 'Place New Trade',
            showTrade: true,
            searchLeague: true,
            onLSearchClick: () {
              Navigator.push(
                context,
                createRoute(TickerSearch()),
              );
            },
            onTradeClick: () {
              _navigateToAllTrades();
            },
          ),
          body: BaseLoaderContainer(
              hasData: searchManager.tickersData?.symbols?.data != null &&
                  searchManager.tickersData?.symbols?.data?.isNotEmpty == true,
              isLoading: searchManager.isLoading,
              showPreparingText: true,
              child: Column(
                children: [
                  SpacerVertical(),
                  OpenTopStock(),
                  Expanded(
                    child: Consumer<TradesManger>(
                      builder: (context, manager, child) {
                        TournamentTickerHolder? detailHolder =
                            manager.detail[manager.selectedStock?.symbol];

                        return BaseLoaderContainer(
                          hasData: detailHolder?.data != null,
                          isLoading: detailHolder?.loading == true,
                          error: detailHolder?.error,
                          showPreparingText: true,
                          child: Column(
                            children: [
                              SpacerVertical(height: 15),
                              BaseListDivider(height: 20),
                              SingleChildScrollView(
                                child: TournamentOpenDetail(
                                  data: detailHolder?.data?.ticker,
                                ),
                              ),
                              BaseListDivider(height: 20),
                              Expanded(
                                  child: TradingViewChart(
                                      symbol:
                                          detailHolder?.data?.ticker?.symbol ??
                                              "")),
                              if (detailHolder
                                      ?.data?.showButton?.alreadyTraded ==
                                  false)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Pad.pad16),
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
                                                style: styleBaseBold(
                                                    color: ThemeColors.white),
                                              ),
                                              SpacerHorizontal(width: 10),
                                              Visibility(
                                                visible: detailHolder
                                                        ?.data?.ticker?.price !=
                                                    null,
                                                child: Flexible(
                                                  child: Text(
                                                    "${detailHolder?.data?.ticker?.price?.toFormattedPrice()}",
                                                    style: styleBaseBold(
                                                        color:
                                                            ThemeColors.white),
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
                                                        ?.data?.ticker?.price !=
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Pad.pad16),
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
                                                style: styleBaseBold(
                                                    color: ThemeColors.white),
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
                                                          ? ThemeColors.accent
                                                          : detailHolder
                                                                      ?.data
                                                                      ?.showButton
                                                                      ?.orderChange ==
                                                                  0
                                                              ? ThemeColors
                                                                  .white
                                                              : ThemeColors
                                                                  .sos),
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
              )),
        );
      },
    );
  }
}
