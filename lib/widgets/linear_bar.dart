import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

class LinearBarCommon extends StatelessWidget {
  final num value;
  final bool showText;
  final bool showAnimation;
  const LinearBarCommon({
    super.key,
    this.value = 0,
    this.showText = true,
    this.showAnimation = true,
  });
//
  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      animation: showAnimation,
      animationDuration: 1000,
      percent: value / 100,
      lineHeight: !isPhone ? 14 : 20,
      barRadius: const Radius.circular(5),
      padding: const EdgeInsets.only(right: 5),
      backgroundColor: ThemeColors.neutral10,
      center: Visibility(
        visible: showText,
        child: Text(
          "$value%",
          style: stylePTSansBold(fontSize: 11, color: ThemeColors.white),
        ),
      ),
      progressColor: value >= 0 && value < 25
          ? ThemeColors.sos
          : value >= 25 && value < 50
              ? Colors.orange
              : value >= 50 && value < 75
                  ? const Color.fromARGB(255, 106, 187, 59)
                  : const Color.fromARGB(255, 13, 126, 68),
    );
  }
}
