import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/technicalAnalysis/widgets/summary.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom_tab.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../base.dart';
import '../widgets/averages.dart';
import '../widgets/indicators.dart';
import '../widgets/technical_brief.dart';

class TEstTechnicalAnalysis extends StatefulWidget {
  const TEstTechnicalAnalysis({super.key});

  @override
  State<TEstTechnicalAnalysis> createState() => _TEstTechnicalAnalysisState();
}

class _TEstTechnicalAnalysisState extends State<TEstTechnicalAnalysis>
    with SingleTickerProviderStateMixin {
  TabController? _controller;

  List<TabData> tabs = [
    TabData(tabName: "5min", label: "5 Mins"),
    TabData(tabName: "15min", label: "15 Mins"),
    TabData(tabName: "30min", label: "30 Mins"),
    TabData(tabName: "1hour", label: "Hourly"),
    TabData(tabName: "4hour", label: "4 Hours"),
    TabData(tabName: "1day", label: "Daily"),
    TabData(tabName: "1week", label: "Weekly"),
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          tabAlignment: TabAlignment.start,
          physics: const BouncingScrollPhysics(),
          isScrollable: true,
          labelPadding: EdgeInsets.symmetric(
            horizontal: 13.sp,
            vertical: 2.sp,
          ),
          indicator: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: ThemeColors.accent,
              ),
            ),
          ),

          controller: _controller,
          indicatorColor: ThemeColors.white,
          automaticIndicatorColorAdjustment: true,

          // tabAlignment: TabAlignment.center,
          // physics: const BouncingScrollPhysics(),
          // isScrollable: true,
          // labelPadding: EdgeInsets.all(6.sp),
          // controller: _controller,
          // indicatorColor: Colors.transparent,
          // automaticIndicatorColorAdjustment: false,
          // enableFeedback: false,
          onTap: (value) {
            _selectedIndex = value;
            setState(() {});
            provider.onTabChanged(
              index: value,
              symbol: provider.data?.keyStats?.symbol ?? "",
              interval: tabs[value].tabName,
            );
          },
          tabs: List.generate(
            tabs.length,
            (index) => CustomTabNEW(
              index: index,
              label: "${tabs[index].label}",
              selectedIndex: _selectedIndex,
            ),
          ),
        ),
        const SpacerVertical(height: 10),
        provider.tabLoading
            ? SizedBox(
                height: 300.sp,
                child: Center(
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
                          "We are preparing, Please wait...",
                          style: stylePTSansRegular(color: ThemeColors.accent),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : provider.technicalAnalysisRes == null && !provider.tabLoading
                ? SizedBox(
                    height: 300.sp,
                    child: Center(
                      child: Text(
                        "No technical analysis data found.",
                        style: stylePTSansRegular(),
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        children: [
                          TechnicalAnalystSummary(constraints: constraints),
                          const SpacerVertical(height: 30),
                          Row(
                            children: [
                              Expanded(
                                  child: TechnicalAnalystIndicators(
                                constraints: constraints,
                              )),
                              const SpacerHorizontal(width: 10),
                              Expanded(
                                child: TechnicalAnalystAverages(
                                    constraints: constraints),
                              ),
                            ],
                          ),
                          const TechnicalAnalysisBrief(),
                        ],
                      );
                    },
                  )
      ],
    );
  }
}
