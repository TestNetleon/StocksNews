import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/open/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/pending/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/recurring/index_list.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tickerSearch/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/transactions/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/widget/s_header.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SimulatorIndex extends StatefulWidget {
  static const String path = "SimulatorIndex";
  final int initialIndex;
  const SimulatorIndex({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<SimulatorIndex> createState() => _SimulatorIndexState();
}

class _SimulatorIndexState extends State<SimulatorIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isOnTsScreen = true;
      // context.read<MarketScannerM>().getScannerPorts(start: false);
      context.read<PortfolioManager>().getDashboardData(reset: true);
    });
  }

  @override
  void dispose() {
    isOnTsScreen = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PortfolioManager manager = context.watch<PortfolioManager>();
    num profitLoss =
        manager.userData?.userDataRes?.totalPortfolioStateAmount ?? 0;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        SSEManager.instance.disconnectAllScreens();
      },
      child: BaseScaffold(
        appBar: BaseAppBar(
          showBack: true,
          title: "Trading Simulator",
        ),
        body: BaseLoaderContainer(
          hasData: manager.userData != null && !manager.isLoading,
          isLoading: manager.userData == null && manager.isLoading,
          error: manager.error,
          showPreparingText: true,
          onRefresh: () {
            manager.getDashboardData(reset: true);
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Pad.pad16, vertical: Pad.pad10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CommonCard(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Portfolio Balance',
                                  style: stylePTSansRegular(
                                    fontSize: 12,
                                    color: ThemeColors.neutral80,
                                  ),
                                ),
                                SpacerVertical(height: Pad.pad10),
                                Text(
                                  manager.userData?.userDataRes?.tradeBalance !=
                                          null
                                      ? '${manager.userData?.userDataRes?.tradeBalance.toFormattedPrice()}'
                                      : '\$0',
                                  style: stylePTSansBold(
                                      fontSize: 16,
                                      color: ThemeColors.splashBG),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SpacerHorizontal(width: 12),
                        Expanded(
                          child: CommonCard(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Gain & Loss',
                                  style: stylePTSansRegular(
                                    fontSize: 12,
                                    color: ThemeColors.neutral80,
                                  ),
                                ),
                                SpacerVertical(height: Pad.pad10),
                                Text(
                                  profitLoss.toFormattedPrice(),
                                  style: stylePTSansBold(
                                    fontSize: 16,
                                    color: profitLoss < 0
                                        ? ThemeColors.error120
                                        : ThemeColors.success120,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SpacerVertical(height: Pad.pad16),
                    SHeader(),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    BaseTabs(
                      data: manager.tabs,
                      // textStyle: styleBaseBold(fontSize: 11),
                      onTap: manager.onScreenChange,
                      selectedIndex: widget.initialIndex,
                      isScrollable: false,
                      labelPadding: EdgeInsets.zero,
                    ),
                    SpacerVertical(height: Pad.pad8),
                    if (manager.selectedScreen == 0)
                      Expanded(
                        child: SOpenList(),
                      ),
                    if (manager.selectedScreen == 1)
                      Expanded(
                        child: SPendingList(),
                      ),
                    if (manager.selectedScreen == 2)
                      Expanded(
                        child: STransactionList(),
                      ),
                    if (manager.selectedScreen == 3)
                      Expanded(
                        child: SRecurringList(),
                      ),
                  ],
                ),
              ),
              /* Expanded(
                child:
                CommonTabContainer(
                  initialIndex: widget.initialIndex,
                  scrollable: false,
                  tabPaddingNew: false,
                  //tabLabelPadding: true,
                  physics: const NeverScrollableScrollPhysics(),
                  tabs: manager.userData?.userDataRes?.userConditionalOrderPermission?.recurringOrder == true? ["Open","Pending","Transactions","Recurring"]:["Open","Pending","Transactions"],
                  widgets:
                  manager.userData?.userDataRes?.userConditionalOrderPermission?.recurringOrder == true?
                  [
                    SOpenList(),
                    SPendingList(),
                    STransactionList(),
                    SRecurringList(),
                  ]:
                  [
                    SOpenList(),
                    SPendingList(),
                    STransactionList(),
                  ],
                ),
              ),*/
              BaseButton(
                textSize: 16,
                onPressed: () {
                  Navigator.push(
                    context,
                    createRoute(
                      SearchTickerIndex(),
                    ),
                  );
                  // Navigator.pushNamed(context, SearchTickerIndex.path);
                },
                text: "Place New Order",
                color: ThemeColors.primary100,
                textColor: ThemeColors.splashBG,
                margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
