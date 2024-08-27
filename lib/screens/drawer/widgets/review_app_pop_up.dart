import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class ReviewAppPopUp extends StatelessWidget {
  const ReviewAppPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    // UserProvider userProvider = context.watch<UserProvider>();
    HomeProvider provider = context.watch<HomeProvider>();

    return Dialog(
      backgroundColor: ThemeColors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
      child: Container(
        decoration: BoxDecoration(
          color: ThemeColors.white,
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 30.sp),
              decoration: BoxDecoration(
                color: ThemeColors.white,
                borderRadius: BorderRadius.circular(10.sp),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Images.appRating,
                    height: 150.sp,
                  ),
                  SpacerVertical(height: 30.sp),
                  Text(
                    provider.homeSliderRes?.rating?.title ??
                        "Love Stocks.news?",
                    style: stylePTSansBold(
                      color: ThemeColors.background,
                      fontSize: 18.sp,
                    ),
                  ),
                  SpacerVertical(height: 20.sp),
                  Text(
                    textAlign: TextAlign.center,
                    provider.homeSliderRes?.rating?.description ??
                        (Platform.isAndroid
                            ? "Please recommend us to\nothers on the Play Store"
                            : "Please recommend us to\nothers on the App Store"),
                    style: stylePTSansRegular(
                      color: ThemeColors.greyText,
                      fontSize: 18.sp,
                    ),
                  ),
                  // Text(
                  //   "other on the App Store",
                  //   style: stylePTSansRegular(
                  //     color: ThemeColors.greyText,
                  //     fontSize: 18.sp,
                  //   ),
                  // ),
                  SpacerVertical(height: 20.sp),
                ],
              ),
            ),
            Divider(
              color: ThemeColors.border,
              height: 1,
            ),
            SpacerVertical(height: 10.sp),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                // openUrl(provider.homeSliderRes?.rating?.url ??
                //     (Platform.isAndroid
                //         ? 'https://play.google.com/store/apps/details?id=com.stocks.news'
                //         : 'https://apps.apple.com/us/app/stocks-news/id6476615803'));

                final InAppReview inAppReview = InAppReview.instance;
                // final SharedPreferences preferences =
                //     await SharedPreferences.getInstance();

                showGlobalProgressDialog();

                if (await inAppReview.isAvailable() &&
                    (provider.homeSliderRes?.rating?.isRating ?? false)) {
                  final int lastReviewTimestamp =
                      await Preference.getMinTimeDifferenceMillis();
                  // preferences.getInt('last_review_timestamp') ?? 0;
                  final int currentTimeMillis =
                      DateTime.now().millisecondsSinceEpoch;
                  const int minTimeDifferenceMillis = 24 * 60 * 60 * 1000;
                  final bool rateLimitPassed =
                      currentTimeMillis - lastReviewTimestamp >
                          minTimeDifferenceMillis;

                  if (rateLimitPassed) {
                    try {
                      closeGlobalProgressDialog();
                      await inAppReview.requestReview();
                      final int currentTimeMillis =
                          DateTime.now().millisecondsSinceEpoch;
                      Preference.saveMinTimeDifferenceMillis(currentTimeMillis);
                    } catch (e) {
                      Utils().showLog("Error requesting review: $e");
                    }
                  } else {
                    closeGlobalProgressDialog();
                    Utils()
                        .showLog("Rate limit for review request not passed.");
                    openUrl(
                      provider.homeSliderRes?.rating?.url ??
                          (Platform.isAndroid
                              ? Const.androidAppUrl
                              : Const.iosAppUrl),
                    );
                  }
                } else {
                  closeGlobalProgressDialog();
                  Utils().showLog(
                      "In-app review not available, opening store listing...");
                  openUrl(
                    provider.homeSliderRes?.rating?.url ??
                        (Platform.isAndroid
                            ? Const.androidAppUrl
                            : Const.iosAppUrl),
                  );
                }
              },
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  textAlign: TextAlign.center,
                  "Rate us",
                  style: stylePTSansBold(
                    color: ThemeColors.darkGreen,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
            SpacerVertical(height: 10.sp),
            Divider(
              color: ThemeColors.border,
              height: 1,
            ),
            SpacerVertical(height: 10.sp),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  textAlign: TextAlign.center,
                  "No, thank you",
                  style: stylePTSansBold(
                    color: ThemeColors.darkGreen,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
            SpacerVertical(height: 10.sp),
          ],
        ),
      ),
    );
  }
}
