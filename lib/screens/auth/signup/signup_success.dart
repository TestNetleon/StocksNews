import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:stocks_news_new/widgets/theme_button_outline.dart';

class SignUpSuccess extends StatelessWidget {
  static const String path = "SignUpSuccess";

  const SignUpSuccess({super.key});
//
  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .45,
            child: Image.asset(Images.logo),
          ),
          Padding(
            padding: const EdgeInsets.all(Dimen.authScreenPadding),
            child: Column(
              children: [
                const SpacerVerticel(height: 16),
                Image.asset(
                  Images.signupSuccess,
                  width: ScreenUtil().screenWidth * .5,
                ),
                const SpacerVerticel(),
                Text(
                  "Sign Up Successful.",
                  style: stylePTSansBold(fontSize: 24),
                ),
                const SpacerVerticel(height: Dimen.itemSpacing),
                Text(
                  "Your account has been created, lets start analyze stocks.",
                  style: stylePTSansRegular(
                    fontSize: 14,
                    color: ThemeColors.greyText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SpacerVerticel(),
                ThemeButtonOutlined(
                  onPressed: () {
                    // Navigator.popUntil(context, (route) => route.isFirst);
                    // Navigator.pushReplacementNamed(context, Tabs.path);
                    Navigator.pushNamedAndRemoveUntil(
                        context, Tabs.path, (route) => false);
                  },
                  text: "Home",
                  textStyle: stylePTSansBold(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
