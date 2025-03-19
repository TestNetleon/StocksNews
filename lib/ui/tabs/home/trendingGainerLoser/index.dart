import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/tabs/home/trendingGainerLoser/home_top_gainers.dart';
import 'package:stocks_news_new/ui/tabs/home/trendingGainerLoser/home_top_losers.dart';
import 'package:stocks_news_new/ui/tabs/home/trendingGainerLoser/home_trending.dart';

class TrendingGainerLoser extends StatefulWidget {
  const TrendingGainerLoser({super.key});

  @override
  State<TrendingGainerLoser> createState() => _TrendingGainerLoserState();
}

class _TrendingGainerLoserState extends State<TrendingGainerLoser> {
  int _screenIndex = 0;
  List<MarketResData>? _tabs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupTabs();
    });
  }

  void _setupTabs() {
    setState(() {
      _tabs = [
        MarketResData(title: "Trending"),
        MarketResData(title: "Top Gainers"),
        MarketResData(title: "Top Losers"),
      ];
    });
  }

  void _onTabChanged(index) {
    setState(() {
      _screenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_tabs == null) {
      return SizedBox();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BaseTabs(data: _tabs!, onTap: _onTabChanged),
        _screenIndex == 0
            ? HomeTrending()
            : _screenIndex == 1
                ? HomeTopGainers()
                : HomeTopLosers(),
      ],
    );
  }
}
