import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

import '../../../../widgets/spacer_horizontal.dart';
import '../../../../widgets/spacer_vertical.dart';
import '../../../stockDetails/widgets/technicalAnalysis/base.dart';
import 'averages.dart';
import 'brief.dart';
import 'indicators.dart';
import 'symmary.dart';

class SdTechnical extends StatefulWidget {
  final String? symbol;
  const SdTechnical({super.key, this.symbol});

  @override
  State<SdTechnical> createState() => _SdTechnicalState();
}

class _SdTechnicalState extends State<SdTechnical> {
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callApi(interval: tabs[0].tabName);
    });
  }

  _callApi({required String interval}) {
    context.read<StockDetailProviderNew>().getTechnicalAnalysisData(
          symbol: widget.symbol,
          interval: interval,
        );
  }

  void onChange(index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      setState(() {});
      _callApi(interval: tabs[index].tabName);
    }
  }

  List<TabData> tabs = [
    TabData(tabName: "5min", label: "5 Mins"),
    TabData(tabName: "15min", label: "15 Mins"),
    TabData(tabName: "30min", label: "30 Mins"),
    TabData(tabName: "1hour", label: "Hourly"),
    TabData(tabName: "4hour", label: "4 Hours"),
    TabData(tabName: "1day", label: "Daily"),
    TabData(tabName: "1week", label: "Weekly"),
  ];

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    return CommonRefreshIndicator(
      onRefresh: () async {
        _callApi(interval: tabs[selectedIndex].tabName);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            Dimen.padding, Dimen.padding, Dimen.padding, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SdCommonHeading(),
            const Divider(
              color: ThemeColors.greyBorder,
              height: 20,
            ),
            Expanded(
              child: CustomTabContainerNEW(
                tabsPadding: const EdgeInsets.only(bottom: 10),
                scrollable: true,
                onChange: (index) {
                  onChange(index);
                },
                tabs:
                    List.generate(tabs.length, (index) => tabs[index].tabName),
                widgets: List.generate(
                  tabs.length,
                  (index) => BaseUiContainer(
                    isFull: true,
                    hasData:
                        !provider.isLoadingTech && provider.techRes != null,
                    isLoading: provider.isLoadingTech,
                    showPreparingText: true,
                    error: provider.errorTech,
                    onRefresh: () {
                      _callApi(interval: tabs[selectedIndex].tabName);
                    },
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              SdTechnicalAnalystSummary(
                                  constraints: constraints),
                              const SpacerVertical(height: 30),
                              Row(
                                children: [
                                  Expanded(
                                      child: SdTechnicalAnalystIndicators(
                                    constraints: constraints,
                                  )),
                                  const SpacerHorizontal(width: 20),
                                  Expanded(
                                    child: SdTechnicalAnalystAverages(
                                        constraints: constraints),
                                  ),
                                ],
                              ),
                              const SdTechnicalAnalysisBrief(),
                              const SpacerVertical(height: 10),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
