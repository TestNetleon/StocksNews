import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button.dart';

class SignUpSuccess extends StatelessWidget {
  static const String path = "SignUpSuccess";

  const SignUpSuccess({super.key});
//
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
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
                const SpacerVertical(height: 16),
                Image.asset(
                  Images.referSuccess,
                  // width: ScreenUtil().screenWidth * .5,
                ),
                const SpacerVertical(),
                Text(
                  userProvider.user?.signUpSuccessful ?? "SUCCESS",
                  style: stylePTSansBold(fontSize: 24),
                ),
                const SpacerVertical(height: Dimen.itemSpacing),
                Text(
                  userProvider.user?.yourAccountHasBeenCreated ??
                      "You have successfully registered to Stocks.news, please explore the best stock",
                  style: stylePTSansRegular(
                    fontSize: 16,
                    color: ThemeColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SpacerVertical(),
                ThemeButton(
                  onPressed: () {
                    // Navigator.popUntil(context, (route) => route.isFirst);
                    // Navigator.pushReplacementNamed(context, Tabs.path);
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Tabs.path,
                      arguments: {"showRef": true},
                      (route) => false,
                    );
                  },
                  text: "Get Start",
                  // textStyle: stylePTSansBold(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
