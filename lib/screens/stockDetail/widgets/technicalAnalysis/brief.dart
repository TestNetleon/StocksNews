import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/technical_analysis_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

//
class SdTechnicalAnalysisBrief extends StatelessWidget {
  const SdTechnicalAnalysisBrief({super.key});

  @override
  Widget build(BuildContext context) {
    TechnicalAnalysisRes? res = context.watch<StockDetailProviderNew>().techRes;
    return Column(
      children: [
        Visibility(
          visible: res?.technicalIndicatorArr.isNotEmpty == true &&
              res?.movingAverageArr.isNotEmpty == true,
          child: Padding(
            padding: EdgeInsets.only(top: 10.sp),
            child: const SummaryBlock(),
          ),
        ),
        Visibility(
          visible: res?.technicalIndicatorArr.isNotEmpty == true,
          child: Padding(
            padding: EdgeInsets.only(top: 10.sp),
            child: const TechnicalIndicatorsBlock(),
          ),
        ),
        Visibility(
          visible: res?.movingAverageArr.isNotEmpty == true,
          child: Padding(
            padding: EdgeInsets.only(top: 10.sp),
            child: const TechnicalMovingAverages(),
          ),
        ),
      ],
    );
  }
}

class SummaryBlock extends StatelessWidget {
  const SummaryBlock({super.key});

  @override
  Widget build(BuildContext context) {
    MovingAverage? summary =
        context.watch<StockDetailProviderNew>().techRes?.summary;

    MovingAverage? movingAverage =
        context.watch<StockDetailProviderNew>().techRes?.movingAverage;

    MovingAverage? technicalIndicator =
        context.watch<StockDetailProviderNew>().techRes?.technicalIndicator;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: ThemeColors.white,
          thickness: 1,
          height: 30.sp,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Summary: ",
                style: stylePTSansBold(
                  fontSize: 16,
                ),
              ),
              TextSpan(
                text: "${summary?.type}",
                style: stylePTSansBold(
                    fontSize: 16,
                    color: summary?.type == "Strong Sell" ||
                            summary?.type == "Sell"
                        ? Colors.red
                        : summary?.type == "Strong Buy" ||
                                summary?.type == "Buy"
                            ? ThemeColors.accent
                            : ThemeColors.blue),
              ),
            ],
          ),
        ),
        const SpacerVertical(height: 10),
        Row(
          children: [
            SizedBox(
              width: 120.sp,
              child: Text(
                "Moving Averages:",
                style: stylePTSansBold(fontSize: 12),
              ),
            ),
            Expanded(
              child: Text(
                textAlign: TextAlign.end,
                "${movingAverage?.type}",
                style: stylePTSansBold(
                  fontSize: 12,
                  color: movingAverage?.type == "Strong Sell" ||
                          movingAverage?.type == "Sell"
                      ? Colors.red
                      : movingAverage?.type == "Strong Buy" ||
                              movingAverage?.type == "Buy"
                          ? ThemeColors.accent
                          : ThemeColors.buttonBlue,
                ),
              ),
            ),
            Expanded(
              child: Text(
                textAlign: TextAlign.end,
                "Buy: ${movingAverage?.totalBuy}",
                style: stylePTSansBold(
                  fontSize: 12,
                  color: ThemeColors.accent,
                ),
              ),
            ),
            Expanded(
              child: Text(
                textAlign: TextAlign.end,
                "Sell: ${movingAverage?.totalSell}",
                style: stylePTSansBold(
                  fontSize: 12,
                  color: ThemeColors.sos,
                ),
              ),
            ),
          ],
        ),
        // const SpacerVertical(height: 10),
        Divider(
          color: ThemeColors.greyBorder,
          height: 20.sp,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 120.sp,
              child: Text(
                "Technical Indicators:",
                style: stylePTSansBold(fontSize: 12),
              ),
            ),
            Expanded(
              child: Text(
                textAlign: TextAlign.end,
                "${technicalIndicator?.type}",
                style: stylePTSansBold(
                  fontSize: 12,
                  color: technicalIndicator?.type == "Strong Sell" ||
                          technicalIndicator?.type == "Sell"
                      ? Colors.red
                      : technicalIndicator?.type == "Strong Buy" ||
                              technicalIndicator?.type == "Buy"
                          ? ThemeColors.accent
                          : ThemeColors.buttonBlue,
                ),
              ),
            ),
            Expanded(
              child: Text(
                textAlign: TextAlign.end,
                "Buy: ${technicalIndicator?.totalBuy}",
                style: stylePTSansBold(
                  fontSize: 12,
                  color: ThemeColors.accent,
                ),
              ),
            ),
            Expanded(
              child: Text(
                textAlign: TextAlign.end,
                "Sell: ${technicalIndicator?.totalSell}",
                style: stylePTSansBold(
                  fontSize: 12,
                  color: ThemeColors.sos,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TechnicalIndicatorsBlock extends StatelessWidget {
  const TechnicalIndicatorsBlock({super.key});

  @override
  Widget build(BuildContext context) {
    List<TechnicalIndicatorArr>? data =
        context.watch<StockDetailProviderNew>().techRes?.technicalIndicatorArr;

    MovingAverage? technicalIndicator =
        context.watch<StockDetailProviderNew>().techRes?.technicalIndicator;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: ThemeColors.white,
          thickness: 1,
          height: 30.sp,
        ),
        Text(
          "Technical Indicators",
          style: stylePTSansBold(fontSize: 16),
        ),
        const SpacerVertical(height: 2),
        data?.isNotEmpty == true
            ? Text(
                "As Per - ${data?[0].date}",
                style: stylePTSansBold(fontSize: 12),
              )
            : const SizedBox(),
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
                    Row(
                      children: [
                        SizedBox(
                          width: 100.sp,
                          child: Text(
                            "NAME",
                            textAlign: TextAlign.start,
                            style: stylePTSansBold(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "VALUE",
                            textAlign: TextAlign.end,
                            style: stylePTSansBold(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "ACTION",
                            textAlign: TextAlign.end,
                            style: stylePTSansBold(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          ),
                        ),
                      ],
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
                            "${data?[index].name}",
                            style: stylePTSansBold(fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.end,
                            "${data?[index].value}",
                            style: stylePTSansBold(fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.end,
                            "${data?[index].action}",
                            style: stylePTSansBold(
                                fontSize: 12,
                                color: data?[index].action == "Sell"
                                    ? ThemeColors.sos
                                    : data?[index].action == "Buy"
                                        ? ThemeColors.accent
                                        : ThemeColors.white),
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
                      "${data?[index].name}",
                      style: stylePTSansBold(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.end,
                      "${data?[index].value}",
                      style: stylePTSansBold(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.end,
                      "${data?[index].action}",
                      style: stylePTSansBold(
                          fontSize: 12,
                          color: data?[index].action == "Sell"
                              ? ThemeColors.sos
                              : data?[index].action == "Buy"
                                  ? ThemeColors.accent
                                  : ThemeColors.white),
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
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Summary: ",
                style: stylePTSansBold(fontSize: 12),
              ),
              TextSpan(
                text: "${technicalIndicator?.type} ",
                style: stylePTSansBold(
                  fontSize: 12,
                  color: technicalIndicator?.type == "Strong Sell" ||
                          technicalIndicator?.type == "Sell"
                      ? ThemeColors.sos
                      : technicalIndicator?.type == "Strong Buy" ||
                              technicalIndicator?.type == "Buy"
                          ? ThemeColors.accent
                          : ThemeColors.buttonBlue,
                ),
              ),
              TextSpan(
                text: "(",
                style: stylePTSansBold(fontSize: 12),
              ),
              TextSpan(
                text: "Buy: ${technicalIndicator?.totalBuy}",
                style: stylePTSansBold(fontSize: 12, color: ThemeColors.accent),
              ),
              TextSpan(
                text: ", ",
                style: stylePTSansBold(fontSize: 12),
              ),
              TextSpan(
                text: "Sell: ${technicalIndicator?.totalSell}",
                style: stylePTSansBold(fontSize: 12, color: ThemeColors.sos),
              ),
              TextSpan(
                text: ")",
                style: stylePTSansBold(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TechnicalMovingAverages extends StatelessWidget {
  const TechnicalMovingAverages({super.key});

  @override
  Widget build(BuildContext context) {
    List<MovingAverageArr>? data =
        context.watch<StockDetailProviderNew>().techRes?.movingAverageArr;
    MovingAverage? movingAverage =
        context.watch<StockDetailProviderNew>().techRes?.movingAverage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: ThemeColors.white,
          thickness: 1,
          height: 30.sp,
        ),
        Text(
          "Moving Averages",
          style: stylePTSansBold(fontSize: 16),
        ),
        const SpacerVertical(height: 2),
        data?.isNotEmpty == true
            ? Text(
                "As Per - ${data?[0].date}",
                style: stylePTSansBold(fontSize: 12),
              )
            : const SizedBox(),
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
                    Row(
                      children: [
                        SizedBox(
                          child: Text(
                            "NAME",
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            style: stylePTSansBold(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            maxLines: 1,
                            "SIMPLE",
                            textAlign: TextAlign.end,
                            style: stylePTSansBold(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            maxLines: 1,
                            "EXPONENTIAL",
                            textAlign: TextAlign.end,
                            style: stylePTSansBold(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            maxLines: 1,
                            "WEIGHTED",
                            textAlign: TextAlign.end,
                            style: stylePTSansBold(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: ThemeColors.greyBorder,
                      height: 15.sp,
                      thickness: 1,
                    ),
                    const SpacerVertical(height: 10),
                    Row(
                      children: [
                        Text(
                          "${data?[index].name}",
                          style: stylePTSansBold(fontSize: 12),
                        ),
                        _item(
                          subText: "${data?[index].smaStatus}",
                          text: "${data?[index].smaNew}",
                        ),
                        _item(
                          subText: "${data?[index].emaStatus}",
                          text: "${data?[index].emaNew}",
                        ),
                        _item(
                          subText: "${data?[index].wmaStatus}",
                          text: "${data?[index].wmaNew}",
                        ),
                      ],
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Text(
                    "${data?[index].name}",
                    style: stylePTSansBold(fontSize: 12),
                  ),
                  _item(
                    subText: "${data?[index].smaStatus}",
                    text: "${data?[index].smaNew}",
                  ),
                  _item(
                    subText: "${data?[index].emaStatus}",
                    text: "${data?[index].emaNew}",
                  ),
                  _item(
                    subText: "${data?[index].wmaStatus}",
                    text: "${data?[index].wmaNew}",
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
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Summary: ",
                style: stylePTSansBold(fontSize: 12),
              ),
              TextSpan(
                text: "${movingAverage?.type} ",
                style: stylePTSansBold(
                  fontSize: 12,
                  color: movingAverage?.type == "Strong Sell" ||
                          movingAverage?.type == "Sell"
                      ? ThemeColors.sos
                      : movingAverage?.type == "Strong Buy" ||
                              movingAverage?.type == "Buy"
                          ? ThemeColors.accent
                          : ThemeColors.buttonBlue,
                ),
              ),
              TextSpan(
                text: "(",
                style: stylePTSansBold(fontSize: 12),
              ),
              TextSpan(
                text: "Buy: ${movingAverage?.totalBuy}",
                style: stylePTSansBold(fontSize: 12, color: ThemeColors.accent),
              ),
              TextSpan(
                text: ", ",
                style: stylePTSansBold(fontSize: 12),
              ),
              TextSpan(
                text: "Sell: ${movingAverage?.totalSell}",
                style: stylePTSansBold(fontSize: 12, color: ThemeColors.sos),
              ),
              TextSpan(
                text: ")",
                style: stylePTSansBold(fontSize: 12),
              ),
            ],
          ),
        ),
        // Divider(
        //   color: ThemeColors.white,
        //   thickness: 1,
        //   height: 30.sp,
        // ),
      ],
    );
  }

  Widget _item({required String text, required String subText}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            text,
            style: stylePTSansBold(fontSize: 12),
          ),
          Text(
            subText,
            style: stylePTSansBold(
              fontSize: 11,
              color: subText == "Sell"
                  ? ThemeColors.sos
                  : subText == "Buy"
                      ? ThemeColors.accent
                      : ThemeColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
