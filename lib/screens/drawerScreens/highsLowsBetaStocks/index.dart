import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/drawerScreens/highsLowsBetaStocks/high_beta_stocks.dart';
import 'package:stocks_news_new/screens/drawerScreens/highsLowsBetaStocks/low_beta_stocks.dart';
import 'package:stocks_news_new/screens/drawerScreens/highsLowsBetaStocks/negative_beta_stocks.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_tab_container.dart';

class HighLowsBetaStocksIndex extends StatelessWidget {
  static const path = "HighLowsBetaStocksIndex";
  const HighLowsBetaStocksIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimen.padding,
          Dimen.padding,
          Dimen.padding,
          0,
        ),
        child: CustomTabContainerNEW(
          scrollable: true,
          tabsPadding: EdgeInsets.only(bottom: 10.sp),
          tabs: const [
            "High Beta Stocks",
            "Low Beta Stocks",
            "Negative Beta Stocks"
          ],
          widgets: const [
            HighBetaStocks(),
            LowBetaStocks(),
            NegativeBetaStocks(),
          ],
        ),
      ),
    );
  }
}
