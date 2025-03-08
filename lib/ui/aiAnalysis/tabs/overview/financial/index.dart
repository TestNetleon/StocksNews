import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/aiAnalysis/ai.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'widgets/revenue_chart.dart';

class AIFinancial extends StatefulWidget {
  const AIFinancial({super.key});

  @override
  State<AIFinancial> createState() => _AIFinancialState();
}

class _AIFinancialState extends State<AIFinancial>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    AIManager manager = context.watch<AIManager>();

    return Container(
      margin: EdgeInsets.only(
        top: Pad.pad32,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: BaseHeading(
              title: 'Financials',
              margin: EdgeInsets.only(
                bottom: 0,
                left: Pad.pad16,
                right: Pad.pad16,
              ),
            ),
          ),
          SpacerVertical(height: 10),
          BaseTabs(
            isScrollable: false,
            data: manager.typeMenu,
            onTap: (index) {
              if (manager.selectedTypeIndex != index) {
                manager.onChangeFinancial(typeIndex: index);
              }
            },
          ),
          SpacerVertical(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal:Pad.pad16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                manager.periodMenu.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: Pad.pad16, top: Pad.pad10),
                    child: GestureDetector(
                      onTap: () {
                        manager.onChangeFinancial(periodIndex: index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: manager.selectedPeriodIndex == index
                                ? ThemeColors.white
                                : ThemeColors.neutral10,
                          ),
                          color: manager.selectedPeriodIndex == index
                              ? ThemeColors.black
                              : Colors.transparent,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        child: Center(
                          child: Text(
                            index == 0 ? 'Yearly' : 'Quarterly',
                            style: stylePTSansBold(
                              fontSize: 14,
                              color: manager.selectedPeriodIndex == index
                                  ? ThemeColors.white
                                  : ThemeColors.black,
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

          SpacerVertical(height: 20),
          BaseBorderContainer(
            innerPadding: EdgeInsets.all(5),
            padding: EdgeInsets.symmetric(horizontal: Pad.pad16),
            child: BaseUiContainer(
              hasData: manager.financialsData != null,
              isLoading: manager.isLoadingFinancials,
              error: manager.errorFinancials,
              showPreparingText: true,
              onRefresh: () {
                manager.onChangeFinancial(
                  typeIndex: manager.selectedTypeIndex,
                  periodIndex: manager.selectedPeriodIndex,
                );
              },
              placeholder: SizedBox(
                height: 300,
                child: Loading(),
              ),
              child: AIFinancialCharts(
                chart: manager.financialsData?.data?.reversed.toList() ?? [],
              ),
            ),
          ),
          // SpacerVertical(height: 15),
          // Text(
          //   'all values are in \$',
          //   style: stylePTSansRegular(fontSize: 12.0, color: Colors.white),
          // ),
          SpacerVertical(height: 10),

          SpacerVertical(height: 10),
          Visibility(
            visible:
                manager.data?.usdText != null && manager.data?.usdText != '',
            child: Text(
              manager.data?.usdText ?? 'All values are in USD',
              style: stylePTSansRegular(color: ThemeColors.neutral80),
            ),
          ),
          SpacerVertical(height: 15),
        ],
      ),
    );
  }
}
