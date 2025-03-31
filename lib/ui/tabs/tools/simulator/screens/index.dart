import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/portpolio.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/open/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/pending/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/recurring/index_list.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tickerSearch/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/transactions/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/widget/s_header.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../base/lock.dart';

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

class _SimulatorIndexState extends State<SimulatorIndex>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  List<MarketResData> initialTabs = [
    MarketResData(title: 'OPEN'),
    MarketResData(title: 'PENDING'),
    MarketResData(title: 'TRANSACTIONS'),
    MarketResData(title: 'RECURRING'),
  ];

  int? selectedScreen = 0;
  onScreenChange(index) {
    if (selectedScreen != index) {
      selectedScreen = index;
      setState(() {});
    }
  }

  @override
  void initState() {
    isOnTsScreen = true;
    super.initState();
    selectedScreen = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PortfolioManager manager = context.read<PortfolioManager>();
      context.read<ScannerManager>().getScannerPorts();
      manager.getDashboardData(reset: true).then((value) {
        _tabController = TabController(
          length: manager.userData?.userDataRes?.userConditionalOrderPermission
                      ?.recurringOrder ==
                  true
              ? 4
              : 3,
          vsync: this,
          initialIndex: widget.initialIndex,
        );
      });
    });
  }

  @override
  void dispose() {
    isOnTsScreen = false;
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PortfolioManager manager = context.watch<PortfolioManager>();
    num profitLoss =
        manager.userData?.userDataRes?.totalPortfolioStateAmount ?? 0;
    List<MarketResData> tabs = manager.userData?.userDataRes
                ?.userConditionalOrderPermission?.recurringOrder ==
            true
        ? initialTabs
        : initialTabs.sublist(0, initialTabs.length - 1);

    if (manager.isLoading) {
      return Loading();
    }
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        SSEManager.instance.disconnectAllScreens();
      },
      child: BaseScaffold(
        appBar: BaseAppBar(
          showSearch: true,
          showNotification: true,
        ),
        drawer: MoreIndex(),
        body: BaseLoaderContainer(
          hasData: manager.userData != null && !manager.isLoading,
          isLoading: manager.userData == null && manager.isLoading,
          error: manager.error,
          showPreparingText: true,
          onRefresh: () {
            manager.getDashboardData(reset: true);
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: DefaultTabController(
                  length: tabs.length,
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: 300.0,
                          floating: false,
                          pinned: false,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Pad.pad16, vertical: Pad.pad10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: CommonCard(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Portfolio Balance',
                                                style: styleBaseRegular(
                                                  fontSize: 12,
                                                  color: ThemeColors.neutral80,
                                                ),
                                              ),
                                              SpacerVertical(height: Pad.pad10),
                                              Text(
                                                manager.userData?.userDataRes
                                                            ?.tradeBalance !=
                                                        null
                                                    ? '${manager.userData?.userDataRes?.tradeBalance.toFormattedPrice()}'
                                                    : '\$0',
                                                style: styleBaseBold(
                                                    fontSize: 16,
                                                    color:
                                                        ThemeColors.splashBG),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SpacerHorizontal(width: 12),
                                      Expanded(
                                        child: CommonCard(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Gain & Loss',
                                                style: styleBaseRegular(
                                                  fontSize: 12,
                                                  color: ThemeColors.neutral80,
                                                ),
                                              ),
                                              SpacerVertical(height: Pad.pad10),
                                              Text(
                                                profitLoss.toFormattedPrice(),
                                                style: styleBaseBold(
                                                  fontSize: 16,
                                                  color: profitLoss < 0
                                                      ? ThemeColors.sos
                                                      : ThemeColors.accent,
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
                            centerTitle: false,
                          ),
                          automaticallyImplyLeading: false,
                        ),
                        SliverPersistentHeader(
                          delegate: _SliverAppBarDelegate(
                            TabBar(
                              controller: _tabController,
                              isScrollable: false,
                              labelPadding: EdgeInsets.zero,
                              indicator: CustomTabIndicator(),
                              labelColor: Colors.black87,
                              unselectedLabelColor: Colors.grey,
                              onTap: onScreenChange,
                              tabs: (tabs.map((e) {
                                int index = tabs.indexOf(e);
                                bool isSelected =
                                    index == _tabController?.index;
                                return Consumer<ThemeManager>(
                                    builder: (context, value, child) => Tab(
                                            child: Text(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          e.title ?? "",
                                          style: isSelected
                                              ? styleBaseBold(
                                                  fontSize: 11,
                                                  color: ThemeColors.selectedBG,
                                                )
                                              : styleBaseSemiBold(
                                                  color: ThemeColors.neutral20,
                                                  fontSize: 11,
                                                ),
                                        )));
                              })).toList(),
                            ),
                          ),
                          pinned: true,
                        ),
                      ];
                    },
                    body: Column(
                      children: [
                        BaseListDivider(),
                        SpacerVertical(height: Pad.pad8),
                        if (selectedScreen == 0)
                          Expanded(
                            child: SOpenList(),
                          ),
                        if (selectedScreen == 1)
                          Expanded(
                            child: SPendingList(),
                          ),
                        if (selectedScreen == 2)
                          Expanded(
                            child: STransactionList(),
                          ),
                        if (selectedScreen == 3 &&
                            manager
                                    .userData
                                    ?.userDataRes
                                    ?.userConditionalOrderPermission
                                    ?.recurringOrder ==
                                true)
                          Expanded(
                            child: SRecurringList(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              BaseLockItem(
                manager: manager,
                callAPI: () async {
                  await manager.getDashboardData(reset: true);
                },
              ),
              if (manager.userData?.lockInfo == null)
                BaseButton(
                  textSize: 16,
                  onPressed: () {
                    Navigator.push(
                      context,
                      createRoute(
                        SearchTickerIndex(),
                      ),
                    );
                  },
                  text: "Place New Order",
                  color: ThemeColors.primary100,
                  textColor: ThemeColors.splashBG,
                  margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
                )
            ],
          ),
        ),
      ),
    );
    /* return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        SSEManager.instance.disconnectAllScreens();
      },
      child: BaseScaffold(
        appBar: BaseAppBar(
          showSearch: true,
          showNotification: true,
        ),
        drawer: MoreIndex(),
        body: Stack(
          children: [
            BaseLoaderContainer(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Portfolio Balance',
                                      style: styleBaseRegular(
                                        fontSize: 12,
                                        color: ThemeColors.neutral80,
                                      ),
                                    ),
                                    SpacerVertical(height: Pad.pad10),
                                    Text(
                                      manager.userData?.userDataRes
                                                  ?.tradeBalance !=
                                              null
                                          ? '${manager.userData?.userDataRes?.tradeBalance.toFormattedPrice()}'
                                          : '\$0',
                                      style: styleBaseBold(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Gain & Loss',
                                      style: styleBaseRegular(
                                        fontSize: 12,
                                        color: ThemeColors.neutral80,
                                      ),
                                    ),
                                    SpacerVertical(height: Pad.pad10),
                                    Text(
                                      profitLoss.toFormattedPrice(),
                                      style: styleBaseBold(
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
                          data: manager
                                      .userData
                                      ?.userDataRes
                                      ?.userConditionalOrderPermission
                                      ?.recurringOrder ==
                                  true
                              ? manager.tabs
                              : manager.tabs
                                  .sublist(0, manager.tabs.length - 1),
                          // textStyle: styleBaseBold(fontSize: 11),
                          onTap: manager.onScreenChange,
                          selectedIndex: widget.initialIndex,
                          isScrollable: false,
                          labelPadding: EdgeInsets.zero,
                          fontSize: 11,
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
                        if (manager.selectedScreen == 3 &&
                            manager
                                    .userData
                                    ?.userDataRes
                                    ?.userConditionalOrderPermission
                                    ?.recurringOrder ==
                                true)
                          Expanded(
                            child: SRecurringList(),
                          ),
                      ],
                    ),
                  ),
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
            BaseLockItem(
              manager: manager,
              callAPI: () async {
                await manager.getDashboardData(reset: true);
              },
            ),
          ],
        ),
      ),
    );*/
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Consumer<ThemeManager>(builder: (context, value, child) {
      bool isDark = value.isDarkMode;
      return Container(
        color: isDark ? Colors.black : Colors.white,
        child: _tabBar,
      );
    });
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
