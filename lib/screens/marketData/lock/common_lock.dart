import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';

import '../../../providers/user_provider.dart';
import '../../../route/my_app.dart';
import '../../../service/ask_subscription.dart';
import '../../../service/revenue_cat.dart';
import '../../../utils/colors.dart';
import '../../../utils/constants.dart';
import '../../../utils/theme.dart';
import '../../../utils/utils.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../../widgets/theme_button_small.dart';
import '../../auth/login/login_sheet_tablet.dart';
import '../../tabs/tabs.dart';

class CommonLock extends StatelessWidget {
  final bool showLogin;
  final bool isLocked;
  const CommonLock({
    super.key,
    this.showLogin = false,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    double height = (ScreenUtil().screenHeight -
            ScreenUtil().bottomBarHeight -
            ScreenUtil().statusBarHeight) /
        1.3;
    UserProvider provider = context.watch<UserProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            height: height / 2,
            // height: double.infinity,
            // width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  ThemeColors.tabBack,
                ],
              ),
            ),
          ),
        ),
        Container(
          height: height / 1.2,
          // width: double.infinity,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: ThemeColors.tabBack,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 40),
                const SpacerVertical(),
                Text(
                  "Premium Content",
                  style: stylePTSansBold(fontSize: 18),
                ),
                const SpacerVertical(height: 10),
                Text(
                  "This content is only available for premium members. Please become a paid member to access.",
                  style: stylePTSansRegular(
                    fontSize: 14,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SpacerVertical(height: 10),
                ThemeButtonSmall(
                  onPressed: () {
                    askToSubscribe(
                      onPressed: provider.user == null
                          ? () async {
                              Utils().showLog("is Locked? $isLocked");

                              //Ask for LOGIN
                              Navigator.pop(context);
                              isPhone
                                  ? await loginSheet()
                                  : await loginSheetTablet();
                              if (provider.user == null) {
                                return;
                              }
                              if (isLocked) {
                                await RevenueCatService
                                    .initializeSubscription();
                              }
                            }
                          : () async {
                              Navigator.pop(context);
                              if (isLocked) {
                                await RevenueCatService
                                    .initializeSubscription();
                              }
                            },
                    );
                  },
                  text: "Become a Member",
                  showArrow: false,
                ),
                const SpacerVertical(height: 20),
                GestureDetector(
                  onTap: () async {
                    isPhone ? await loginSheet() : await loginSheetTablet();
                    if (provider.user == null) {
                      return;
                    }
                    Navigator.popUntil(
                        navigatorKey.currentContext!, (route) => route.isFirst);
                    Navigator.pushReplacement(
                      navigatorKey.currentContext!,
                      MaterialPageRoute(
                        builder: (_) => const Tabs(index: 0),
                      ),
                    );
                  },
                  child: Text(
                    "Already have an account? Log in",
                    style: stylePTSansRegular(
                      fontSize: 16,
                      height: 1.3,
                      color: ThemeColors.themeGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SpacerVertical(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
