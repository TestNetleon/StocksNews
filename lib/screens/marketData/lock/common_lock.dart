import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/colors.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../../widgets/theme_button_small.dart';

class CommonLock extends StatelessWidget {
  final Function() onPressed;
  const CommonLock({super.key, required this.onPressed});

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
                  onPressed: onPressed,
                  text: "Become a Member",
                  showArrow: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
