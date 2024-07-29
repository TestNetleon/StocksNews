import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/earnings_provider.dart';
import 'package:stocks_news_new/screens/marketData/earnings/earnings_list.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class EarningsScreen extends StatelessWidget {
  static const path = "EarningScreens";
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    EarningsProvider provider = context.watch<EarningsProvider>();

    return BaseContainer(
      bottomSafeAreaColor: ThemeColors.background,
      appBar: AppBarHome(isPopback: true, title: provider.extra?.title),
      body: EarningsList(),
    );
  }
}
