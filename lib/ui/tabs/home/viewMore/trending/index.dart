import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/home/viewMore/trending/trending_now.dart';
import 'package:stocks_news_new/ui/tabs/home/viewMore/trending/trending_recently.dart';

class TrendingViewAllIndex extends StatefulWidget {
  static const path = 'TrendingViewAllIndex';
  const TrendingViewAllIndex({super.key});

  @override
  State<TrendingViewAllIndex> createState() => _TrendingViewAllIndexState();
}

class _TrendingViewAllIndexState extends State<TrendingViewAllIndex> {
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
        MarketResData(title: "Trending Now"),
        MarketResData(title: "Trending Recently"),
        MarketResData(title: "Trending By Market Cap"),
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

    return BaseScaffold(
      appBar: BaseAppBar(showBack: true),
      body: _tabs == null
          ? SizedBox()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BaseTabs(data: _tabs!, onTap: _onTabChanged),
                Flexible(
                  child: _screenIndex == 0
                      ? TrendingNow()
                      : _screenIndex == 1
                          ? TrendingRecently()
                          : Center(child: const Text("In Progress")),
                ),
              ],
            ),
    );
  }
}
