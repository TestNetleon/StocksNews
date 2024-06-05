import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class ReviewAppPopUp extends StatelessWidget {
  const ReviewAppPopUp({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 10.sp),
              decoration: BoxDecoration(
                color: ThemeColors.white,
                borderRadius: BorderRadius.circular(10.sp),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Images.ratingIcon,
                    height: 50.sp,
                    color: ThemeColors.ratingIconColor,
                  ),
                  Image.asset(
                    Images.stockIcon,
                    height: 50.sp,
                  ),
                  SpacerVertical(height: 30.sp),
                  Text(
                    "Stocks News App?",
                    style: stylePTSansBold(
                      color: ThemeColors.background,
                      fontSize: 20.sp,
                    ),
                  ),
                  SpacerVertical(height: 30.sp),
                  Text(
                    "Please recommend us to",
                    style: stylePTSansRegular(
                      color: ThemeColors.greyText,
                      fontSize: 20.sp,
                    ),
                  ),
                  Text(
                    "other on the App Store",
                    style: stylePTSansRegular(
                      color: ThemeColors.greyText,
                      fontSize: 20.sp,
                    ),
                  ),
                  SpacerVertical(height: 30.sp),
                ],
              ),
            ),
            Divider(
              color: ThemeColors.greyBorder,
              height: 1.sp,
            ),
            SpacerVertical(height: 10.sp),
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                openUrl(
                  Platform.isAndroid
                      ? 'https://play.google.com/store/apps/details?id=com.stocks.news'
                      : 'https://apps.apple.com/us/app/stocks-news/id6476615803',
                );
                // final InAppReview inAppReview = InAppReview.instance;

                // log("APp === ${await inAppReview.isAvailable()}");
                // if (await inAppReview.isAvailable()) {
                //   try {
                //     await inAppReview.requestReview();
                //   } catch (e) {
                //     inAppReview.openStoreListing(
                //       appStoreId: 'com.stocks.news',
                //     );
                //   }
                // }
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
              color: ThemeColors.greyBorder,
              height: 1.sp,
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
