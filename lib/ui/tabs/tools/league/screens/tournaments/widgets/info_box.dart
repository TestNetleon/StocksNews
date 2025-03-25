import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final num values;
  const InfoBox(
      {super.key,
      required this.label,
      required this.value,
      required this.values});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: styleBaseRegular(fontSize: 13,color: ThemeColors.neutral80),
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        const SpacerVertical(height: Pad.pad10),
        Text(
          value,
          textAlign: TextAlign.center,
          style: label != "Exp."
              ? styleBaseBold(
              fontSize: 14,
              color: (values) > 0
                  ? ThemeColors.accent
                  : (values) == 0
                  ? ThemeColors.white
                  : ThemeColors.sos)
              : styleBaseBold(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
