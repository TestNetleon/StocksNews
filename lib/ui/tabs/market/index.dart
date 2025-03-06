import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/market.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/tabs/market/extra/filter.dart';
import 'package:stocks_news_new/ui/tabs/market/gainer&Losers/todays_gainers.dart';
import 'package:stocks_news_new/ui/tabs/market/gainer&Losers/todays_breakout.dart';
import 'package:stocks_news_new/ui/tabs/market/gainer&Losers/todays_losers.dart';
import 'package:stocks_news_new/ui/tabs/market/gapUpDown/gap_down.dart';
import 'package:stocks_news_new/ui/tabs/market/gapUpDown/gap_up.dart';
import 'package:stocks_news_new/ui/tabs/market/highLowPe/high_pe.dart';
import 'package:stocks_news_new/ui/tabs/market/highLowPe/high_pe_growth.dart';
import 'package:stocks_news_new/ui/tabs/market/highLowPe/low_pe.dart';
import 'package:stocks_news_new/ui/tabs/market/highLowPe/low_pe_growth.dart';
import 'package:stocks_news_new/ui/tabs/market/market_tabs.dart';
import 'package:stocks_news_new/ui/tabs/market/trending/most_bearish.dart';
import 'package:stocks_news_new/ui/tabs/market/trending/most_bullish.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class MarketIndex extends StatefulWidget {
  const MarketIndex({super.key});

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
      // Sector
      return Container();
    } else if (_screenIndex == 2) {
      // industries
      return Container();
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
    manager.resetFilter(
      marketIndex: _marketIndex,
      marketInnerIndex: _marketInnerIndex,
    );
    setState(() {
      _marketInnerIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    MarketManager provider = context.watch<MarketManager>();
    return BaseContainer(
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
                    textStyle: styleBaseBold(fontSize: 16),
                    onTap: _changeScreenIndex,
                    rightChild: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(Icons.search, color: Colors.black),
                    ),
                  ),
                  if (_screenIndex == 0)
                    MarketTabs(
                      key: ValueKey(provider.data!.data![_screenIndex].slug),
                      data: provider.data!.data![_screenIndex].data!,
                      onTap: _changeMarketIndex,
                    ),
                  if (_screenIndex == 0 &&
                      provider.data!.data![0].data![_marketIndex].data != null)
                    BaseTabs(
                      key: ValueKey(
                          "$_screenIndex+$_marketIndex+$_marketInnerIndex"),
                      selectedIndex: _marketInnerIndex,
                      data: provider.data!.data![0].data![_marketIndex].data!,
                      onTap: _changeMarketInnerIndex,
                      textStyle: styleBaseSemiBold(fontSize: 14),
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
