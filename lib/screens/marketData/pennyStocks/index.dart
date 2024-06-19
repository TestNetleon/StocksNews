import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/screens/marketData/pennyStocks/most_active_penny_stocks.dart';
import 'package:stocks_news_new/screens/marketData/pennyStocks/most_popular_penny_stocks.dart';
import 'package:stocks_news_new/screens/marketData/pennyStocks/top_today-penny_stocks.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

class PennyStocks extends StatelessWidget {
  static const path = "PennyStocks";

  // final StocksType? type;
  const PennyStocks({
    super.key,
    // this.type = StocksType.gapUp
  });

  @override
  Widget build(BuildContext context) {
    return const BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      body: CustomTabContainerNEW(
        scrollable: true,
        tabsPadding: EdgeInsets.zero,
        tabs: [
          "Most Active Penny Stocks",
          "Most Popular Penny Stocks",
          "Top Today's Penny Stocks"
        ],
        widgets: [
          MostActivePennyStocks(),
          MostPopularPennyStocks(),
          TopTodayPennyStocks(),
        ],
      ),
    );
  }
}
