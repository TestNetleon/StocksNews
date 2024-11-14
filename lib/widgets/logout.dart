import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:provider/provider.dart';

import '../../../utils/theme.dart';
import '../utils/colors.dart';

void logoutPopUp({pop = false}) {
  showDialog(
    context: navigatorKey.currentContext!,
    barrierColor: ThemeColors.transparentDark,
    builder: (context) {
      return LogoutPopUpCustom(pop: pop);
    },
  );
}

class LogoutPopUpCustom extends StatelessWidget {
  const LogoutPopUpCustom({
    required this.pop,
    super.key,
  });
  final bool pop;

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
                    // const SpacerVertical(height: 5),
                    Text(
                      "Sign Out",
                      style: stylePTSansBold(
                        color: ThemeColors.background,
                        fontSize: 20,
                      ),
                    ),
                    const SpacerVertical(height: 8),
                    Text(
                      "Are you sure you want to sign out?",
                      textAlign: TextAlign.center,
                      style: stylePTSansRegular(color: ThemeColors.background),
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
                            style:
                                stylePTSansBold(color: ThemeColors.background),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            HomeProvider homeProvider =
                                context.read<HomeProvider>();
                            Map request = {
                              'token':
                                  context.read<UserProvider>().user?.token ??
                                      "",
                            };
                            Navigator.pop(context);
                            // if (pop) Navigator.of(context).pop();
                            await context
                                .read<UserProvider>()
                                .logoutUser(request, pop);
                            homeProvider.getHomeSlider(showProgress: true);
                            homeProvider.getFeaturedWatchlist(userAvail: false);
                          },
                          child: Text(
                            "LOGOUT",
                            style:
                                stylePTSansBold(color: ThemeColors.background),
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
