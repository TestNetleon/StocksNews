import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/tour_user_detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class GridBoxes extends StatelessWidget {
  final Info? info;
  final bool? isNegative;
  final num? valueWithOutSymbol;
  const GridBoxes(
      {super.key, this.info, this.isNegative, this.valueWithOutSymbol});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        TopSnackbar.show(
          message:info?.tooltip ?? "",
          type: ToasterEnum.info,
        );
      },
      child: CommonCard(
          padding:  EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: info?.title != null,
                child: Flexible(
                  child: Text(
                    formatText(info?.title ?? ""),
                    style: styleBaseRegular(fontSize: 12,color: ThemeColors.neutral80),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SpacerVertical(height: Pad.pad10),
              Visibility(
                visible: info?.value != null,
                child: Text(
                  info?.value ?? "",
                  style: isNegative!
                      ? styleBaseBold(
                      fontSize: 22, color: ThemeColors.sos)
                      : styleBaseBold(
                          fontSize: 22,
                          color: (valueWithOutSymbol ?? 0) > 0
                              ? ThemeColors.accent
                              : ThemeColors.black),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),


            ],
          )
      ),
    );
  }

  String formatText(String text) {
    int spaceCount = 0;
    for (int i = 0; i < text.length; i++) {
      if (text[i] == ' ') {
        spaceCount++;
      }
      if (spaceCount == 2) {
        return '${text.substring(0, i)}\n${text.substring(i + 1)}';
      }
    }
    return text;
  }
}
