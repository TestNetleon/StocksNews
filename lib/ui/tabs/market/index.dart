import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/market.dart';
import 'package:stocks_news_new/screens/marketData/gainersLosers/today_breakout_stocks.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/tabs/market/extra/filter.dart';
import 'package:stocks_news_new/ui/tabs/market/gainer&Losers/todays_gainers.dart';
import 'package:stocks_news_new/ui/tabs/market/gainer&Losers/todays_losers.dart';
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
    MarketManager provider = context.read<MarketManager>();
    provider.getData();
  }

  Widget _showSelectedScreen() {
    if (_screenIndex == 1) {
      // Sector
      return Container();
    } else if (_screenIndex == 2) {
      // industries
      return Container();
    } else if (_screenIndex == 0 &&
        _marketIndex == 0 &&
        _marketInnerIndex == 0) {
      return MostBullish();
    } else if (_screenIndex == 0 &&
        _marketIndex == 0 &&
        _marketInnerIndex == 1) {
      return MostBearish();
    } else if (_screenIndex == 0 &&
        _marketIndex == 1 &&
        _marketInnerIndex == 0) {
      return TodaysGainer();
    } else if (_screenIndex == 0 &&
        _marketIndex == 1 &&
        _marketInnerIndex == 1) {
      return TodaysLosers();
    } else if (_screenIndex == 0 &&
        _marketIndex == 1 &&
        _marketInnerIndex == 2) {
      return TodaysBreakoutStocks();
    }
    return Container();
  }

  void _openFiler() {
    Navigator.push(context, createRoute(MarketFilter()));
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
                    onTap: (index) {
                      setState(() {
                        _screenIndex = index;
                      });
                    },
                    rightChild: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(Icons.search, color: Colors.black),
                    ),
                  ),
                  if (_screenIndex == 0)
                    MarketTabs(
                      key: ValueKey(provider.data!.data![_screenIndex].slug),
                      data: provider.data!.data![_screenIndex].data!,
                      onTap: (index) {
                        setState(() {
                          _marketIndex = index;
                          _marketInnerIndex = 0;
                        });
                      },
                    ),
                  if (_screenIndex == 0 &&
                      provider.data!.data![0].data![_marketIndex].data != null)
                    BaseTabs(
                      key: ValueKey(
                          "$_screenIndex+$_marketIndex+$_marketInnerIndex"),
                      selectedIndex: _marketInnerIndex,
                      data: provider.data!.data![0].data![_marketIndex].data!,
                      onTap: (index) {
                        setState(() {
                          _marketInnerIndex = index;
                        });
                      },
                      textStyle: styleBaseSemiBold(fontSize: 14),
                      leftChild: Container(
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
                      ),
                    ),
                  Expanded(child: _showSelectedScreen()),
                ],
              ),
      ),
    );
  }
}
