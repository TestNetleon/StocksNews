import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/screens/drawerScreens/gapUpDown/gap_down_stocks.dart';
import 'package:stocks_news_new/screens/drawerScreens/pennyStocks/most_active_penny_stocks.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import '../../../utils/constants.dart';

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
          scrollable: false,
          tabsPadding: EdgeInsets.zero,
          tabs: ["Most Active", "Most Popular", "Top Today"],
          widgets: [
            MostActivePennyStocks(),
            MostActivePennyStocks(),
            MostActivePennyStocks(),
          ],
        ),
      ),
    );
  }
}
