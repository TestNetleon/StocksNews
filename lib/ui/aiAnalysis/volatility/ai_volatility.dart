import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/aiAnalysis/ai.dart';
import 'package:stocks_news_new/models/ai_analysis.dart';
import 'package:stocks_news_new/ui/aiAnalysis/tabs/overview/performance/widgets/container.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';

class AiVolatility extends StatelessWidget {
  const AiVolatility({super.key});

  @override
  Widget build(BuildContext context) {
    AIManager manager = context.watch<AIManager>();
    AIPriceVolatilityRes? priceVolatilityRes = manager.data?.priceVolatility;
    num avg = priceVolatilityRes?.data?.stockVolatility ?? 0;
    // num avg1 = priceVolatilityRes?.data?.avg ?? 0;
    double normalizedPosition = (avg / 100) * ScreenUtil().screenWidth;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 35,
                child: SizedBox(
                  height: 20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //   _chip(),
                      Expanded(
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 24, 189, 33),
                                Colors.yellow,
                                Colors.orange,
                              ],
                            ),
                          ),
                        ),
                      ),
                      //_chip(),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 60,
                left: 0,
                child: Text("Low",
                    style: styleBaseRegular(
                      fontSize: 13,
                      color: ThemeColors.neutral80,
                    )),
              ),
              Positioned(
                top: 60,
                right: 0,
                child: Text("High",
                    style: styleBaseRegular(
                      fontSize: 13,
                      color: ThemeColors.neutral80,
                    )),
              ),
              Positioned(
                left: (ScreenUtil().screenWidth - 30) / 2,
                child: Dash(
                  direction: Axis.vertical,
                  dashLength: 8,
                  dashThickness: 2,
                  dashColor: ThemeColors.splashBG,
                ),
              ),
              Positioned(
                top: 0,
                left: normalizedPosition - 40,
                child: AIPointerContainer(
                  isDownwards: true,
                  title: manager.data?.tickerDetail?.symbol ?? "",
                  style: stylePTSansRegular(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
