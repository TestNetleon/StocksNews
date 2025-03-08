import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/managers/referral/referral_manager.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class ReferralHeader extends StatelessWidget {
  const ReferralHeader({super.key});

  void _shareApp(BuildContext context) async {
    ReferralManager manager = context.read<ReferralManager>();
    UserManager userManager = context.read<UserManager>();

    //  UserProvider userProvider = context.read<UserProvider>();
    // if (userProvider.user?.phone == null || userProvider.user?.phone == '') {
    if (manager.data?.referralStatus != 1 && userManager.user == null) {
      // await referLogin();
      await userManager.askLoginScreen();
    } else {
      await Share.share(
        "${"shareText"}${"\n\n"}${shareUri.toString()}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ReferralManager manager = context.watch<ReferralManager>();
    UserManager userManager = context.watch<UserManager>();
    return Padding(
      padding: EdgeInsets.all(Dimen.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            manager.data?.title ?? "",
            style: styleBaseBold(fontSize: 26, height: 1.25),
          ),
          SpacerVertical(height: 4),
          HtmlWidget(
            manager.data?.subTitle ?? "",
            textStyle: styleBaseRegular(
              fontSize: 16,
              color: ThemeColors.neutral80,
              height: 1.4,
            ),
          ),
          SpacerVertical(height: 24),
          BaseBorderContainer(
            padding: EdgeInsets.zero,
            color: ThemeColors.secondary100,
            child: Column(
              children: [
                Text(
                  "Your Referral Code",
                  style: styleBaseRegular(
                    fontSize: 14,
                    color: ThemeColors.gray2,
                  ),
                ),
                SpacerVertical(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${userManager.user?.referralCode}",
                      style: styleBaseBold(
                        fontSize: 20,
                        color: ThemeColors.white,
                      ),
                    ),
                    Image.asset(
                      Images.copy,
                      width: 17,
                    )
                  ],
                ),
                SpacerVertical(height: 8),
                Text(
                  "$shareUri",
                  style: styleBaseRegular(
                    fontSize: 14,
                    color: ThemeColors.white,
                  ),
                ),
                SpacerVertical(height: 14),
                BaseButton(
                  onPressed: () => _shareApp(context),
                  text: "Share with Friends",
                  color: ThemeColors.white,
                  textStyle: styleBaseBold(
                    fontSize: 16,
                    color: ThemeColors.secondary100,
                  ),
                  padding: EdgeInsets.all(12),
                )
              ],
            ),
          ),
          SpacerVertical(height: Dimen.padding),
          Text(
            manager.data?.pointsSummary?.title ?? "",
            style: styleBaseBold(fontSize: 20, height: 1.25),
          ),
          SpacerVertical(height: Dimen.padding),
        ],
      ),
    );
  }
}
