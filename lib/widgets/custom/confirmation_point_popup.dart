import 'package:flutter/material.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

Future confirmationPopUp({
  num? points,
  String? message,
  String? buttonText,
  Function()? onTap,
}) async {
  await popUpAlert(
    child: Container(
      margin: EdgeInsets.only(top: 10, bottom: 5),
      child: Column(
        children: [
          Visibility(
            visible: points != null,
            child: Text(
              "$points",
              style:
                  stylePTSansBold(color: ThemeColors.background, fontSize: 60),
            ),
          ),
          SpacerVertical(height: 2),
          Text(
            points != null && points > 1 ? "Points" : "Point",
            style: stylePTSansRegular(
              color: ThemeColors.background,
              fontSize: 25,
              height: 0.8,
            ),
          ),
          SpacerVertical(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              message != null && message != ''
                  ? message.toLowerCase()
                  : "required to unlock this.",
              textAlign: TextAlign.center,
              style: stylePTSansRegular(
                fontSize: 16,
                color: ThemeColors.background,
              ),
            ),
          ),
          SpacerVertical(height: 5),
          SizedBox(
            width: double.infinity,
            child: ThemeButtonSmall(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 11,
              ),
              textSize: 15,
              iconFront: true,
              fontBold: true,
              radius: 30,
              icon: Icons.lock,
              onPressed: () async {
                if (onTap != null) {
                  Navigator.pop(navigatorKey.currentContext!);
                  await onTap();
                }
              },
              text: buttonText ?? "CONFIRM AND UNLOCK",
              margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
            ),
          ),
        ],
      ),
    ),
    showOk: false,
    cancel: false,
  );
}
