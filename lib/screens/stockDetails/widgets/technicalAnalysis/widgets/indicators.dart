import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/technical_analysis_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/widgets/technicalAnalysis/widgets/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';

class TechnicalAnalystIndicators extends StatelessWidget {
  final BoxConstraints constraints;
  const TechnicalAnalystIndicators({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    MovingAverage? value = context
        .watch<StockDetailProvider>()
        .technicalAnalysisRes
        ?.technicalIndicator;
    if (value == null) return const SizedBox();
    return Column(
      children: [
        Text(
          "Technical Indicators",
          style: stylePTSansBold(fontSize: 13),
        ),
        const SpacerVerticel(height: 10),
        // SizedBox(
        //     height: constraints.maxWidth / 3,
        //     child:
        //         TechnicalAnalysisGaugeItem(value: value.indicater.toDouble())),

        const SpacerVerticel(height: 10),
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 2.sp,
              child: Text(
                "Neutral",
                style: stylePTSansRegular(fontSize: 11),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth * .5,
              height: constraints.maxWidth / 3,
              child:
                  TechnicalAnalysisGaugeItem(value: value.indicater.toDouble()),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Text(
                "Strong Sell",
                style: stylePTSansRegular(fontSize: 11),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Text(
                "Strong Buy",
                style: stylePTSansRegular(fontSize: 11),
              ),
            ),
          ],
        ),
        const SpacerVerticel(height: 10),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.sp),
            color: value.indicater <= -50
                ? ThemeColors.buttonLightRed
                : value.indicater > -50 && value.indicater <= 0
                    ? ThemeColors.buttonBlue
                    : value.indicater > 0 && value.indicater <= 50
                        ? ThemeColors.buttonLightGreen
                        : ThemeColors.buttonLightGreen,
          ),
          padding: EdgeInsets.all(10.sp),
          child: Text(
            value.type,
            style: stylePTSansBold(
              fontSize: 13,
              color: value.indicater <= -50
                  ? ThemeColors.sos
                  : value.indicater > -50 && value.indicater <= 0
                      ? ThemeColors.white
                      : value.indicater > 0 && value.indicater <= 50
                          ? ThemeColors.accent
                          : ThemeColors.accent,
            ),
          ),
        ),
        const SpacerVerticel(height: 10),
        SizedBox(
          width: constraints.maxWidth * .4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Buy: ${value.totalBuy}",
                style: stylePTSansBold(fontSize: 14, color: ThemeColors.accent),
              ),
              Text(
                "Sell: ${value.totalSell}",
                style: stylePTSansBold(fontSize: 14, color: ThemeColors.sos),
              ),
            ],
          ),
        )
      ],
    );
  }
}
