import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/database/preference.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../utils/theme.dart';
import '../../utils/colors.dart';
import '../spacer_horizontal.dart';

void appTrack() async {
  final value = await Preference.isTrackingAllowed();
  Utils().showLog('ALLOWED APP TRACK $value');
  if (value != null) return;
  showDialog(
    context: navigatorKey.currentContext!,
    barrierColor: ThemeColors.transparentDark,
    builder: (context) {
      return LogoutPopUpCustom();
    },
  );
}

class LogoutPopUpCustom extends StatelessWidget {
  const LogoutPopUpCustom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ThemeColors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 5.sp),
            child: Container(
              decoration: BoxDecoration(
                color: ThemeColors.white,
                borderRadius: BorderRadius.circular(10.sp),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.sp, 0, 10.sp, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      Images.alertPopGIF,
                      height: 80.sp,
                      width: 80.sp,
                    ),
                    Text(
                      "Help Us Improve Your Experience",
                      textAlign: TextAlign.center,
                      style: stylePTSansBold(
                        color: ThemeColors.background,
                        fontSize: 20,
                      ),
                    ),
                    const SpacerVertical(height: 8),
                    Text(
                      "We value your privacy! Please confirm if you'd like to allow the app to track your activity for personalized experiences.",
                      textAlign: TextAlign.center,
                      style: stylePTSansRegular(color: ThemeColors.background),
                    ),
                    const SpacerVertical(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "No, Thanks",
                            style: stylePTSansBold(
                              color: ThemeColors.background,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        SpacerHorizontal(width: 10),
                        TextButton(
                          onPressed: () async {},
                          child: Text(
                            "Yes, Allow",
                            style: stylePTSansBold(
                              color: ThemeColors.background,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: ScreenUtil().screenWidth / 1.35,
            height: 5.sp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.sp),
                  bottomRight: Radius.circular(10.sp)),
              color: ThemeColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
