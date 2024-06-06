import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

class StockDetail extends StatelessWidget {
  final String symbol;
  final String? inAppMsgId;
  final String? notificationId;
  static const String path = "StockDetail";

  const StockDetail({
    super.key,
    required this.symbol,
    this.inAppMsgId,
    this.notificationId,
  });

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      // moreGradient: true,
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      bottomSafeAreaColor: ThemeColors.background.withOpacity(0.8),
      body: const CustomTabContainerNEW(
        physics: NeverScrollableScrollPhysics(),
        scrollable: true,
        tabs: [
          "Overview",
          "Stock Analysis",
          "Technical Analysis",
          "Analyst Forecast",
          "Social Activities",
          "Latest news",
          "Earnings",
          "Dividends",
          "Insider Trades",
          "Competitors",
          "Ownership",
          "Chart",
          "Financials",
          "SEC Filings",
          "Mergers"
        ],
        widgets: [
          Center(child: Text("Overview")),
          Center(child: Text("Stock Analysis")),
          Center(child: Text("Technical Analysis")),
          Center(child: Text("Analyst Forecast")),
          Center(child: Text("Social Activities")),
          Center(child: Text("Latest news")),
          Center(child: Text("Earnings")),
          Center(child: Text("Dividends")),
          Center(child: Text("Insider Trades")),
          Center(child: Text("Competitors")),
          Center(child: Text("Ownership")),
          Center(child: Text("Chart")),
          Center(child: Text("Financials")),
          Center(child: Text("SEC Filings")),
          Center(child: Text("Mergers")),
        ],
      ),
    );
  }
}
