import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
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
    return Expanded(
        child: Column(
      children: [
        Text(
          label,
          style: styleBaseRegular(fontSize: 13),
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        const SpacerVertical(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              border: Border.all(width: 0.5),
              color: ThemeColors.black,
              borderRadius: BorderRadius.circular(14.0)),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: label != "Exp."
                ? styleBaseBold(
                    fontSize: 14,
                    color: (values) > 0
                        ? ThemeColors.success120
                        : (values) == 0
                            ? ThemeColors.white
                            : ThemeColors.error120)
                : styleBaseBold(
                    fontSize: 14,
                  ),
          ),
        )
      ],
    ));
  }
}
