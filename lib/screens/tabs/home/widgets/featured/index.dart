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

    List<FeaturedTicker>? featured = provider.fwData?.featuredTickers;
    List<FeaturedTicker>? watchlist = provider.fwData?.watchlist;

    return Column(
      children: [
        Visibility(
          visible: provider.extraFW?.showFeatured == true,
          child: FeaturedWatchlistStockView(
            isFeatured: true,
            data: featured,
          ),
        ),
        Visibility(
          visible: (watchlist?.isNotEmpty == true && watchlist != null) &&
              provider.extraFW?.showWatchlist == true,
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
