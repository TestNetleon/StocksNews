import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/ui/tabs/home/trendingWatchlist/trending.dart';
import 'package:stocks_news_new/ui/tabs/home/trendingWatchlist/watchlist.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
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
    if (_selectedIndex == 1) {
      MyHomeManager manager = context.read<MyHomeManager>();
      if (manager.watchlist?.data != null &&
          manager.watchlist?.data?.isNotEmpty == true) {
        return;
      }
      context.read<MyHomeManager>().getHomeWatchlist();
    }
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
          HomeTopTabs(selectedIndex: _selectedIndex, onTap: onChange),
          if (_selectedIndex == 0)
            Visibility(
              visible: trending != null && trending.isNotEmpty,
              child: HomeTrendingContainer(),
            ),
          if (_selectedIndex == 1)
            BaseLoaderContainer(
              hasData: provider.watchlist?.data != null &&
                  provider.watchlist?.data?.isNotEmpty == true,
              isLoading: provider.isLoadingWatchlist,
              showPreparingText: true,
              error: provider.errorWatchlist,
              child: HomeWatchlistContainer(),
            ),
        ],
      ),
    );
  }
}
