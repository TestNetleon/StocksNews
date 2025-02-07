import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../utils/theme.dart';

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
          style: styleGeorgiaRegular(fontSize: 13),
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        const SpacerVertical(height: 5),
        label != "Exp."
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: ThemeColors.greyText, width: 0.5),
                    color: ThemeColors.primary,
                    borderRadius: BorderRadius.circular(14.0)),
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: stylePTSansBold(
                      fontSize: 14,
                      color: (values) > 0
                          ? ThemeColors.themeGreen
                          : (values) == 0
                              ? ThemeColors.white
                              : ThemeColors.darkRed),
                ),
              )
            : Text(
                value,
                style: styleGeorgiaBold(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
      ],
    ));
  }
}
