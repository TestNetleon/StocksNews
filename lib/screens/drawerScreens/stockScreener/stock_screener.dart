import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/drawerScreens/stockScreener/stock_screener_list.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class StockScreenerScreen extends StatelessWidget {
  static const path = "StockScreenerScreen";
  const StockScreenerScreen({super.key});
  // void _onFilterClick(BuildContext context, dynamic provider) {
  //   BaseBottomSheets().gradientBottomSheet(
  //     title: "Filter Insider Trades",
  //     child: MarketDataFilterBottomSheet(provider: provider),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // StockScreenerProvider provider = context.watch<StockScreenerProvider>();

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
        child: Stack(
          children: [
            StockScreenerList(),
            // Positioned(
            //   bottom: 10,
            //   right: 0,
            //   child: FloatingActionButton(
            //     onPressed: () => _onFilterClick(context, provider),
            //     backgroundColor: Colors.white,
            //     child: const Icon(
            //       Icons.filter_alt,
            //       color: ThemeColors.accent,
            //       size: 30,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
