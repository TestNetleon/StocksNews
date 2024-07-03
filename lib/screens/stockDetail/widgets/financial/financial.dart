// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:stocks_news_new/providers/stock_detail_new.dart';
// // import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
// // import 'package:stocks_news_new/utils/colors.dart';
// // import 'package:stocks_news_new/utils/constants.dart';
// // import 'package:stocks_news_new/widgets/base_ui_container.dart';
// // import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
// // import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// // import '../../../../widgets/disclaimer_widget.dart';
// // import 'item.dart';
// // import 'tab.dart';

// // class SdFinancial extends StatefulWidget {
// //   final String? symbol;
// //   const SdFinancial({super.key, this.symbol});

// //   @override
// //   State<SdFinancial> createState() => _SdFinancialState();
// // }

// // class _SdFinancialState extends State<SdFinancial> {
// //   int openIndex = -1;

// //   void changeOpenIndex(int index) {
// //     setState(() {
// //       openIndex = openIndex == index ? -1 : index;
// //     });
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
// //       // if (provider.sdFinancialRes == null) {
// //       //   _callApi();
// //       // }
// //       if (provider.sdFinancialArray == null) {
// //         _callApi();
// //       }
// //     });
// //   }

// //   _callApi({reset = false, showProgress = false}) {
// //     context.read<StockDetailProviderNew>().getFinancialData(
// //           symbol: widget.symbol,
// //           reset: reset,
// //         );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
// //     return BaseUiContainer(
// //       hasData:
// //           !provider.isLoadingFinancial && provider.sdFinancialArray != null,
// //       isLoading: provider.isLoadingFinancial,
// //       showPreparingText: true,
// //       error: provider.errorFinancial,
// //       isFull: true,
// //       onRefresh: () => _callApi(reset: true, showProgress: true),
// //       child: CommonRefreshIndicator(
// //         onRefresh: () async => _callApi(reset: true, showProgress: true),
// //         child: SingleChildScrollView(
// //           physics: const AlwaysScrollableScrollPhysics(),
// //           child: Padding(
// //             padding: const EdgeInsets.fromLTRB(
// //                 Dimen.padding, Dimen.padding, Dimen.padding, 0),
// //             child: Column(
// //               children: [
// //                 const SdCommonHeading(),
// //                 const Divider(
// //                   color: ThemeColors.white,
// //                   thickness: 2,
// //                   height: 20,
// //                 ),
// //                 const SpacerVertical(height: 15),
// //                 Visibility(
// //                   visible: provider.extraFinancial?.type != null,
// //                   child: SdFinancialTabs(
// //                     tabs: provider.extraFinancial?.type,
// //                     onChange: (index) =>
// //                         provider.changeTabType(index, symbol: widget.symbol),
// //                     selectedIndex: provider.typeIndex,
// //                   ),
// //                 ),
// //                 Visibility(
// //                   visible: provider.extraFinancial?.period != null,
// //                   child: SdFinancialTabs(
// //                     tabs: provider.extraFinancial?.period,
// //                     onChange: (index) =>
// //                         provider.changePeriodType(index, symbol: widget.symbol),
// //                     selectedIndex: provider.periodIndex,
// //                   ),
// //                 ),
// //                 ListView.separated(
// //                     padding: const EdgeInsets.only(top: 0, bottom: 15),
// //                     shrinkWrap: true,
// //                     physics: const NeverScrollableScrollPhysics(),
// //                     itemBuilder: (context, index) {
// //                       // FinanceStatement? data =
// //                       //     provider.sdFinancsialRes?.financeStatement?[index];
// //                       Map<String, dynamic>? data =
// //                           provider.sdFinancialArray?[index];

// //                       return Container(
// //                         decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(5),
// //                             color: ThemeColors.greyBorder.withOpacity(0.3)),
// //                         child: SdFinancialItem(
// //                           data: data,
// //                           index: index,
// //                           openIndex: openIndex,
// //                           onCardTapped: changeOpenIndex,
// //                         ),
// //                       );
// //                     },
// //                     separatorBuilder: (context, index) {
// //                       return const SpacerVertical(height: 15);
// //                     },
// //                     itemCount: provider.sdFinancialArray?.length ?? 0),
// //                 if (provider.extra?.disclaimer != null)
// //                   DisclaimerWidget(
// //                     data: provider.extra!.disclaimer!,
// //                   ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/stockDetailRes/financial.dart';
// import 'package:stocks_news_new/providers/stock_detail_new.dart';
// import 'package:stocks_news_new/screens/barChart/bar_chart_item.dart';
// import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/base_ui_container.dart';
// import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import '../../../../widgets/disclaimer_widget.dart';
// import 'item.dart';
// import 'tab.dart';

// class SdFinancial extends StatefulWidget {
//   final String? symbol;
//   const SdFinancial({super.key, this.symbol});

//   @override
//   State<SdFinancial> createState() => _SdFinancialState();
// }

// class _SdFinancialState extends State<SdFinancial> {
//   int openIndex = -1;

//   void changeOpenIndex(int index) {
//     setState(() {
//       openIndex = openIndex == index ? -1 : index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
//       // if (provider.sdFinancialRes == null) {
//       //   _callApi();
//       // }
//       if (provider.sdFinancialArray == null) {
//         _callApi();
//       }
//     });
//   }

//   _callApi({reset = false, showProgress = false}) {
//     context.read<StockDetailProviderNew>().getFinancialData(
//           symbol: widget.symbol,
//           reset: reset,
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
//     SdFinancialRes? data = provider.sdFinancialChartRes;
//     Utils().showLog(' data111113: ${data?.chart?[0].totalAssets}');

//     return BaseUiContainer(
//       hasData:
//           !provider.isLoadingFinancial && provider.sdFinancialArray != null,
//       isLoading: provider.isLoadingFinancial,
//       showPreparingText: true,
//       error: provider.errorFinancial,
//       isFull: true,
//       onRefresh: () => _callApi(reset: true, showProgress: true),
//       child: CommonRefreshIndicator(
//         onRefresh: () async => _callApi(reset: true, showProgress: true),
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(
//                 Dimen.padding, Dimen.padding, Dimen.padding, 0),
//             child: Column(
//               children: [
//                 const SdCommonHeading(),
//                 const Divider(
//                   color: ThemeColors.white,
//                   thickness: 2,
//                   height: 20,
//                 ),
//                 const SpacerVertical(height: 15),
//                 Visibility(
//                   visible: provider.extraFinancial?.type != null,
//                   child: SdFinancialTabs(
//                     tabs: provider.extraFinancial?.type,
//                     onChange: (index) =>
//                         provider.changeTabType(index, symbol: widget.symbol),
//                     selectedIndex: provider.typeIndex,
//                   ),
//                 ),
//                 SizedBox(height: 200, child: BarChartSample(data: data)),
//                 Visibility(
//                   visible: provider.extraFinancial?.period != null,
//                   child: SdFinancialTabs(
//                     tabs: provider.extraFinancial?.period,
//                     onChange: (index) =>
//                         provider.changePeriodType(index, symbol: widget.symbol),
//                     selectedIndex: provider.periodIndex,
//                   ),
//                 ),
//                 ListView.separated(
//                     padding: const EdgeInsets.only(top: 0, bottom: 15),
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       // FinanceStatement? data =
//                       //     provider.sdFinancsialRes?.financeStatement?[index];
//                       Map<String, dynamic>? data =
//                           provider.sdFinancialArray?[index];

//                       return Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: ThemeColors.greyBorder.withOpacity(0.3)),
//                         child: SdFinancialItem(
//                           data: data,
//                           index: index,
//                           openIndex: openIndex,
//                           onCardTapped: changeOpenIndex,
//                         ),
//                       );
//                     },
//                     separatorBuilder: (context, index) {
//                       return const SpacerVertical(height: 15);
//                     },
//                     itemCount: provider.sdFinancialArray?.length ?? 0),
//                 if (provider.extra?.disclaimer != null)
//                   DisclaimerWidget(
//                     data: provider.extra!.disclaimer!,
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/stock_detail_new.dart';
// import 'package:stocks_news_new/screens/stockDetail/widgets/common_heading.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/widgets/base_ui_container.dart';
// import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import '../../../../widgets/disclaimer_widget.dart';
// import 'item.dart';
// import 'tab.dart';

// class SdFinancial extends StatefulWidget {
//   final String? symbol;
//   const SdFinancial({super.key, this.symbol});

//   @override
//   State<SdFinancial> createState() => _SdFinancialState();
// }

// class _SdFinancialState extends State<SdFinancial> {
//   int openIndex = -1;

//   void changeOpenIndex(int index) {
//     setState(() {
//       openIndex = openIndex == index ? -1 : index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       StockDetailProviderNew provider = context.read<StockDetailProviderNew>();
//       // if (provider.sdFinancialRes == null) {
//       //   _callApi();
//       // }
//       if (provider.sdFinancialArray == null) {
//         _callApi();
//       }
//     });
//   }

//   _callApi({reset = false, showProgress = false}) {
//     context.read<StockDetailProviderNew>().getFinancialData(
//           symbol: widget.symbol,
//           reset: reset,
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
//     return BaseUiContainer(
//       hasData:
//           !provider.isLoadingFinancial && provider.sdFinancialArray != null,
//       isLoading: provider.isLoadingFinancial,
//       showPreparingText: true,
//       error: provider.errorFinancial,
//       isFull: true,
//       onRefresh: () => _callApi(reset: true, showProgress: true),
//       child: CommonRefreshIndicator(
//         onRefresh: () async => _callApi(reset: true, showProgress: true),
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(
//                 Dimen.padding, Dimen.padding, Dimen.padding, 0),
//             child: Column(
//               children: [
//                 const SdCommonHeading(),
//                 const Divider(
//                   color: ThemeColors.white,
//                   thickness: 2,
//                   height: 20,
//                 ),
//                 const SpacerVertical(height: 15),
//                 Visibility(
//                   visible: provider.extraFinancial?.type != null,
//                   child: SdFinancialTabs(
//                     tabs: provider.extraFinancial?.type,
//                     onChange: (index) =>
//                         provider.changeTabType(index, symbol: widget.symbol),
//                     selectedIndex: provider.typeIndex,
//                   ),
//                 ),
//                 Visibility(
//                   visible: provider.extraFinancial?.period != null,
//                   child: SdFinancialTabs(
//                     tabs: provider.extraFinancial?.period,
//                     onChange: (index) =>
//                         provider.changePeriodType(index, symbol: widget.symbol),
//                     selectedIndex: provider.periodIndex,
//                   ),
//                 ),
//                 ListView.separated(
//                     padding: const EdgeInsets.only(top: 0, bottom: 15),
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       // FinanceStatement? data =
//                       //     provider.sdFinancsialRes?.financeStatement?[index];
//                       Map<String, dynamic>? data =
//                           provider.sdFinancialArray?[index];

//                       return Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: ThemeColors.greyBorder.withOpacity(0.3)),
//                         child: SdFinancialItem(
//                           data: data,
//                           index: index,
//                           openIndex: openIndex,
//                           onCardTapped: changeOpenIndex,
//                         ),
//                       );
//                     },
//                     separatorBuilder: (context, index) {
//                       return const SpacerVertical(height: 15);
//                     },
//                     itemCount: provider.sdFinancialArray?.length ?? 0),
//                 if (provider.extra?.disclaimer != null)
//                   DisclaimerWidget(
//                     data: provider.extra!.disclaimer!,
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
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
    Utils().showLog(' data111113: ${data?.chart?[0].totalAssets}');

    return BaseUiContainer(
      hasData:
          !provider.isLoadingFinancial && provider.sdFinancialArray != null,
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
                Visibility(
                  visible: provider.extraFinancial?.type != null,
                  child: SdFinancialTabs(
                    tabs: provider.extraFinancial?.type,
                    onChange: (index) =>
                        provider.changeTabType(index, symbol: widget.symbol),
                    selectedIndex: provider.typeIndex,
                  ),
                ),
                const SpacerVertical(height: 15),
                if (data?.chart?[0].totalAssets != null ||
                    data?.chart?[0].revenue != null ||
                    data?.chart?[0].operatingCashFlow1 != null)
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.circle,
                          color: Color.fromARGB(255, 7, 181, 255),
                          size: 10,
                        ),
                        const SpacerHorizontal(
                          width: 5,
                        ),
                        Text(
                          data?.chart?[0].totalAssets != null
                              ? "Total Assets"
                              : data?.chart?[0].revenue != null
                                  ? "Revenue"
                                  : "Operating Cash Flow",
                          style: stylePTSansBold(fontSize: 12),
                        ),
                        const SpacerHorizontal(
                          width: 10,
                        ),
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
                              : data?.chart?[0].revenue != null
                                  ? "Net Income"
                                  : "Investing Cash Flow",
                          style: stylePTSansBold(fontSize: 12),
                        ),
                        if (data?.chart?[0].operatingCashFlow1 != null)
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
                                "Fin",
                                style: stylePTSansBold(fontSize: 12),
                              )
                            ],
                          )
                      ],
                    ),
                  ),
                const SpacerVertical(height: 15),
                if (data?.chart?[0].totalAssets != null ||
                    data?.chart?[0].revenue != null)
                  SizedBox(height: 200, child: BarChartSample(data: data)),
                if (data?.chart?[0].operatingCashFlow1 != null)
                  SizedBox(height: 200, child: BarChartThreeLine(data: data)),
                const SpacerVertical(height: 15),
                Visibility(
                  visible: provider.extraFinancial?.period != null,
                  child: SdFinancialTabs(
                    tabs: provider.extraFinancial?.period,
                    onChange: (index) =>
                        provider.changePeriodType(index, symbol: widget.symbol),
                    selectedIndex: provider.periodIndex,
                  ),
                ),
                Visibility(
                  visible: provider.extraFinancial?.period != null,
                  child: SdFinancialTabs(
                    tabs: convertMultipleStringListsToSdTopResLists(),
                    onChange: (index) => provider.changePeriodTypeIndexVoid(
                      index,
                    ),
                    selectedIndex: provider.changePeriodTypeIndex,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${data?.financeStatement?[provider.changePeriodTypeIndex].period}",
                      style: stylePTSansRegular(
                        fontSize: 14,
                        color: ThemeColors.greyBorder,
                      ),
                    ),
                    const SpacerHorizontal(width: 20),
                    Text(
                      "Y/Y\nChange",
                      style: stylePTSansRegular(
                        fontSize: 14,
                        color: ThemeColors.greyBorder,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: ThemeColors.greyBorder,
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      provider.typeValue != null &&
                              provider.typeValue == "income-statement"
                          ? "Revenue"
                          : provider.typeValue != null &&
                                  provider.typeValue ==
                                      "balance-sheet-statement"
                              ? "Total Assets"
                              : "Operating Cash Flow",
                      style: stylePTSansRegular(fontSize: 14),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          provider.typeValue != null &&
                                  provider.typeValue == "income-statement"
                              ? "${data?.financeStatement?[provider.changePeriodTypeIndex].revenue}"
                              : provider.typeValue != null &&
                                      provider.typeValue ==
                                          "balance-sheet-statement"
                                  ? "${data?.financeStatement?[provider.changePeriodTypeIndex].totalAssets}"
                                  : "${data?.financeStatement?[provider.changePeriodTypeIndex].operatingCashFlow}",
                          style: stylePTSansRegular(fontSize: 14),
                        ),
                        const SpacerHorizontal(width: 20),
                        Text(
                          provider.typeValue != null &&
                                  provider.typeValue == "income-statement"
                              ? "${data?.financeStatement?[provider.changePeriodTypeIndex].revenueChangePercentage}"
                              : provider.typeValue != null &&
                                      provider.typeValue ==
                                          "balance-sheet-statement"
                                  ? "${data?.financeStatement?[provider.changePeriodTypeIndex].totalAssetsChangePercentage}"
                                  : "${data?.financeStatement?[provider.changePeriodTypeIndex].operatingCashFlowChangePercentage}",
                          style: stylePTSansRegular(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(
                  color: ThemeColors.greyBorder,
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      provider.typeValue != null &&
                              provider.typeValue == "income-statement"
                          ? "Net Income"
                          : provider.typeValue != null &&
                                  provider.typeValue ==
                                      "balance-sheet-statement"
                              ? "Total Liabilities"
                              : "Investing Cash Flow",
                      style: stylePTSansRegular(fontSize: 14),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          provider.typeValue != null &&
                                  provider.typeValue == "income-statement"
                              ? "${data?.financeStatement?[provider.changePeriodTypeIndex].netIncome}"
                              : provider.typeValue != null &&
                                      provider.typeValue ==
                                          "balance-sheet-statement"
                                  ? "${data?.financeStatement?[provider.changePeriodTypeIndex].totalLiabilities}"
                                  : "${data?.financeStatement?[provider.changePeriodTypeIndex].operatingCashFlow}",
                          style: stylePTSansRegular(fontSize: 14),
                        ),
                        const SpacerHorizontal(width: 20),
                        Text(
                          provider.typeValue != null &&
                                  provider.typeValue == "income-statement"
                              ? "${data?.financeStatement?[provider.changePeriodTypeIndex].investingCashFlow}"
                              : provider.typeValue != null &&
                                      provider.typeValue ==
                                          "balance-sheet-statement"
                                  ? "${data?.financeStatement?[provider.changePeriodTypeIndex].totalLiabilitiesChangePercentage}"
                                  : "${data?.financeStatement?[provider.changePeriodTypeIndex].investingCashFlowChangePercentage}",
                          style: stylePTSansRegular(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                if (data?.financeStatement?[provider.changePeriodTypeIndex]
                        .financingCashFlow !=
                    null)
                  const Divider(
                    color: ThemeColors.greyBorder,
                    height: 15,
                  ),
                if (data?.financeStatement?[provider.changePeriodTypeIndex]
                        .financingCashFlow !=
                    null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Financing Cash Flow",
                        style: stylePTSansRegular(fontSize: 14),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            provider.typeValue != null &&
                                    provider.typeValue ==
                                        "cash-flow-statement" &&
                                    data
                                            ?.financeStatement?[
                                                provider.changePeriodTypeIndex]
                                            .financingCashFlow !=
                                        null
                                ? "${data?.financeStatement?[provider.changePeriodTypeIndex].financingCashFlow}"
                                : "",
                            style: stylePTSansRegular(fontSize: 14),
                          ),
                          const SpacerHorizontal(width: 20),
                          Text(
                            provider.typeValue != null &&
                                    provider.typeValue ==
                                        "cash-flow-statement" &&
                                    data
                                            ?.financeStatement?[
                                                provider.changePeriodTypeIndex]
                                            .financingCashFlow !=
                                        null
                                ? "${data?.financeStatement?[provider.changePeriodTypeIndex].financingCashFlowChangePercentage}"
                                : "",
                            style: stylePTSansRegular(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                const SpacerVertical(height: 15),
                ListView.separated(
                    padding: const EdgeInsets.only(top: 0, bottom: 15),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // FinanceStatement? data =
                      //     provider.sdFinancsialRes?.financeStatement?[index];
                      Map<String, dynamic>? data =
                          provider.sdFinancialArray?[index];

                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: ThemeColors.greyBorder.withOpacity(0.3)),
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
