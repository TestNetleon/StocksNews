import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../../../utils/theme.dart';
import '../../../../widget/pointer_container.dart';
import '../index.dart';
import 'title_subtitle.dart';

class MsPerformanceToday extends StatelessWidget {
  const MsPerformanceToday({super.key});
  double _calculatePointerPosition(
    num dayLow,
    num dayHigh,
    num price, {
    num? selfStart,
  }) {
    if (dayHigh == dayLow) {
      return 0.0;
    }
    double progress = (price - dayLow) / (dayHigh - dayLow);
    Utils().showLog("${ScreenUtil().screenWidth * progress}, $progress");
    if (selfStart != null) {
      return selfStart * progress;
    }

    return ScreenUtil().screenWidth * progress;
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    KeyStats? keyStats = provider.tabRes?.keyStats;

    num weekLow = keyStats?.yearLowValue ?? 0;
    num weekHigh = keyStats?.yearHighValue ?? 0;
    num todayLow = keyStats?.dayLowValue ?? 0;
    num todayHigh = keyStats?.dayHighValue ?? 0;
    num currentPrice = keyStats?.priceValue ?? 0;
    String price = keyStats?.price ?? "";

    // num weekLow = 0;
    // num weekHigh = 100;
    // num todayLow = 50;
    // num todayHigh = 60;
    // num currentPrice = 55;
    // String price = "\$$currentPrice";

    double pointerPosition = (currentPrice - weekLow) / (weekHigh - weekLow);
    pointerPosition = pointerPosition.clamp(0.0, 1.0);

    return Column(
      children: [
        MsPerformanceTitleSubtitle(
          leading: "Today's Low",
          trailing: "Today's High",
        ),
        SpacerVertical(height: 8),
        MsPerformanceTitleSubtitle(
          leading: '${keyStats?.dayLow}',
          trailing: '${keyStats?.dayHigh}',
          color: ThemeColors.white,
        ),
        SpacerVertical(
          height: 10,
        ),
        SizedBox(
          height: 70,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                width: ScreenUtil().screenWidth,
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(30),
                  minHeight: 8,
                  value: 1,
                  color: (keyStats?.changesPercentage ?? 0) >= 0
                      ? ThemeColors.accent
                      : ThemeColors.sos,
                ),
              ),
              Positioned(
                top: 12,
                left: _calculatePointerPosition(
                        selfStart: msWidthPadding,
                        todayLow,
                        todayHigh,
                        currentPrice) -
                    20,
                child: MsPointerContainer(
                  style: styleGeorgiaBold(color: ThemeColors.background),
                  title: price,
                  color: (keyStats?.changesPercentage ?? 0) >= 0
                      ? ThemeColors.accent
                      : ThemeColors.sos,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
