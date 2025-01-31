import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_portfollo_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/open/index.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/pending/index.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/ts_dashboard_header.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';
import '../../../utils/colors.dart';
import '../../manager/sse.dart';
import '../searchTradingTicker/index.dart';
import 'transactions/index.dart';

class TsDashboard extends StatefulWidget {
  final int initialIndex;
  const TsDashboard({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<TsDashboard> createState() => _TsDashboardState();
}

class _TsDashboardState extends State<TsDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TsPortfolioProvider>().getStreamKeysData();
      context
          .read<MarketScannerProvider>()
          .getScannerPorts(loading: false, start: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    TsPortfolioProvider provider = context.watch<TsPortfolioProvider>();

    num profitLoss = provider.userData?.totalPortfolioStateAmount ?? 0;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        SSEManager.instance.disconnectAllScreens();
      },
      child: BaseContainer(
        appBar: const AppBarHome(
          isPopBack: true,
          canSearch: false,
          showTrailing: false,
          showPortfolio: false,
          title: "Trading Simulator",
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 5),
              //   child: Row(
              //     children: [
              //       Flexible(
              //         child: Text(
              //           'Portfolio Balance: ',
              //           style: styleGeorgiaBold(),
              //         ),
              //       ),
              //       Flexible(
              //         child: Text(
              //           '${provider.userData?.tradeBalance}',
              //           style: styleGeorgiaBold(),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      // color: ThemeColors.accent,
                      border: Border(
                        left: BorderSide(color: ThemeColors.accent, width: 1),
                        right: BorderSide(color: ThemeColors.accent, width: 1),
                        top: BorderSide(color: ThemeColors.accent, width: 1),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: Text(
                              'Portfolio Balance',
                              style: styleGeorgiaBold(),
                            )),
                            Flexible(
                              child: Text(
                                provider.userData?.tradeBalance != null
                                    ? '${provider.userData?.tradeBalance.toFormattedPrice()}'
                                    : '\$0',
                                style: styleGeorgiaBold(),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 14,
                          color: ThemeColors.divider,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'Cumulative Gain & Loss',
                                style: styleGeorgiaBold(),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                profitLoss.toFormattedPrice(),
                                style: styleGeorgiaBold(
                                  color: profitLoss < 0
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  TsDashboardHeader(),
                ],
              ),
              Expanded(
                child: CommonTabContainer(
                  initialIndex: widget.initialIndex,
                  scrollable: false,
                  tabPaddingNew: false,
                  physics: const NeverScrollableScrollPhysics(),
                  tabs: const ["Open", "Pending", "Transactions"],
                  widgets: const [
                    TsOpenList(),
                    TsPendingList(),
                    // SummaryErrorWidget(title: "No pending orders"),
                    // SummaryErrorWidget(title: "No transactions"),
                    TsTransactionList(),
                  ],
                ),
              ),
              ThemeButton(
                textSize: 17,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                // onPressed: tradeSheet,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchTradingTicker(),
                    ),
                  );
                },
                text: "Place New Order",
                // color: const Color.fromARGB(255, 194, 216, 51),
                color: ThemeColors.accent,

                // icon: Icons.arrow_outward_outlined,
                textColor: ThemeColors.background,
              ),
              SpacerVertical(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
