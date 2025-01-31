import 'package:flutter/material.dart';
import 'package:stocks_news_new/tournament/models/tour_user_detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class GridBoxs extends StatelessWidget {
  final Info? info;
  final bool? isNegative;
  const GridBoxs({super.key, this.info, this.isNegative});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showSnackbar(
          context: context,
          message: info?.tooltip ?? "",
          type: SnackbarType.info,
        );
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 46, 46, 46),
                ThemeColors.blackShade,
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
                  style:
                  styleGeorgiaBold(fontSize: 18, color: isNegative!? ThemeColors.darkRed:ThemeColors.themeGreen),
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
                    info?.title ?? "",
                    style: styleGeorgiaRegular(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
