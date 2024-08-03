import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/financial.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class AreaChartTopWidget extends StatefulWidget {
  const AreaChartTopWidget({super.key});

  @override
  State<AreaChartTopWidget> createState() => _AreaChartTopWidgetState();
}

class _AreaChartTopWidgetState extends State<AreaChartTopWidget> {
  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    SdFinancialRes? data = provider.sdFinancialChartRes;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  color: const Color(0xffc0e7ff), // Top color

                  borderRadius: BorderRadius.all(Radius.circular(10.sp))),
              child: Text(
                textAlign: TextAlign.center,
                data?.chart?[0].totalAssets != null
                    ? "Total Assets"
                    : data?.chart?[0].revenue != null
                        ? "Revenue"
                        : "Operating",
                style: stylePTSansBold(
                    fontSize: 12, color: const Color(0xff008aff)),
              ),
            ),
            const SpacerVertical(height: 10),
            Text(
              data?.financeStatement?[0].revenue != null &&
                      provider.typeValue == "income-statement"
                  ? "${data?.financeStatement?[0].revenue}"
                  : data?.financeStatement?[0].totalAssets != null &&
                          provider.typeValue == "balance-sheet-statement"
                      ? "${data?.financeStatement?[0].totalAssets}"
                      : "${data?.financeStatement?[0].operatingCashFlow ?? ""}",
              style: stylePTSansBold(fontSize: 20),
            ),
            const SpacerVertical(height: 10),
            if (provider.typeValue != "cash-flow-statement")
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_drop_up),
                  Text(
                    textAlign: TextAlign.center,
                    provider.typeValue != null &&
                            provider.typeValue == "income-statement"
                        ? "${data?.financeStatement?[provider.changePeriodTypeIndex].revenueChangePercentage}"
                        : provider.typeValue != null &&
                                provider.typeValue == "balance-sheet-statement"
                            ? "${data?.financeStatement?[provider.changePeriodTypeIndex].totalAssetsChangePercentage}"
                            : "${data?.financeStatement?[provider.changePeriodTypeIndex].operatingCashFlowChangePercentage}",
                    style: stylePTSansBold(fontSize: 12),
                  ),
                ],
              ),
            if (provider.typeValue == "cash-flow-statement")
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "BoP",
                    style: stylePTSansBold(fontSize: 12),
                  ),
                  const SpacerHorizontal(width: 10),
                  Text(
                    "${data?.financeStatement?[provider.changePeriodTypeIndex].cashAtBeginningOfPeriod}",
                    style: stylePTSansBold(fontSize: 12),
                  ),
                ],
              ),
          ],
        ),
        const SpacerHorizontal(width: 10),
        Container(
          color: ThemeColors.greyBorder,
          width: 1,
          height: 40,
        ),
        const SpacerHorizontal(width: 10),
        Expanded(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: ScreenUtil().screenWidth * 0.3,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              color: const Color(0xfffed1df),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.sp))),
                          child: Text(
                            textAlign: TextAlign.center,
                            data?.chart?[0].totalAssets != null
                                ? "Liabilities"
                                : data?.chart?[0].revenue != null
                                    ? "Net Income"
                                    : "Investing",
                            style: stylePTSansBold(
                              fontSize: 12,
                              color: const Color(0xfff34e8b),
                            ),
                          ),
                        ),

                        const SpacerVertical(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            data?.financeStatement?[0].totalLiabilities !=
                                        null &&
                                    provider.typeValue ==
                                        "balance-sheet-statement"
                                ? "${data?.financeStatement?[0].totalLiabilities}"
                                : data?.financeStatement?[0].netIncome !=
                                            null &&
                                        provider.typeValue == "income-statement"
                                    ? "${data?.financeStatement?[0].netIncome}"
                                    : "${data?.financeStatement?[0].investingCashFlow}",
                            // "176.7bn",
                            style: stylePTSansBold(fontSize: 20),
                          ),
                        ),
                        const SpacerVertical(height: 10),
                        // Text(
                        //   "60.9%",
                        //   style: stylePTSansBold(fontSize: 12),
                        // ),
                      ],
                    ),
                  ),
                  const SpacerHorizontal(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: ScreenUtil().screenWidth * 0.3,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              color: const Color(0xffdcf5c2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.sp))),
                          child: Text(
                            textAlign: TextAlign.center,
                            data?.chart?[0].totalAssets != null
                                ? "Equity"
                                : data?.chart?[0].ebitda != null
                                    ? "Ebitda"
                                    : "Financing",
                            style: stylePTSansBold(
                              fontSize: 12,
                              color: const Color(0xff76d123),
                            ),
                          ),
                        ),
                        const SpacerVertical(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            data?.financeStatement?[0].ebitda != null &&
                                    provider.typeValue == "income-statement"
                                ? "${data?.financeStatement?[0].ebitda}"
                                : data?.financeStatement?[0].totalEquity !=
                                            null &&
                                        provider.typeValue ==
                                            "balance-sheet-statement"
                                    ? "${data?.financeStatement?[0].totalEquity}"
                                    : "${data?.financeStatement?[0].financingCashFlow}",
                            // "76.7bn",
                            style: stylePTSansBold(fontSize: 20),
                          ),
                        ),
                        const SpacerVertical(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
              if (provider.typeValue == "income-statement")
                const SpacerVertical(height: 5),
              if (provider.typeValue == "income-statement")
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: const Color(0xffc0e7ff), // Top color
                              height: 1,
                            ),
                          ),
                          const SpacerHorizontal(width: 8),
                          Center(
                            child: Text(
                              '${data?.financeStatement?[0].netIncomePerRatio}',
                              style: stylePTSansBold(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpacerHorizontal(width: 10),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: const Color(0xffc0e7ff), // Top color
                              height: 1,
                            ),
                          ),
                          const SpacerHorizontal(width: 8),
                          Center(
                              child: Text(
                            '${data?.financeStatement?[0].eBITDAChangePercentage}',
                            style: stylePTSansBold(fontSize: 12),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              if (provider.typeValue == "balance-sheet-statement")
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double totalWidth = constraints.maxWidth;

                    var financeStatement2 = data?.financeStatement;

                    String width1 = financeStatement2?[0]
                        .totalLiabilitiesChangePercentage
                        .replaceAll('%', '');

                    int pointIndex = width1.indexOf('.');
                    if (pointIndex != -1) {
                      width1 = width1.substring(0, pointIndex);
                    }

                    int intValue = int.parse(width1);

                    String width2 = financeStatement2?[0]
                        .totalEquityChangePercentage
                        .replaceAll('%', '');

                    int pointIndex2 = width2.indexOf('.');
                    if (pointIndex2 != -1) {
                      width2 = width2.substring(0, pointIndex2);
                    }

                    int intValue2 = int.parse(width2);

                    double container1Width = totalWidth * (intValue / 100);
                    double container2Width = totalWidth * (intValue2 / 100);

                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: container1Width,
                              color: const Color(0xfff34e8b),
                              height: 2,
                              child: const Center(child: Text('60.9%')),
                            ),
                            Container(
                              width: container2Width,
                              color: const Color(0xff76d123),
                              height: 2,
                              child: const Center(child: Text('31.0%')),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                width: container1Width,
                                child: Center(
                                    child: Text(
                                  '${data?.financeStatement?[0].totalLiabilitiesChangePercentage}',
                                  style: stylePTSansBold(fontSize: 12),
                                )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                width: container2Width,
                                child: Center(
                                  child: Text(
                                    '${data?.financeStatement?[0].totalEquityChangePercentage}',
                                    style: stylePTSansBold(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              if (provider.typeValue == "cash-flow-statement")
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            Images.tringle,
                            width: 15,
                            height: 15,
                          ),
                          const SpacerHorizontal(width: 10),
                          Text(
                            "${data?.financeStatement?[provider.changePeriodTypeIndex].investingPerRatio}",
                            style: stylePTSansBold(fontSize: 12),
                          )
                        ],
                      ),
                    ),
                    const SpacerHorizontal(width: 20),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "EoP",
                            style: stylePTSansBold(fontSize: 12),
                          ),
                          const SpacerHorizontal(width: 10),
                          Text(
                            "${data?.financeStatement?[provider.changePeriodTypeIndex].cep}",
                            style: stylePTSansBold(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ],
          ),
        )
      ],
    );
  }
}
