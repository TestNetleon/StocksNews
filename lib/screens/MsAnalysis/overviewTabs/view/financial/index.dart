import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/screens/MsAnalysis/overviewTabs/view/widgets/container.dart';
import 'package:stocks_news_new/screens/MsAnalysis/overviewTabs/view/widgets/header.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../widgets/sliding_button.dart';
import 'widgets/revenue_chart.dart';

class MsFinancial extends StatefulWidget {
  const MsFinancial({super.key});

  @override
  State<MsFinancial> createState() => _MsFinancialState();
}

class _MsFinancialState extends State<MsFinancial>
    with SingleTickerProviderStateMixin {
  // int selectedIndex = 0;
  // int selectedFooterIndex = 0;

  // List<String> menus = [
  //   'Revenue',
  //   'Net profit',
  // ];
  // void onChange() {
  //   MSAnalysisProvider provider = context.read<MSAnalysisProvider>();

  //   provider.getFinancialsData(
  //     symbol: provider.topData?.symbol ?? "",
  //     type: selectedIndex == 0 ? 'revenue' : 'profit',
  //     period: selectedFooterIndex == 0 ? 'annual' : 'quarter',
  //   );

  //   setState(() {});
  // }

  // final List<MsBarChartRes> _revenueQuarterly = [
  //   MsBarChartRes(
  //     text: "Mar-23",
  //     value: 6,
  //   ),
  //   MsBarChartRes(
  //     text: "Jun-23",
  //     value: 3,
  //   ),
  //   MsBarChartRes(
  //     text: "Sep-23",
  //     value: 7,
  //   ),
  //   MsBarChartRes(
  //     text: "Dec-23",
  //     value: 9,
  //   ),
  //   MsBarChartRes(
  //     text: "Mar-24",
  //     value: 15,
  //   ),
  // ];
  // final List<MsBarChartRes> _netProfitQuarterly = [
  //   MsBarChartRes(
  //     text: "Mar-23",
  //     value: -4,
  //   ),
  //   MsBarChartRes(
  //     text: "Jun-23",
  //     value: -8,
  //   ),
  //   MsBarChartRes(
  //     text: "Sep-23",
  //     value: -10,
  //   ),
  //   MsBarChartRes(
  //     text: "Dec-23",
  //     value: -50,
  //   ),
  //   MsBarChartRes(
  //     text: "Mar-24",
  //     value: -4,
  //   ),
  // ];
  // final List<MsBarChartRes> _revenueYearly = [
  //   MsBarChartRes(
  //     text: "2020",
  //     value: 70,
  //   ),
  //   MsBarChartRes(
  //     text: "2021",
  //     value: 67,
  //   ),
  //   MsBarChartRes(
  //     text: "2022",
  //     value: 45,
  //   ),
  //   MsBarChartRes(
  //     text: "2023",
  //     value: 236,
  //   ),
  //   MsBarChartRes(
  //     text: "2024",
  //     value: 23,
  //   ),
  // ];
  // final List<MsBarChartRes> _netProfitYearly = [
  //   MsBarChartRes(
  //     text: "2020",
  //     value: 112,
  //   ),
  //   MsBarChartRes(
  //     text: "2021",
  //     value: 332,
  //   ),
  //   MsBarChartRes(
  //     text: "2022",
  //     value: 555,
  //   ),
  //   MsBarChartRes(
  //     text: "2023",
  //     value: 56,
  //   ),
  //   MsBarChartRes(
  //     text: "2024",
  //     value: -777,
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();

    return MsOverviewContainer(
      open: provider.openFinancials,
      baseChild: Padding(
        padding: const EdgeInsets.all(12),
        // child: MsOverviewHeader(
        //   open: provider.openPerformance,
        //   onTap: provider.openFinancialsStatus,
        //   leadingIcon: Icons.price_check_outlined,
        //   label: "Financials",
        // ),

        child: MsOverviewHeader(
          leadingIcon: Icons.format_indent_increase_outlined,
          label: "Financials",
          stateKey: MsProviderKeys.financials,
        ),
      ),
      animatedChild: Column(
        children: [
          SpacerVertical(height: 10),
          CustomSlidingSegmentedControl(
            menus: provider.typeMenu,
            onValueChanged: (index) {
              provider.onChangeFinancial(typeIndex: index);
            },
            selectedIndex: provider.selectedTypeIndex,
          ),
          SpacerVertical(height: 10),
          // if (selectedIndex == 0)
          //   selectedFooterIndex == 0
          //       ? MsFinancialCharts(chart: _revenueYearly)
          //       : MsFinancialCharts(chart: _revenueQuarterly),
          // if (selectedIndex == 1)
          //   selectedFooterIndex == 0
          //       ? MsFinancialCharts(chart: _netProfitYearly)
          //       : MsFinancialCharts(chart: _netProfitQuarterly),

          BaseUiContainer(
            hasData: provider.financialsData != null &&
                provider.financialsData?.isNotEmpty == true,
            isLoading: provider.isLoadingFinancials,
            error: provider.errorFinancials,
            showPreparingText: true,
            onRefresh: () {
              provider.onChangeFinancial(
                typeIndex: provider.selectedTypeIndex,
                periodIndex: provider.selectedPeriodIndex,
              );
            },
            placeholder: SizedBox(
              height: 250,
              child: Loading(),
            ),
            child: MsFinancialCharts(
              chart: provider.financialsData,
            ),
          ),

          // SpacerVertical(height: 15),
          // Text(
          //   'all values are in \$',
          //   style: stylePTSansRegular(fontSize: 12.0, color: Colors.white),
          // ),
          SpacerVertical(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                provider.periodMenu.length,
                (index) {
                  return Flexible(
                    child: GestureDetector(
                      onTap: () {
                        provider.onChangeFinancial(periodIndex: index);
                      },
                      child: Container(
                        // width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: provider.selectedPeriodIndex == index
                              ? Colors.white
                              : Colors.transparent,
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            index == 0 ? 'Yearly' : 'Quarterly',
                            style: stylePTSansBold(
                              fontSize: 14.0,
                              color: provider.selectedPeriodIndex == index
                                  ? const Color.fromARGB(255, 0, 0, 0)
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SpacerVertical(height: 10.0),
        ],
      ),
    );
  }
}

// class MsBarChartRes {
//   final String text;
//   final num value;
//   MsBarChartRes({
//     required this.text,
//     required this.value,
//   });
// }
