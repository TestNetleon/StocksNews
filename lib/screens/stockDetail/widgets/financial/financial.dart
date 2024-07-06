import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/financial.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/barChart/bar_chart_item.dart';
import 'package:stocks_news_new/screens/barChart/bar_chart_three.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../widgets/disclaimer_widget.dart';
import 'item.dart';
import 'tab.dart';

class SdFinancial extends StatefulWidget {
  final String? symbol;
  const SdFinancial({super.key, this.symbol});

  @override
  State<SdFinancial> createState() => _SdFinancialState();
}

class _SdFinancialState extends State<SdFinancial> {
  int openIndex = -1;

  void changeOpenIndex(int index) {
    setState(() {
      openIndex = openIndex == index ? -1 : index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StockDetailProviderNew provider = context.read<StockDetailProviderNew>();

      if (provider.sdFinancialArray == null) {
        _callApi();
      }
    });
  }

  _callApi({reset = false, showProgress = false}) {
    context.read<StockDetailProviderNew>().getFinancialData(
          symbol: widget.symbol,
          reset: reset,
        );
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    SdFinancialRes? data = provider.sdFinancialChartRes;
    // Utils().showLog(' data111113: ${data?.chart?[0].totalAssets}');

    // List<FinanceStatement>? financeStatements = data?.financeStatement;

    return BaseUiContainer(
      hasData:!provider.isLoadingFinancial && provider.sdFinancialArray != null,
      isLoading: provider.isLoadingFinancial,
      showPreparingText: true,
      error: provider.errorFinancial,
      isFull: true,
      onRefresh: () => _callApi(reset: true, showProgress: true),
      child: CommonRefreshIndicator(
        onRefresh: () async => _callApi(reset: true, showProgress: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                Dimen.padding, Dimen.padding, Dimen.padding, 0),
            child: Column(
              children: [
                const SdCommonHeading(),
                const Divider(
                  color: ThemeColors.white,
                  thickness: 2,
                  height: 20,
                ),
                const SpacerVertical(height: 15),
                Card(
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: ThemeColors.greyBorder.withOpacity(0.4),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ThemeColors.background,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 37, 37, 37)
                              .withOpacity(1), // Shadow color
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 15, bottom: 10, left: 20),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Company Financials",
                              style: stylePTSansBold(fontSize: 18),
                            ),
                          ),
                          const SpacerVertical(height: 15),
                          Visibility(
                            visible: provider.extraFinancial?.type != null,
                            child: SizedBox(
                              width: double.infinity,
                              child: SdFinancialTabs(
                                tabs: provider.extraFinancial?.type,
                                onChange: (index) => provider.changeTabType(
                                    index,
                                    symbol: widget.symbol),
                                selectedIndex: provider.typeIndex,
                              ),
                            ),
                          ),
                          if (data?.chart?[0].totalAssets != null ||
                              data?.chart?[0].revenue != null ||
                              data?.chart?[0].operatingCashFlow1 != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: SizedBox(
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            color: Color.fromARGB(
                                                255, 7, 181, 255),
                                            size: 10,
                                          ),
                                          const SpacerHorizontal(
                                            width: 5,
                                          ),
                                          Text(
                                            data?.chart?[0].totalAssets != null
                                                ? "Total Assets"
                                                : data?.chart?[0].revenue !=
                                                        null
                                                    ? "Revenue"
                                                    : "Operating Cash Flow",
                                            style:
                                                stylePTSansBold(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const SpacerHorizontal(
                                        width: 10,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            color: ThemeColors.accent,
                                            size: 10,
                                          ),
                                          const SpacerHorizontal(
                                            width: 5,
                                          ),
                                          Text(
                                            data?.chart?[0].totalAssets != null
                                                ? "Total Liabilities"
                                                : data?.chart?[0].revenue !=
                                                        null
                                                    ? "Net Income"
                                                    : "Investing Cash Flow",
                                            style:
                                                stylePTSansBold(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      if (data?.chart?[0].operatingCashFlow1 !=
                                          null)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SpacerHorizontal(
                                              width: 10,
                                            ),
                                            const Icon(
                                              Icons.circle,
                                              color: Colors.yellow,
                                              size: 10,
                                            ),
                                            const SpacerHorizontal(
                                              width: 5,
                                            ),
                                            Text(
                                              "Financing Cash Flow",
                                              style:
                                                  stylePTSansBold(fontSize: 12),
                                            )
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          const SpacerVertical(height: 40),
                          if (data?.chart?[0].totalAssets != null ||
                              data?.chart?[0].revenue != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                  height: 200,
                                  child: BarChartSample(data: data)),
                            ),
                          if (data?.chart?[0].operatingCashFlow1 != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                  height: 200,
                                  child: BarChartThreeLine(data: data)),
                            ),
                          const SpacerVertical(height: 15),
                          Visibility(
                            visible: provider.extraFinancial?.period != null,
                            child: SdFinancialTabs(
                              tabs: provider.extraFinancial?.period,
                              onChange: (index) => provider.changePeriodType(
                                  index,
                                  symbol: widget.symbol),
                              selectedIndex: provider.periodIndex,
                            ),
                          ),
                          Visibility(
                            visible: provider.extraFinancial?.period != null,
                            child: SdFinancialTabs(
                              tabs: convertMultipleStringListsToSdTopResLists(),
                              onChange: (index) =>
                                  provider.changePeriodTypeIndexVoid(
                                index,
                              ),
                              selectedIndex: provider.changePeriodTypeIndex,
                            ),
                          ),
                          if (provider.typeValue != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      textAlign: TextAlign.right,
                                      "${data?.financeStatement?[provider.changePeriodTypeIndex].period}"
                                          .replaceAll('-20', ''),
                                      style: stylePTSansBold(
                                        fontSize: 14,
                                        color: ThemeColors.greyBorder,
                                      ),
                                    ),
                                  ),
                                  const SpacerHorizontal(width: 5),
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      textAlign: TextAlign.right,
                                      "Y/Y\nChange",
                                      style: stylePTSansBold(
                                        fontSize: 14,
                                        color: ThemeColors.greyBorder,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (provider.typeValue != null)
                            const Padding(
                              padding: EdgeInsets.only(
                                  right: 20, top: 5, bottom: 15),
                              child: Divider(
                                color: ThemeColors.greyBorder,
                                height: 15,
                              ),
                            ),
                          if (provider.typeValue != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    provider.typeValue != null &&
                                            provider.typeValue ==
                                                "income-statement"
                                        ? "Revenue"
                                        : provider.typeValue != null &&
                                                provider.typeValue ==
                                                    "balance-sheet-statement"
                                            ? "Total Assets"
                                            : "Operating Cash Flow",
                                    style: stylePTSansRegular(fontSize: 14),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          textAlign: TextAlign.right,
                                          provider.typeValue != null &&
                                                  provider.typeValue ==
                                                      "income-statement"
                                              ? "${data?.financeStatement?[provider.changePeriodTypeIndex].revenue}"
                                              : provider.typeValue != null &&
                                                      provider.typeValue ==
                                                          "balance-sheet-statement"
                                                  ? "${data?.financeStatement?[provider.changePeriodTypeIndex].totalAssets}"
                                                  : "${data?.financeStatement?[provider.changePeriodTypeIndex].operatingCashFlow}",
                                          style: stylePTSansBold(fontSize: 14),
                                        ),
                                      ),
                                      // const SpacerHorizontal(width: 5),
                                      SizedBox(
                                        width: 70,
                                        child: Text(
                                          textAlign: TextAlign.right,
                                          provider.typeValue != null &&
                                                  provider.typeValue ==
                                                      "income-statement"
                                              ? "${data?.financeStatement?[provider.changePeriodTypeIndex].revenueChangePercentage}"
                                              : provider.typeValue != null &&
                                                      provider.typeValue ==
                                                          "balance-sheet-statement"
                                                  ? "${data?.financeStatement?[provider.changePeriodTypeIndex].totalAssetsChangePercentage}"
                                                  : "${data?.financeStatement?[provider.changePeriodTypeIndex].operatingCashFlowChangePercentage}",
                                          // style: stylePTSansRegular(fontSize: 14),
                                          style: stylePTSansRegular(
                                            fontSize: 14,
                                            color: (provider.typeValue !=
                                                        null &&
                                                    provider.typeValue ==
                                                        "income-statement" &&
                                                    containsMinusSymbol(
                                                        "${data?.financeStatement?[provider.changePeriodTypeIndex].revenueChangePercentage}"))
                                                ? Colors.red
                                                : (provider.typeValue != null &&
                                                        provider.typeValue ==
                                                            "balance-sheet-statement" &&
                                                        containsMinusSymbol(
                                                            "${data?.financeStatement?[provider.changePeriodTypeIndex].totalAssetsChangePercentage}"))
                                                    ? Colors.red
                                                    : (provider.typeValue !=
                                                                null &&
                                                            provider.typeValue ==
                                                                "cash-flow-statement" &&
                                                            containsMinusSymbol(
                                                                "${data?.financeStatement?[provider.changePeriodTypeIndex].operatingCashFlowChangePercentage}"))
                                                        ? Colors.red
                                                        : ThemeColors.accent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          if (provider.typeValue != null)
                            const Padding(
                              padding: EdgeInsets.only(
                                  right: 20, top: 15, bottom: 15),
                              child: Divider(
                                color: ThemeColors.greyBorder,
                                height: 15,
                              ),
                            ),
                          if (provider.typeValue != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    provider.typeValue != null &&
                                            provider.typeValue ==
                                                "income-statement"
                                        ? "Net Income"
                                        : provider.typeValue != null &&
                                                provider.typeValue ==
                                                    "balance-sheet-statement"
                                            ? "Total Liabilities"
                                            : "Investing Cash Flow",
                                    style: stylePTSansRegular(fontSize: 14),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          textAlign: TextAlign.right,
                                          provider.typeValue != null &&
                                                  provider.typeValue ==
                                                      "income-statement"
                                              ? "${data?.financeStatement?[provider.changePeriodTypeIndex].netIncome}"
                                              : provider.typeValue != null &&
                                                      provider.typeValue ==
                                                          "balance-sheet-statement"
                                                  ? "${data?.financeStatement?[provider.changePeriodTypeIndex].totalLiabilities}"
                                                  : "${data?.financeStatement?[provider.changePeriodTypeIndex].investingCashFlow}",
                                          style: stylePTSansBold(fontSize: 14),
                                        ),
                                      ),
                                      // const SpacerHorizontal(width: 5),
                                      SizedBox(
                                        width: 70,
                                        child: Text(
                                          textAlign: TextAlign.right,
                                          provider.typeValue != null &&
                                                  provider.typeValue ==
                                                      "income-statement"
                                              ? "${data?.financeStatement?[provider.changePeriodTypeIndex].netIncomeChangePercentage}"
                                              : provider.typeValue != null &&
                                                      provider.typeValue ==
                                                          "balance-sheet-statement"
                                                  ? "${data?.financeStatement?[provider.changePeriodTypeIndex].totalLiabilitiesChangePercentage}"
                                                  : "${data?.financeStatement?[provider.changePeriodTypeIndex].investingCashFlowChangePercentage}",
                                          // style: stylePTSansRegular(fontSize: 14),
                                          style: stylePTSansRegular(
                                            fontSize: 14,
                                            color: (provider.typeValue !=
                                                        null &&
                                                    provider.typeValue ==
                                                        "income-statement" &&
                                                    containsMinusSymbol(
                                                        "${data?.financeStatement?[provider.changePeriodTypeIndex].netIncomeChangePercentage}"))
                                                ? Colors.red
                                                : (provider.typeValue != null &&
                                                        provider.typeValue ==
                                                            "balance-sheet-statement" &&
                                                        containsMinusSymbol(
                                                            "${data?.financeStatement?[provider.changePeriodTypeIndex].totalLiabilitiesChangePercentage}"))
                                                    ? Colors.red
                                                    : (provider.typeValue !=
                                                                null &&
                                                            provider.typeValue ==
                                                                "cash-flow-statement" &&
                                                            containsMinusSymbol(
                                                                "${data?.financeStatement?[provider.changePeriodTypeIndex].investingCashFlowChangePercentage}"))
                                                        ? Colors.red
                                                        : ThemeColors.accent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          if (provider.typeValue != null)
                            if (data
                                    ?.financeStatement?[
                                        provider.changePeriodTypeIndex]
                                    .financingCashFlow !=
                                null)
                              const Padding(
                                padding: EdgeInsets.only(
                                    right: 20, top: 15, bottom: 15),
                                child: Divider(
                                  color: ThemeColors.greyBorder,
                                  height: 15,
                                ),
                              ),
                          if (provider.typeValue != null)
                            if (data
                                    ?.financeStatement?[
                                        provider.changePeriodTypeIndex]
                                    .financingCashFlow !=
                                null)
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Financing Cash Flow",
                                      style: stylePTSansRegular(fontSize: 14),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            textAlign: TextAlign.right,
                                            provider.typeValue != null &&
                                                    provider.typeValue ==
                                                        "cash-flow-statement" &&
                                                    data
                                                            ?.financeStatement?[
                                                                provider
                                                                    .changePeriodTypeIndex]
                                                            .financingCashFlow !=
                                                        null
                                                ? "${data?.financeStatement?[provider.changePeriodTypeIndex].financingCashFlow}"
                                                : "",
                                            style:
                                                stylePTSansBold(fontSize: 14),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 70,
                                          child: Text(
                                            textAlign: TextAlign.right,
                                            provider.typeValue != null &&
                                                    provider.typeValue ==
                                                        "cash-flow-statement" &&
                                                    data
                                                            ?.financeStatement?[
                                                                provider
                                                                    .changePeriodTypeIndex]
                                                            .financingCashFlow !=
                                                        null
                                                ? "${data?.financeStatement?[provider.changePeriodTypeIndex].financingCashFlowChangePercentage}"
                                                : "",
                                            // style: stylePTSansRegular(fontSize: 14),
                                            style: stylePTSansRegular(
                                              fontSize: 14,
                                              color: (provider.typeValue !=
                                                          null &&
                                                      provider.typeValue ==
                                                          "cash-flow-statement" &&
                                                      containsMinusSymbol(
                                                          "${data?.financeStatement?[provider.changePeriodTypeIndex].financingCashFlowChangePercentage}"))
                                                  ? Colors.red
                                                  : ThemeColors.accent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SpacerVertical(height: 15),
                FinancialTableItem(),
                const SpacerVertical(height: 15),
                ListView.separated(
                    padding: const EdgeInsets.only(top: 0, bottom: 15),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      Map<String, dynamic>? data =
                          provider.sdFinancialArray?[index];

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ThemeColors.greyBorder.withOpacity(0.3),
                        ),
                        child: SdFinancialItem(
                          data: data,
                          index: index,
                          openIndex: openIndex,
                          onCardTapped: changeOpenIndex,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SpacerVertical(height: 15);
                    },
                    itemCount: provider.sdFinancialArray?.length ?? 0),
                if (provider.extra?.disclaimer != null)
                  DisclaimerWidget(
                    data: provider.extra!.disclaimer!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
