import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

//
class UpdateError extends StatelessWidget {
  const UpdateError({
    this.error,
    this.onRefresh,
    this.state,
    this.smallHeight = false,
    super.key,
    this.title,
  });
  final String? error;
  final String? state;
  final Function()? onRefresh;
  final bool smallHeight;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().screenWidth,
      height: smallHeight
          ? ScreenUtil().screenHeight * .4
          : ScreenUtil().screenHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  // visible: title != null && title != '',
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      "Update App!",
                      style: stylePTSansBold(fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Visibility(
                  // visible: title != null && title != '',
                  child: Text(
                    error ?? "",
                    style: stylePTSansRegular(fontSize: 19),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SpacerVertical(height: 10),
                ThemeButtonSmall(
                  onPressed: () {
                    try {
                      String url = Platform.isAndroid
                          ? "https://play.google.com/store/apps/details?id=com.stocks.news"
                          : "https://apps.apple.com/us/app/stocks-news-market-alerts/id6476615803";
                      openUrl(url);
                    } catch (e) {
                      //
                    }
                  },
                  text: "Update to latest app version",
                  iconFront: true,
                  icon: Icons.update,
                  radius: 30,
                  mainAxisSize: MainAxisSize.max,
                  textSize: 15,
                  fontBold: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 11,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(15),
                //   child: Align(
                //     alignment: Alignment.center,
                //     child: GestureDetector(
                //         onTap: () async {
                //           Navigator.pop(context);
                //           isPhone
                //               ? await signupSheet()
                //               : await signupSheetTablet();
                //         },
                //         child: Text(
                //           "Don't have an account? Sign up ",
                //           style: stylePTSansRegular(
                //             fontSize: 18,
                //             color: ThemeColors.accent,
                //           ),
                //         )),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
