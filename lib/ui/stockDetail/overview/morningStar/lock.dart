import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/managers/user.dart';
import 'package:stocks_news_new/models/stockDetail/overview.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SDMorningStarLock extends StatefulWidget {
  const SDMorningStarLock({super.key});

  @override
  State<SDMorningStarLock> createState() => _SDMorningStarLockState();
}

class _SDMorningStarLockState extends State<SDMorningStarLock> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  void _onLoginClick() async {
    UserManager manager = context.read<UserManager>();
    await manager.askLoginScreen();
    if (manager.user == null) {
      return;
    }

    SDManager sdManager = context.read<SDManager>();
    sdManager.getSDOverview(reset: true);
  }

  Future _onViewNewsClick() async {
    SDManager sdManager = context.read<SDManager>();
    await sdManager.getSDOverview(requestAccess: true);
  }

  @override
  Widget build(BuildContext context) {
    SDManager sdManager = context.watch<SDManager>();
    UserManager userManager = context.watch<UserManager>();

    MorningStarLockInfo? lockInformation =
        sdManager.dataOverview?.morningStar?.lockInformation;

    bool showLoginButton = userManager.user == null;
    bool showViewReport = lockInformation?.showViewBtn ?? false;
    bool showSubscribe = lockInformation?.showSubscribeBtn ?? false;
    bool showUpgradeBtn = lockInformation?.showUpgradeBtn ?? false;

    return Container(
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(Pad.pad16, 0, Pad.pad16, Pad.pad16),
      decoration: BoxDecoration(
        // color: ThemeColors.sos,
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color.fromARGB(255, 114, 10, 2),
            Colors.red,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ThemeColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock,
                  size: 40,
                  color: ThemeColors.themeGreen,
                ),
                const SpacerVertical(height: 15),
                Image.asset(
                  Images.morningStarLogo,
                  width: ScreenUtil().screenWidth * .5,
                ),
                const SpacerVertical(),
                Text(
                  lockInformation?.readingTitle ?? '',
                  style: stylePTSansBold(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SpacerVertical(height: 10),
                Text(
                  lockInformation?.readingHeading ?? '',
                  style: stylePTSansRegular(
                    fontSize: 14,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SpacerVertical(height: 10),
                Text(
                  lockInformation?.readingSubtitle ?? '',
                  style: stylePTSansRegular(
                    fontSize: 14,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SpacerVertical(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Login
                    if (showLoginButton)
                      BaseButton(
                        onPressed: _onLoginClick,
                        text: "Register/Login to Continue",
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 11,
                        ),
                        textSize: 15,
                        fontBold: true,
                        radius: 30,
                        margin: const EdgeInsets.only(top: 10),
                      ),

                    // Spend Point and View
                    if (showViewReport)
                      BaseButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 11,
                        ),
                        textSize: 15,
                        fontBold: true,
                        radius: 30,
                        onPressed: _onViewNewsClick,
                        text: "View Research Report",
                        margin: const EdgeInsets.only(top: 10),
                      ),
                    if (showSubscribe)
                      BaseButton(
                        textColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 11,
                        ),
                        textSize: 15,
                        fontBold: true,
                        radius: 30,
                        onPressed: () {
                          context
                              .read<SubscriptionManager>()
                              .startProcess(viewPlans: true);
                        },
                        textAlign: TextAlign.start,
                        text: "Become an Elite Member",
                        margin: const EdgeInsets.only(top: 10),
                      ),
                    if (showUpgradeBtn)
                      BaseButton(
                        textColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 11,
                        ),
                        textSize: 15,
                        fontBold: true,
                        radius: 30,
                        onPressed: () {
                          context
                              .read<SubscriptionManager>()
                              .startProcess(viewPlans: true);
                        },
                        textAlign: TextAlign.start,
                        text: "Upgrade Membership",
                        margin: const EdgeInsets.only(top: 10),
                      ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
