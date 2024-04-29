import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/technicalAnalysis/widgets/averages.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/technicalAnalysis/widgets/indicators.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/technicalAnalysis/widgets/technical_brief.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

import 'widgets/summary.dart';

class StocksTechnicalAnalysisBase extends StatefulWidget {
  const StocksTechnicalAnalysisBase({super.key});

  @override
  State<StocksTechnicalAnalysisBase> createState() =>
      _StocksTechnicalAnalysisBaseState();
}

//
class _StocksTechnicalAnalysisBaseState
    extends State<StocksTechnicalAnalysisBase> {
  List<TabData> tabs = [
    TabData(tabName: "5min", label: "5 Min"),
    TabData(tabName: "15min", label: "15 Minutes"),
    TabData(tabName: "30min", label: "30 Min"),
    TabData(tabName: "1hour", label: "Hourly"),
    TabData(tabName: "4hour", label: "4 Hours"),
    TabData(tabName: "1day", label: "Daily"),
    TabData(tabName: "1week", label: "Weekly"),
  ];

  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: provider.tabLoading
              ? 300.sp
              : provider.technicalAnalysisRes?.movingAverageArr.isEmpty ==
                          true &&
                      provider.technicalAnalysisRes?.technicalIndicatorArr
                              .isEmpty ==
                          true
                  ? constraints.maxWidth * 1.7
                  : provider.technicalAnalysisRes?.movingAverageArr.isEmpty ==
                              true ||
                          provider.technicalAnalysisRes?.technicalIndicatorArr
                                  .isEmpty ==
                              true
                      ? constraints.maxWidth * 2
                      : constraints.maxWidth * 3.9,
          // child: CommonTabs(
          //   hasData:
          //       !provider.isLoading && provider.technicalAnalysisRes == null,
          //   isLoading: provider.isLoading,
          //   onTabChange: (index) {
          //     _selectedIndex = index;
          //     setState(() {});

          //     provider.onTabChanged(
          //       index: index,
          //       symbol: provider.data?.keyStats?.symbol ?? "",
          //       interval: tabs[index].tabName,
          //     );
          //   },
          //   tabContents:
          //       List.generate(tabs.length, (index) => _getWidget(constraints)),
          //   tabs: List.generate(
          //       tabs.length,
          //       (index) => CustomTab(
          //             lable: tabs[index].label ?? "",
          //             index: index,
          //             selectedIndex: _selectedIndex,
          //           )),
          //   error: provider.error,
          //   onRefresh: () {},
          //   screenScroll: true,
          // ),

          child: CustomTabContainer(
            onChange: (index) => provider.onTabChanged(
              index: index,
              symbol: provider.data?.keyStats?.symbol ?? "",
              interval: tabs[index].tabName,
            ),
            tabs:
                List.generate(tabs.length, (index) => tabs[index].label ?? ""),
            widgets: List.generate(
              tabs.length,
              (index) => provider.tabLoading
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SpacerHorizontal(width: 5),
                          const CircularProgressIndicator(
                            color: ThemeColors.accent,
                          ),
                          const SpacerHorizontal(width: 5),
                          Flexible(
                            child: Text(
                              "Fetching data for the last ${tabs[index].label}... Please wait",
                              style:
                                  stylePTSansRegular(color: ThemeColors.accent),
                            ),
                          ),
                        ],
                      ),
                    )
                  : provider.technicalAnalysisRes == null &&
                          !provider.tabLoading
                      ? SizedBox(
                          height: 100,
                          child: Center(
                            child: Text(
                              "No technical analysis data found.",
                              style: stylePTSansRegular(),
                            ),
                          ),
                        )
                      : _getWidget(constraints),
            ),
          ),
        );
      },
    );
  }

  Widget _getWidget(BoxConstraints constraints) {
    return IntrinsicHeight(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TechnicalAnalystSummary(constraints: constraints),
          const SpacerVerticel(height: 30),
          Row(
            children: [
              Expanded(
                  child: TechnicalAnalystIndicators(
                constraints: constraints,
              )),
              const SpacerHorizontal(width: 10),
              Expanded(
                child: TechnicalAnalystAverages(constraints: constraints),
              ),
            ],
          ),
          const TechnicalAnalysisBrief(),
        ],
      ),
    );
  }
}

class TabData {
  String tabName;
  String? label;
  TabData({
    required this.tabName,
    this.label,
  });
}
