import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/screens/marketData/fiftyTwoWeeks/fifty_two_high.dart';
import 'package:stocks_news_new/screens/marketData/fiftyTwoWeeks/fifty_two_lows.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../../../widgets/custom_tab_container.dart';

class FiftyTwoWeeksIndex extends StatelessWidget {
  static const path = "FiftyTwoWeeksIndex";
  const FiftyTwoWeeksIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      body: CustomTabContainerNEW(
        scrollable: false,
        // tabsPadding: EdgeInsets.only(bottom: 10.sp),
        tabs: ["52 Week Highs", "52 Week Lows"],
        widgets: [
          FiftyTwoWeeksHighsStocks(),
          FiftyTwoWeeksLowsStocks(),
        ],
      ),
    );
  }
}
