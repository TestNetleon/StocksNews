import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/toaster.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/tour_user_detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class GridBoxs extends StatelessWidget {
  final Info? info;
  final bool? isNegative;
  final num? valueWithOutSymbol;
  const GridBoxs(
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
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 46, 46, 46),
                ThemeColors.black,
              ],
            ),
            //color: ThemeColors.gradientLight
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: info?.value != null,
                child: Text(
                  info?.value ?? "",
                  style: isNegative!
                      ? styleBaseBold(
                      fontSize: 18, color: ThemeColors.error120)
                      : styleBaseBold(
                          fontSize: 18,
                          color: (valueWithOutSymbol ?? 0) > 0
                              ? ThemeColors.success120
                              : ThemeColors.white),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SpacerVertical(height: 5),
              Visibility(
                visible: info?.title != null,
                child: Flexible(
                  child: Text(
                    formatText(info?.title ?? ""),
                    style: styleBaseRegular(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )),
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
