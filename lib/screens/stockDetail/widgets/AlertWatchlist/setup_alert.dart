import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_alert_dialog.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class SetupPopup extends StatelessWidget {
  final bool selectedOne, selectedTwo;
  final Widget topTextField;
  final Widget bottomTextField;
  final String text;
  final void Function() onCreateAlert;
//
  const SetupPopup(
      {super.key,
      required this.selectedOne,
      required this.selectedTwo,
      required this.topTextField,
      required this.bottomTextField,
      required this.onCreateAlert,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: closeKeyboard,
        child: ThemeAlertDialog(
          children: [
            _header(context),
            const SpacerVertical(height: 3),
            // Text(
            //   "Setup Alert",
            //   style: stylePTSansBold(),
            // ),
            Divider(
              color: ThemeColors.border.withOpacity(0.4),
              thickness: 1,
              height: 30.sp,
            ),
            Text(
              "Alert Name (Optional)",
              style: stylePTSansRegular(fontSize: 14),
            ),
            const SpacerVertical(height: 5),
            topTextField,
            Divider(
              color: ThemeColors.border.withOpacity(0.4),
              thickness: 1,
              height: 30.sp,
            ),
            // Text(
            //   "Stock",
            //   style: stylePTSansRegular(fontSize: 14),
            // ),
            // const SpacerVertical(height: 5),
            // bottomTextField,
            // Divider(
            //   color: ThemeColors.border.withOpacity(0.4),
            //   thickness: 1,
            //   height: 30.sp,
            // ),
            Row(
              children: [
                Expanded(
                  child: ThemeButton(
                    color: ThemeColors.accent,
                    onPressed: () => Navigator.pop(context),
                    text: "Back",
                    textSize: 12,
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Expanded(
                  child: ThemeButton(
                    color: ThemeColors.accent,
                    onPressed: onCreateAlert,
                    text: "Create Alert",
                    textSize: 12,
                    textColor: selectedOne == false && selectedTwo == false
                        ? ThemeColors.background
                        : Colors.white,
                  ),
                ),
              ],
            ),
            const SpacerVertical(height: 10),
          ],
        ));
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.add_alert_outlined,
                size: 20.sp,
                color: ThemeColors.accent,
              ),
              const SpacerHorizontal(width: 5),
              Flexible(
                child: Text(
                  "Alert for $text",
                  style:
                      stylePTSansBold(color: ThemeColors.accent, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.close, size: 20.sp),
        )
      ],
    );
  }
}
