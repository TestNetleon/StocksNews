import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/benefits_analysis.dart';

import '../../../../../utils/colors.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/theme.dart';
import '../../../../../widgets/spacer_vertical.dart';

class BenefitsBanner extends StatelessWidget {
  final BannerRes? banner;
  final bool isSpend;
  const BenefitsBanner({super.key, this.banner, this.isSpend = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Image.asset(
            Images.reward,
            height: 80.0,
            width: 100.0,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: banner?.title != null && banner?.title != '',
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: const [0.3, 0.65],
                          colors: isSpend
                              ? [
                                  // const Color.fromARGB(255, 204, 56, 19),
                                  Colors.transparent,
                                  const Color.fromARGB(255, 167, 29, 4),
                                ]
                              : [
                                  // const Color.fromARGB(255, 32, 128, 65),
                                  Colors.transparent,
                                  const Color.fromARGB(255, 11, 90, 38),
                                ],
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        banner?.title ?? "",
                        style: stylePTSansRegular(
                          color: ThemeColors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ),
                const SpacerVertical(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    banner?.subTitle ?? "",
                    style: stylePTSansRegular(
                      color:
                          isSpend ? ThemeColors.white : ThemeColors.lightGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SpacerVertical(height: 10),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 5.0,
                    right: 25.0,
                  ),
                  child: Text(
                    banner?.text ?? "",
                    style: stylePTSansRegular(
                      color: ThemeColors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SpacerVertical(height: 8),
              ],
            ),
          ),
        )
      ],
    );
  }
}
