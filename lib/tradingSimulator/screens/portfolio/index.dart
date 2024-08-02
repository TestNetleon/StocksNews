import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/tradingSimulator/screens/portfolio/container.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

class TsPortfolio extends StatelessWidget {
  const TsPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
        canSearch: false,
        showTrailing: false,
        title: "Virtual Trading Portfolio",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimen.padding),
        child: TsPortfolioContainer(),
      ),
    );
  }
}
