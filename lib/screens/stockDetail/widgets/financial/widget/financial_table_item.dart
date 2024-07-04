// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/stock_detail_new.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';

// class FinancialTableItem extends StatelessWidget {
//   const FinancialTableItem({required this.index, super.key});
//   final int index;

//   @override
//   Widget build(BuildContext context) {
//     StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
//     Map<String, dynamic>? data = provider.sdFinancialArray?[index];
//     // return Column(
//     //   children: [
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index].period ?? "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index].periodEnded ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index].revenue ?? "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .revenueChangePercentage ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .costOfRevenue ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index].grossProfit ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       "${provider.sdFinancialChartRes?.financeStatement?[index].grossProfitRatio}",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .researchAndDevelopmentExpenses ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .generalAdministrativeExpenses ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .sellingMarketingExpenses ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .otherExpenses ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .operatingExpenses ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .costAndExpenses ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .interestIncome ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .interestExpense ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .depreciationAmortization ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index].ebitda ?? "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     )
//     //     // uuu
//     //     ,
//     //     Text(
//     //       "${provider.sdFinancialChartRes?.financeStatement?[index].ebitdaRatio ?? ""}",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .operatingIncome ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .sellingMarketingExpenses ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .otherExpenses ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .operatingExpenses ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .costAndExpenses ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .interestIncome ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .interestExpense ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index]
//     //               .depreciationAmortization ??
//     //           "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     ),
//     //     Text(
//     //       provider.sdFinancialChartRes?.financeStatement?[index].ebitda ?? "",
//     //       style: stylePTSansRegular(fontSize: 14),
//     //     )
//     //   ],
//     // );

//     return Row(
//       children: [
//         ...data?.entries.map((entry) {
//               Utils().showLog("data --- ${entry.value}");

//               return Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Flexible(
//                       //   child: Text(
//                       //     entry.key,
//                       //     style: stylePTSansRegular(fontSize: 14),
//                       //   ),
//                       // ),
//                       entry.key == "Link"
//                           ? InkWell(
//                               borderRadius: BorderRadius.circular(50),
//                               onTap: () {
//                                 openUrl(entry.value);
//                               },
//                               child: const Padding(
//                                 padding: EdgeInsets.all(5),
//                                 child: Icon(
//                                   Icons.info_rounded,
//                                   color: ThemeColors.accent,
//                                   size: 20,
//                                 ),
//                               ),
//                             )
//                           : Flexible(
//                               child: Text(
//                                 "${entry.value ?? 'N/A'}",
//                                 style: stylePTSansRegular(fontSize: 14),
//                               ),
//                             ),
//                     ],
//                   ),
//                   const Divider(
//                     color: ThemeColors.greyBorder,
//                     height: 20,
//                   ),
//                 ],
//               );
//             }).toList() ??
//             [],
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';

class FinancialTableItem extends StatelessWidget {
  const FinancialTableItem({required this.index, super.key});
  final int index;

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    Map<String, dynamic>? data = provider.sdFinancialArray?[index];

    if (data == null) {
      return SizedBox.shrink(); // Return an empty widget if data is null
    }

    return Column(
      children: [
        ...data.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 2,
                  child: Text(
                    entry.key,
                    style: stylePTSansRegular(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 3,
                  child: entry.key == "Link"
                      ? InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            Utils().showLog("Opening URL: ${entry.value}");
                            openUrl(entry.value);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.info_rounded,
                              color: ThemeColors.accent,
                              size: 20,
                            ),
                          ),
                        )
                      : Text(
                          "${entry.value ?? 'N/A'}",
                          style: stylePTSansRegular(fontSize: 14),
                        ),
                ),
              ],
            ),
          );
        }).toList(),
        const Divider(color: ThemeColors.greyBorder),
      ],
    );
  }

  void openUrl(String url) {
    // Implement URL opening logic, possibly using url_launcher package
    // Example: launch(url);
  }
}
