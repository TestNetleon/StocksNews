import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../managers/signals.dart';

class SignalsSentimentGauge extends StatelessWidget {
  const SignalsSentimentGauge({super.key});

  @override
  Widget build(BuildContext context) {
    SignalsManager manager = context.watch<SignalsManager>();

    num? cVol = manager.signalSentimentData?.sentiment?.commentVolume ?? 0;
    num? sTrend =
        manager.signalSentimentData?.sentiment?.sentimentTrending ?? 0;

    num? avgSent = manager.signalSentimentData?.sentiment?.avgSentiment ?? 0;

    return Container(
      margin: EdgeInsets.only(top: isPhone ? 0.sp : 10.sp),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxWidth / 1.5,
                child: Stack(
                  children: [
                    Positioned(
                      top: 30,
                      right: 40,
                      left: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Neutral Low',
                            style: styleBaseRegular(),
                          ),
                          Text(
                            'Neutral High',
                            style: styleBaseRegular(),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 40,
                      left: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bearish',
                            style: styleBaseRegular(),
                          ),
                          Text(
                            'Bullish',
                            style: styleBaseRegular(),
                          ),
                        ],
                      ),
                    ),
                    SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          startAngle: 180,
                          endAngle: 0,
                          minimum: -90,
                          interval: 10,
                          maximum: 90,
                          canScaleToFit: true,
                          majorTickStyle:
                              const MajorTickStyle(color: ThemeColors.divider),
                          minorTickStyle:
                              const MinorTickStyle(color: ThemeColors.divider),
                          showLabels: false,
                          ticksPosition: ElementsPosition.inside,
                          ranges: <GaugeRange>[
                            GaugeRange(
                              startValue: -90,
                              endValue: -45,
                              color: Colors.red,
                              startWidth: 20,
                              endWidth: 20,
                            ),
                            GaugeRange(
                              startValue: -45,
                              endValue: 0,
                              color: Colors.orange,
                              startWidth: 20,
                              endWidth: 20,
                            ),
                            GaugeRange(
                              startValue: 0,
                              endValue: 45,
                              color: Colors.yellow,
                              startWidth: 20,
                              endWidth: 20,
                            ),
                            GaugeRange(
                              startValue: 45,
                              endValue: 90,
                              color: Colors.green,
                              startWidth: 20,
                              endWidth: 20,
                            )
                          ],
                          pointers: [
                            NeedlePointer(
                              value: avgSent.toDouble(),
                              needleColor: ThemeColors.black,
                              needleStartWidth: 0,
                              needleEndWidth: 9,
                              needleLength: .7,
                              knobStyle: const KnobStyle(
                                knobRadius: .06,
                                color: ThemeColors.black,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Image.asset(
                              cVol >= 0
                                  ? Images.trendingUP
                                  : Images.trendingDOWN,
                              height: 28,
                              width: 28,
                              color: cVol >= 0
                                  ? ThemeColors.accent
                                  : ThemeColors.sos,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: '$cVol%',
                          style: styleBaseBold(
                            fontSize: 18,
                            color: cVol >= 0
                                ? ThemeColors.accent
                                : ThemeColors.sos,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Comment Volume',
                    style: styleBaseRegular(fontSize: 13),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Image.asset(
                              sTrend >= 0
                                  ? Images.trendingUP
                                  : Images.trendingDOWN,
                              height: 28,
                              width: 28,
                              color: sTrend >= 0
                                  ? ThemeColors.accent
                                  : ThemeColors.sos,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: '$sTrend%',
                          style: styleBaseBold(
                            fontSize: 18,
                            color: sTrend >= 0
                                ? ThemeColors.accent
                                : ThemeColors.sos,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Sentiment Trading',
                    style: styleBaseRegular(fontSize: 13),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
