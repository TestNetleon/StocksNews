import 'package:flutter/widgets.dart';

import 'package:stocks_news_new/screens/drawerScreens/mostActive/most_active_stocks.dart';
import 'package:stocks_news_new/screens/drawerScreens/mostActive/most_volatile_stocks.dart';
import 'package:stocks_news_new/screens/drawerScreens/mostActive/unusual_trading_volume.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../../../utils/constants.dart';
import '../../../widgets/custom_tab_container.dart';

class MostActiveIndex extends StatelessWidget {
  static const path = "MostActiveIndex";
  const MostActiveIndex({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimen.padding,
          Dimen.padding,
          Dimen.padding,
          0,
        ),
        child: CustomTabContainerNEW(
          scrollable: true,
          // tabsPadding: EdgeInsets.only(bottom: 10.sp),
          tabs: [
            "Most Active Stocks",
            "Most Volatile Stocks",
            "Unusual Trading Volume",
          ],
          widgets: [
            MostActiveStocks(),
            MostVolatileStocks(),
            UnusualTradingVolume(),
          ],
        ),
      ),
    );
  }
}
