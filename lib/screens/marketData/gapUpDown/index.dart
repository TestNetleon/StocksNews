import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocks_news_new/screens/marketData/gapUpDown/gap_down_stocks.dart';
import 'package:stocks_news_new/screens/marketData/gapUpDown/gap_up_stocks.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import '../../../utils/constants.dart';

class GapUpDownStocks extends StatelessWidget {
  static const path = "GapUpDownStocks";

  final StocksType? type;
  const GapUpDownStocks({super.key, this.type = StocksType.gapUp});

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
        tabsPadding: EdgeInsets.zero,
        tabs: ["Gap Up Stocks", "Gap Down Stocks"],
        widgets: [
          GapUpStocks(),
          GapDownStocks(),
        ],
      ),
    );
  }
}
