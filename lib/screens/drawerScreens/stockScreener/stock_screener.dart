import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/drawerScreens/stockScreener/stock_screener_list.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class StockScreenerScreen extends StatelessWidget {
  static const path = "StockScreenerScreen";
  const StockScreenerScreen({super.key});

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
        child: StockScreenerList(),
      ),
    );
  }
}
