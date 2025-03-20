import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:provider/provider.dart';
import '../../../utils/theme.dart';
import '../../managers/user.dart';
import '../../utils/colors.dart';

void baseLogout() {
  showDialog(
    context: navigatorKey.currentContext!,
    barrierColor: ThemeColors.white.withValues(alpha: .8),
    builder: (context) {
      return BaseLogoutPopUp();
    },
  );
}

class BaseLogoutPopUp extends StatelessWidget {
  const BaseLogoutPopUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = context.watch<ThemeManager>().isDarkMode;
    return Dialog(
      // backgroundColor: ThemeColors.transparent,
      backgroundColor: ThemeColors.white,
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
                border:
                    isDark ? Border.all(color: ThemeColors.neutral20) : null,
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
                    // const SpacerVertical(height: 5),
                    Text(
                      "Sign Out",
                      style: styleBaseBold(
                        color: ThemeColors.black,
                        fontSize: 20,
                      ),
                    ),
                    const SpacerVertical(height: 8),
                    Text(
                      "Are you sure you want to sign out?",
                      textAlign: TextAlign.center,
                      style: styleBaseRegular(color: ThemeColors.black),
                    ),
                    const SpacerVertical(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "CANCEL",
                            style: styleBaseBold(color: ThemeColors.black),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            UserManager manager = context.read<UserManager>();
                            manager.logoutUser();
                          },
                          child: Text(
                            "LOGOUT",
                            style: styleBaseBold(color: ThemeColors.black),
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
              color: ThemeColors.primary120,
            ),
          ),
        ],
      ),
    );
  }
}
