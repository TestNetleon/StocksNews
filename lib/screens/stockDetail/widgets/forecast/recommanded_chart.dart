import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stockDetailRes/analyst_forecast.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class RecommandedForcastingChart extends StatelessWidget {
  const RecommandedForcastingChart({super.key});

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    List<AnalystForecastChart>? data = provider.forecastRes?.chartData;

    return Card(
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.black),
            boxShadow: [
              const BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 1),
                  spreadRadius: 2,
                  blurRadius: 2)
            ]),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recommanded Trend",
              style: stylePTSansBold(fontSize: 16),
            ),
            const SpacerVertical(height: 10),
            ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 0),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        Divider(
                          color: ThemeColors.greyBorder,
                          height: 15.sp,
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 110.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  "Buy",
                                  textAlign: TextAlign.start,
                                  style: stylePTSansBold(
                                    fontSize: 12,
                                    color: ThemeColors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Sell",
                                  textAlign: TextAlign.start,
                                  style: stylePTSansBold(
                                    fontSize: 12,
                                    color: ThemeColors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Hold",
                                  textAlign: TextAlign.start,
                                  style: stylePTSansBold(
                                    fontSize: 12,
                                    color: ThemeColors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: ThemeColors.greyBorder,
                          height: 15.sp,
                          thickness: 1,
                        ),
                        const SpacerVertical(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: 100.sp,
                              child: Text(
                                "${data?[index].period?.capitalize().replaceAll('_', ' ')}",
                                // '1M ago',
                                style: stylePTSansBold(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  LinearPercentIndicator(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Colors.white,
                                    width: 50,
                                    animation: true,
                                    lineHeight: 12.0,
                                    percent: data![index].buy! / 100,
                                    animationDuration: 2000,
                                    linearStrokeCap: LinearStrokeCap.round,
                                    animateFromLastPercent: true,
                                    isRTL: false,
                                    barRadius: const Radius.elliptical(5, 8),
                                    progressColor: Colors.green,
                                    maskFilter: const MaskFilter.blur(
                                        BlurStyle.solid, 3),
                                  ),
                                  const SpacerHorizontal(width: 2),
                                  Text(
                                    textAlign: TextAlign.start,
                                    "${data[index].buy}",
                                    // '0.2',
                                    style: stylePTSansBold(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  LinearPercentIndicator(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Colors.white,
                                    width: 50,
                                    animation: true,
                                    lineHeight: 12.0,
                                    percent: data[index].sell! / 100,
                                    animationDuration: 2000,
                                    linearStrokeCap: LinearStrokeCap.round,
                                    animateFromLastPercent: true,
                                    isRTL: false,
                                    barRadius: const Radius.elliptical(5, 8),
                                    progressColor: Colors.red,
                                    maskFilter: const MaskFilter.blur(
                                        BlurStyle.solid, 3),
                                  ),
                                  const SpacerHorizontal(width: 2),
                                  Text(
                                    textAlign: TextAlign.start,
                                    "${data[index].sell}",
                                    // '0.2',
                                    style: stylePTSansBold(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  LinearPercentIndicator(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Colors.white,
                                    width: 50,
                                    animation: true,
                                    lineHeight: 12.0,
                                    percent: data[index].hold! / 100,
                                    animationDuration: 2000,
                                    linearStrokeCap: LinearStrokeCap.round,
                                    animateFromLastPercent: true,
                                    isRTL: false,
                                    barRadius: const Radius.elliptical(5, 8),
                                    progressColor: Colors.yellow,
                                    maskFilter: const MaskFilter.blur(
                                        BlurStyle.solid, 3),
                                  ),
                                  const SpacerHorizontal(width: 2),
                                  Text(
                                    textAlign: TextAlign.start,
                                    "${data[index].hold}",
                                    // '0.2',
                                    style: stylePTSansBold(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      SizedBox(
                        width: 100.sp,
                        child: Text(
                          data![index]
                              .period!
                              .capitalize()
                              .replaceAll('_', ' '),
                          style: stylePTSansBold(
                              fontSize: 12, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            LinearPercentIndicator(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                              width: 50,
                              animation: true,
                              lineHeight: 12.0,
                              percent: data[index].buy! / 100,
                              animationDuration: 2000,
                              linearStrokeCap: LinearStrokeCap.round,
                              animateFromLastPercent: true,
                              isRTL: false,
                              barRadius: const Radius.elliptical(5, 8),
                              progressColor: Colors.green,
                              maskFilter:
                                  const MaskFilter.blur(BlurStyle.solid, 3),
                            ),
                            const SpacerHorizontal(width: 2),
                            Text(
                              textAlign: TextAlign.start,
                              // '0.5',
                              "${data[index].buy}",
                              style: stylePTSansBold(
                                  fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            LinearPercentIndicator(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                              width: 50,
                              animation: true,
                              lineHeight: 12.0,
                              percent: data[index].sell! / 100,
                              animationDuration: 2000,
                              linearStrokeCap: LinearStrokeCap.round,
                              animateFromLastPercent: true,
                              isRTL: false,
                              barRadius: const Radius.elliptical(5, 8),
                              progressColor: Colors.red,
                              maskFilter:
                                  const MaskFilter.blur(BlurStyle.solid, 3),
                            ),
                            const SpacerHorizontal(width: 2),
                            Text(
                              textAlign: TextAlign.start,
                              "${data[index].sell}",
                              // '0.8',
                              style: stylePTSansBold(
                                  fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            LinearPercentIndicator(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                              width: 50,
                              animation: true,
                              lineHeight: 12.0,
                              percent: data[index].hold! / 100,
                              animationDuration: 2000,
                              linearStrokeCap: LinearStrokeCap.round,
                              animateFromLastPercent: true,
                              isRTL: false,
                              barRadius: const Radius.elliptical(5, 8),
                              progressColor: Colors.yellow,
                              maskFilter:
                                  const MaskFilter.blur(BlurStyle.solid, 3),
                            ),
                            const SpacerHorizontal(width: 2),
                            Text(
                              textAlign: TextAlign.start,
                              "${data[index].hold}",
                              // '0.5',
                              style: stylePTSansBold(
                                  fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  // return const SpacerVertical(height: 10);
                  return Divider(
                    color: ThemeColors.greyBorder,
                    height: 20.sp,
                  );
                },
                itemCount: data?.length ?? 0),
            const SpacerVertical(height: 10),
          ],
        ),
      ),
    );
  }
}
