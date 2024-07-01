import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/screens/marketData/highsLowsBetaStocks/high_beta_stocks.dart';
import 'package:stocks_news_new/screens/marketData/highsLowsBetaStocks/low_beta_stocks.dart';
import 'package:stocks_news_new/screens/marketData/highsLowsBetaStocks/negative_beta_stocks.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../../../widgets/custom_tab_container.dart';

class HighLowsBetaStocksIndex extends StatelessWidget {
  static const path = "HighLowsBetaStocksIndex";
  const HighLowsBetaStocksIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      body: CommonTabContainer(
        scrollable: true,
        // tabsPadding: EdgeInsets.only(bottom: 10.sp),
        tabs: ["High Beta Stocks", "Low Beta Stocks", "Negative Beta Stocks"],
        widgets: [
          HighBetaStocks(),
          LowsBetaStocks(),
          NegativeBetaStocks(),
        ],
      ),
    );
  }
}
