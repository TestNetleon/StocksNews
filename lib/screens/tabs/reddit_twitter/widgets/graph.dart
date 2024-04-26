import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/reddit_twitter_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SocialSentimentsGraph extends StatelessWidget {
  const SocialSentimentsGraph({super.key});

  @override
  Widget build(BuildContext context) {
    RedditTwitterProvider provider = context.watch<RedditTwitterProvider>();

    String? cVolString =
        provider.socialSentimentRes?.commentVolume.toCurrency();
    String? sTrendString =
        provider.socialSentimentRes?.sentimentTrending.toCurrency();

    num? cVol = provider.socialSentimentRes?.commentVolume;
    num? sTrend = provider.socialSentimentRes?.sentimentTrending;

    num? avgSent = provider.socialSentimentRes?.avgSentiment;

    return Container(
      margin: EdgeInsets.only(top: 20.sp),
      decoration: BoxDecoration(
        // border: Border.all(color: ThemeColors.greyBorder),
        borderRadius: BorderRadius.circular(Dimen.radius.r),
        gradient: const LinearGradient(
          colors: [ThemeColors.background, ThemeColors.accent],
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
      ),
      // padding: EdgeInsets.all(Dimen.padding.sp),
      padding: EdgeInsets.fromLTRB(
        Dimen.padding.sp,
        Dimen.padding.sp,
        Dimen.padding.sp,
        0,
      ),
      child: Column(
        children: [
          Text(
            "Average Market Sentiment",
            style: styleGeorgiaBold(fontSize: 18),
          ),
          const SpacerVerticel(height: 5),
          Text(
            "Current average sentiment across all stocks",
            style: stylePTSansRegular(fontSize: 12, letterSpacing: 0.0),
          ),
          const SpacerVerticel(height: 5),
          Text(
            "See which stocks are bearish vs bullish",
            style: styleGeorgiaBold(
              fontSize: 15,
              decoration: TextDecoration.underline,
            ),
          ),
          const SpacerVerticel(),
          LayoutBuilder(
            builder: (context, constraints) => Container(
              padding: const EdgeInsets.all(0),
              height: constraints.maxWidth / 1.4, // WORKAROUND
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 12.sp,
                    child: Text(
                      "Neutral",
                      style: stylePTSansRegular(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    top: 0,
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          startAngle: 180,
                          endAngle: 0,
                          minimum: -90,
                          interval: 10,
                          maximum: 90,
                          tickOffset: 15,
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
                              value: avgSent?.toDouble() ?? 0, // 0 to max 100
                              needleColor: Colors.white,
                              needleStartWidth: 0,
                              needleEndWidth: 9,
                              needleLength: .7,
                              // tailStyle: TailStyle(color: Colors.white, length: .1, width: 9),
                              knobStyle: const KnobStyle(
                                knobRadius: .06,
                                color: Colors.white,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bearish",
                          style: stylePTSansRegular(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Bullish",
                          style: stylePTSansRegular(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpacerVerticel(height: 5),
                  Text(
                    "Comment Volume",
                    style: stylePTSansRegular(fontSize: 14),
                  ),
                  const SpacerVerticel(height: 5),
                  Row(
                    children: [
                      Icon(
                        (cVol ?? 0) > 0
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color:
                            (cVol ?? 0) > 0 ? ThemeColors.accent : Colors.red,
                        size: 28,
                      ),
                      Text(
                        "${cVolString ?? 0}%",
                        style: stylePTSansBold(fontSize: 22),
                      ),
                    ],
                  ),
                  // const SpacerVerticel(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SpacerVerticel(height: 5),
                  Text(
                    "Sentiment Trending",
                    style: stylePTSansRegular(fontSize: 14),
                  ),
                  const SpacerVerticel(height: 5),
                  Row(
                    children: [
                      Icon(
                        (sTrend ?? 0) > 0
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color:
                            (sTrend ?? 0) > 0 ? ThemeColors.accent : Colors.red,
                        size: 28,
                      ),
                      Text(
                        "${sTrendString ?? 0}%",
                        style: stylePTSansBold(fontSize: 22),
                      ),
                    ],
                  ),
                  // const SpacerVerticel(),
                ],
              )
            ],
          )

          // Stack(
          //   alignment: Alignment.bottomCenter,
          //   children: [
          //     SfRadialGauge(
          //       axes: <RadialAxis>[
          //         RadialAxis(
          //           startAngle: 180,
          //           endAngle: 0,
          //           minimum: 0,
          //           interval: 10,
          //           maximum: 120,
          //           tickOffset: 15,
          //           canScaleToFit: true,
          //           majorTickStyle:
          //               const MajorTickStyle(color: ThemeColors.divider),
          //           minorTickStyle:
          //               const MinorTickStyle(color: ThemeColors.divider),
          //           showLabels: false,
          //           ticksPosition: ElementsPosition.inside,
          //           ranges: <GaugeRange>[
          //             GaugeRange(
          //               startValue: 0,
          //               endValue: 40,
          //               color: Colors.red,
          //               startWidth: 20,
          //               endWidth: 20,
          //             ),
          //             GaugeRange(
          //               startValue: 40,
          //               endValue: 80,
          //               color: Colors.orange,
          //               startWidth: 20,
          //               endWidth: 20,
          //             ),
          //             GaugeRange(
          //               startValue: 80,
          //               endValue: 120,
          //               color: Colors.yellow,
          //               startWidth: 20,
          //               endWidth: 20,
          //             )
          //           ],
          //           pointers: const [
          //             NeedlePointer(
          //               value: 30,
          //               needleColor: Colors.white,
          //               needleStartWidth: 0,
          //               needleEndWidth: 9,
          //               needleLength: .7,
          //               // tailStyle: TailStyle(color: Colors.white, length: .1, width: 9),
          //               knobStyle: KnobStyle(
          //                 knobRadius: .06,
          //                 color: Colors.white,
          //               ),
          //             )
          //           ],
          //         )
          //       ],
          //     ),
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       crossAxisAlignment: CrossAxisAlignment.end,
          //       children: [
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               "Bearish",
          //               style: stylePTSansRegular(fontSize: 18),
          //             ),
          //             const SpacerVerticel(height: 5),
          //             Text(
          //               "Comment Volume",
          //               style: stylePTSansRegular(fontSize: 14),
          //             ),
          //             const SpacerVerticel(height: 5),
          //             Row(
          //               children: [
          //                 const Icon(
          //                   Icons.arrow_drop_down,
          //                   color: Colors.red,
          //                   size: 28,
          //                 ),
          //                 Text(
          //                   "-33.45%",
          //                   style: stylePTSansBold(fontSize: 22),
          //                 ),
          //               ],
          //             ),
          //             const SpacerVerticel(),
          //           ],
          //         ),
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.end,
          //           children: [
          //             Text(
          //               "Bullish",
          //               style: stylePTSansRegular(fontSize: 18),
          //             ),
          //             const SpacerVerticel(height: 5),
          //             Text(
          //               "Comment Volume",
          //               style: stylePTSansRegular(fontSize: 14),
          //             ),
          //             const SpacerVerticel(height: 5),
          //             Row(
          //               children: [
          //                 const Icon(
          //                   Icons.arrow_drop_up,
          //                   color: Colors.green,
          //                   size: 28,
          //                 ),
          //                 Text(
          //                   "-33.45%",
          //                   style: stylePTSansBold(fontSize: 22),
          //                 ),
          //               ],
          //             ),
          //             const SpacerVerticel(),
          //           ],
          //         )
          //       ],
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }
}
