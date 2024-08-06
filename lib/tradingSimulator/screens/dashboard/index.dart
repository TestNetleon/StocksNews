import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/open/index.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/ts_dashboard_header.dart';
import 'package:stocks_news_new/tradingSimulator/widgets/ts_error_widget.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

class TsDashboard extends StatelessWidget {
  final int initialIndex;
  const TsDashboard({
    super.key,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(
        isPopback: true,
        canSearch: false,
        showTrailing: false,
        showPortfolio: true,
        title: "Virtual Trading Account",
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
        child: Column(
          children: [
            TsDashboardHeader(),
            Expanded(
              child: CommonTabContainer(
                initialIndex: initialIndex,
                scrollable: false,
                tabPaddingNew: false,
                tabs: const [
                  "Open",
                  "Pending",
                  "Transactions",
                ],
                widgets: const [
                  TsOpenList(),
                  SummaryErrorWidget(title: "No pending orders"),
                  SummaryErrorWidget(title: "No transactions"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
