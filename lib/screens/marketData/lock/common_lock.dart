import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../../widgets/theme_button_small.dart';

class CommonLock extends StatelessWidget {
  final Function() onMembershipClick;
  final Function() onLoginClick;
  final bool showLogin;
  const CommonLock({
    super.key,
    required this.onMembershipClick,
    required this.onLoginClick,
    this.showLogin = false,
  });

  @override
  Widget build(BuildContext context) {
    double height = (ScreenUtil().screenHeight -
            ScreenUtil().bottomBarHeight -
            ScreenUtil().statusBarHeight) /
        1.3;

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
                  onPressed: onMembershipClick,
                  text: "Become a Member",
                  showArrow: false,
                ),
                const SpacerVertical(height: 20),
                GestureDetector(
                  onTap: onLoginClick,
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
