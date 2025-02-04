import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/featured_watchlist.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/featured/widgets/view.dart';
import 'package:stocks_news_new/utils/constants.dart';

class FeaturedStocksIndex extends StatelessWidget {
  const FeaturedStocksIndex({super.key});

  @override
  Widget build(BuildContext context) {
    HomeProvider provider = context.watch<HomeProvider>();
    // UserProvider userProvider = context.watch<UserProvider>();

    List<FeaturedTicker>? featured = provider.homeSliderRes?.featuredTickers;
    List<FeaturedTicker>? watchlist = provider.homeSliderRes?.watchlist;
    // print('watchlist ${watchlist?.length}');
    // print('featuredTickers ${featured?.length}');

    return Column(
      children: [
        Visibility(
          visible: (featured?.isNotEmpty == true && featured != null) &&
              provider.extra?.showFeatured == true,
          child: Container(
            margin: const EdgeInsets.only(top: Dimen.homeSpacing),
            child: FeaturedWatchlistStockView(
              isFeatured: true,
              data: featured,
            ),
          ),
        ),
        Visibility(
          visible: (watchlist?.isNotEmpty == true && watchlist != null) &&
              provider.extra?.showWatchlist == true,
          child: Padding(
            padding: const EdgeInsets.only(top: Dimen.homeSpacing),
            child: FeaturedWatchlistStockView(
              data: watchlist,
            ),
          ),
        ),
      ],
    );
  }
}
