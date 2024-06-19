import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/marketData/dividends/dividends_list.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class DividendsScreen extends StatelessWidget {
  static const path = "DividendsScreen";
  const DividendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      body: DividendsList(),
    );
  }
}
