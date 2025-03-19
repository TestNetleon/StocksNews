import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/market.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/search/base_search.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/ui/tabs/market/industries/industries.dart';
import 'package:stocks_news_new/ui/tabs/market/sectors/sectors.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/52Weeks/fifty_two_weeks_high.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/52Weeks/fifty_two_weeks_low.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/dividends/dividends.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/earnings/earnings.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/extra/filter.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/gainer&Losers/todays_gainers.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/gainer&Losers/todays_breakout.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/gainer&Losers/todays_losers.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/gapUpDown/gap_down.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/gapUpDown/gap_up.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/highLowBeta/high_beta.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/highLowBeta/low_beta.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/highLowBeta/negative_beta.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/highLowPe/high_pe.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/highLowPe/high_pe_growth.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/highLowPe/low_pe.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/highLowPe/low_pe_growth.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/indices/amex/amex.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/indices/dow30/dow_30.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/indices/nasdaq/nasdaq.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/indices/nyse/nyse.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/indices/s&p500/snp_500.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/lowPrice/stocks_under.dart';
import 'package:stocks_news_new/ui/tabs/market/market_tabs.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/mostActive/mostActive/most_active.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/mostActive/mostVolatile/most_volatile.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/mostActive/unusualTrading/unusual_trading.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/pennyStocks/mostActive/most_active.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/pennyStocks/mostPopular/most_popular.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/pennyStocks/topTodays/top_todays.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/trending/most_bearish.dart';
import 'package:stocks_news_new/ui/tabs/market/stocks/trending/most_bullish.dart';
import 'package:stocks_news_new/ui/tabs/more/news/detail.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class MarketIndex extends StatefulWidget {
  const MarketIndex({
    super.key,
    this.screenIndex,
    this.marketIndex,
    this.marketInnerIndex,
  });

  final int? screenIndex;
  final int? marketIndex;
  final int? marketInnerIndex;

  @override
  State<MarketIndex> createState() => _MarketIndexState();
}

class _MarketIndexState extends State<MarketIndex> {
  int _screenIndex = 0;
  int _marketIndex = 0;
  int _marketInnerIndex = 0;

  @override
  void initState() {
    super.initState();

    Utils().showLog("INDEX ==> ${widget.marketIndex}");

    if (widget.marketIndex != null) {
      _marketIndex = widget.marketIndex ?? 0;
    } else if (widget.screenIndex != null) {
      _screenIndex = widget.screenIndex ?? 0;
    }

    if (widget.marketInnerIndex != null) {
      _marketInnerIndex = widget.marketInnerIndex ?? 0;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    MarketManager manager = context.read<MarketManager>();
    manager.getData();
  }

  Widget _showSelectedScreen() {
    if (_screenIndex == 1) {
      return Sectors();
    } else if (_screenIndex == 2) {
      return Industries();
    } else if (_marketIndex == 0 && _marketInnerIndex == 0) {
      return MostBullish();
    } else if (_marketIndex == 0 && _marketInnerIndex == 1) {
      return MostBearish();
    } else if (_marketIndex == 1 && _marketInnerIndex == 0) {
      return TodaysGainer();
    } else if (_marketIndex == 1 && _marketInnerIndex == 1) {
      return TodaysLosers();
    } else if (_marketIndex == 1 && _marketInnerIndex == 2) {
      return TodaysBreakoutStocks();
    } else if (_marketIndex == 2 && _marketInnerIndex == 0) {
      return GapUp();
    } else if (_marketIndex == 2 && _marketInnerIndex == 1) {
      return GapDown();
    } else if (_marketIndex == 3 && _marketInnerIndex == 0) {
      return HighPE();
    } else if (_marketIndex == 3 && _marketInnerIndex == 1) {
      return LowPe();
    } else if (_marketIndex == 3 && _marketInnerIndex == 2) {
      return HighPeGrowth();
    } else if (_marketIndex == 3 && _marketInnerIndex == 3) {
      return LowPeGrowth();
    } else if (_marketIndex == 4 && _marketInnerIndex == 0) {
      return FiftyTwoWeeksHigh();
    } else if (_marketIndex == 4 && _marketInnerIndex == 1) {
      return FiftyTwoWeeksLow();
    } else if (_marketIndex == 5 && _marketInnerIndex == 0) {
      return HighBeta();
    } else if (_marketIndex == 5 && _marketInnerIndex == 1) {
      return LowBeta();
    } else if (_marketIndex == 5 && _marketInnerIndex == 2) {
      return NegativeBeta();
    } else if (_marketIndex == 6 && _marketInnerIndex == 0) {
      return Dow30();
    } else if (_marketIndex == 6 && _marketInnerIndex == 1) {
      return Snp500();
    } else if (_marketIndex == 6 && _marketInnerIndex == 2) {
      return Nyse();
    } else if (_marketIndex == 6 && _marketInnerIndex == 3) {
      return Amex();
    } else if (_marketIndex == 6 && _marketInnerIndex == 4) {
      return Nasdaq();
    } else if (_marketIndex == 7) {
      MarketManager provider = context.read<MarketManager>();
      return StocksUnder(
        key: ValueKey(provider.data?.data?[0].data?[_marketIndex]
                .data?[_marketInnerIndex].value ??
            ""),
        slug: provider.data?.data?[0].data?[_marketIndex]
                .data?[_marketInnerIndex].value ??
            "",
      );
    } else if (_marketIndex == 8 && _marketInnerIndex == 0) {
      return MostActive();
    } else if (_marketIndex == 8 && _marketInnerIndex == 1) {
      return MostVolatile();
    } else if (_marketIndex == 8 && _marketInnerIndex == 2) {
      return UnusualTrading();
    } else if (_marketIndex == 9 && _marketInnerIndex == 0) {
      return MostActivePennyStocks();
    } else if (_marketIndex == 9 && _marketInnerIndex == 1) {
      return MostPopularPennyStocks();
    } else if (_marketIndex == 9 && _marketInnerIndex == 2) {
      return TopTodaysPennyStocks();
    } else if (_marketIndex == 10) {
      return Dividends();
    } else if (_marketIndex == 11) {
      return Earnings();
    }
    return Container();
  }

  void _openFiler() {
    Navigator.push(
      context,
      createRoute(MarketFilter(
        marketIndex: _marketIndex,
        marketInnerIndex: _marketInnerIndex,
      )),
    );
  }

  void _changeScreenIndex(int index) {
    MarketManager manager = context.read<MarketManager>();
    manager.resetFilter(
      marketIndex: _marketIndex,
      marketInnerIndex: _marketInnerIndex,
    );
    if (index != 0) {
      _marketIndex = 0;
      _marketInnerIndex = 0;
    }

    setState(() {
      _screenIndex = index;
    });
  }

  void _changeMarketIndex(int index) {
    MarketManager manager = context.read<MarketManager>();
    manager.resetFilter(
      marketIndex: _marketIndex,
      marketInnerIndex: _marketInnerIndex,
    );
    setState(() {
      _marketIndex = index;
      _marketInnerIndex = 0;
    });
  }

  void _changeMarketInnerIndex(int index) {
    MarketManager manager = context.read<MarketManager>();

    setState(() {
      _marketInnerIndex = index;
    });

    manager.resetFilter(
      marketIndex: _marketIndex,
      marketInnerIndex: _marketInnerIndex,
      apiCallNeeded: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    MarketManager provider = context.watch<MarketManager>();
    return BaseScaffold(
      body: BaseLoaderContainer(
        isLoading: provider.isLoading,
        hasData: provider.data != null && !provider.isLoading,
        showPreparingText: true,
        error: provider.error,
        onRefresh: () async {},
        child: provider.data == null
            ? const SizedBox()
            : Column(
                children: [
                  BaseTabs(
                    data: provider.data!.data!,
                    // textStyle: styleBaseBold(fontSize: 16),
                    onTap: _changeScreenIndex,
                    rightChild: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          createRoute(
                            BaseSearch(
                              callRecent: false,
                              stockClick: (stock) {
                                if (stock.symbol == null ||
                                    stock.symbol == '') {
                                  return;
                                }
                                // Navigator.pop(context);
                                // manager.addToCompare(stock.symbol ?? '');
                              },
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Consumer<ThemeManager>(
                          builder: (context, value, child) {
                            return ActionButton(
                              icon: Images.search,
                              color:
                                  value.isDarkMode ? ThemeColors.white : null,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  createRoute(
                                    BaseSearch(
                                      stockClick: (p0) {
                                        if (p0.symbol == null ||
                                            p0.symbol == '') {
                                          return;
                                        }
                                        Navigator.pushNamed(
                                          context,
                                          SDIndex.path,
                                          arguments: {
                                            'symbol': p0.symbol,
                                          },
                                        );
                                      },
                                      newsClick: (data) {
                                        if (data.slug == null ||
                                            data.slug == '') {
                                          return;
                                        }
                                        Navigator.pushNamed(
                                          context,
                                          NewsDetailIndex.path,
                                          arguments: {
                                            'slug': data.slug,
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (_screenIndex == 0)
                    MarketTabs(
                      key: ValueKey(provider.data!.data![_screenIndex].slug),
                      data: provider.data!.data![_screenIndex].data!,
                      onTap: _changeMarketIndex,
                      selectedIndex: _marketIndex,
                    ),
                  if (_screenIndex == 0 &&
                      provider.data!.data![0].data![_marketIndex].data != null)
                    BaseTabs(
                      key: ValueKey(
                        "$_screenIndex+$_marketIndex+$_marketInnerIndex",
                      ),
                      selectedIndex: _marketInnerIndex,
                      data: provider.data!.data![0].data![_marketIndex].data!,
                      onTap: _changeMarketInnerIndex,
                      fontSize: 14,
                      unselectedBold: false,
                      leftChild: (provider.data!.data![0].data![_marketIndex]
                                  .applyFilter ??
                              false)
                          ? Container(
                              margin: const EdgeInsets.only(left: 16),
                              child: InkWell(
                                onTap: _openFiler,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 8.0,
                                  ),
                                  child: Image.asset(
                                    Images.marketFilter,
                                    width: 24,
                                    height: 24,
                                    color: provider.filterParams != null
                                        ? ThemeColors.success
                                        : null,
                                  ),
                                ),
                              ),
                            )
                          : null,
                    ),
                  Expanded(child: _showSelectedScreen()),
                ],
              ),
      ),
    );
  }
}
