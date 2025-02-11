import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home.dart';
import 'package:stocks_news_new/ui/tabs/home/trendingWatchlist/trending.dart';
import 'package:stocks_news_new/ui/tabs/home/trendingWatchlist/watchlist.dart';
import '../../../models/ticker.dart';
import 'trendingWatchlist/tab.dart';

class HomeTrendingIndex extends StatefulWidget {
  const HomeTrendingIndex({super.key});

  @override
  State<HomeTrendingIndex> createState() => _HomeTrendingIndexState();
}

class _HomeTrendingIndexState extends State<HomeTrendingIndex> {
  int _selectedIndex = 0;

  onChange(index) {
    _selectedIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MyHomeManager provider = context.watch<MyHomeManager>();
    List<BaseTickerRes>? trending = provider.data?.tickers;
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeTopTabs(
            selectedIndex: _selectedIndex,
            onTap: onChange,
          ),
          if (_selectedIndex == 0)
            Visibility(
              visible: trending != null && trending.isNotEmpty,
              child: HomeTrendingContainer(),
            ),
          if (_selectedIndex == 1) HomeWatchlistContainer(),
        ],
      ),
    );
  }
}
