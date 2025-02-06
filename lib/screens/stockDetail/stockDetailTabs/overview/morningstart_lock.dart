import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/modals/stockDetailRes/lock_information_res.dart';
import 'package:stocks_news_new/modals/stockDetailRes/morning_start_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/leaderboard.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/auth/membershipAsk/ask.dart';
import 'package:stocks_news_new/screens/auth/refer/refer_code.dart';
import 'package:stocks_news_new/screens/membership/store/store.dart';
import 'package:stocks_news_new/screens/membership_new/membership.dart';
import 'package:stocks_news_new/service/revenue_cat.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

import '../../../../utils/utils.dart';
import '../../../../widgets/custom/confirmation_point_popup.dart';
import '../../../auth/base/base_auth.dart';
import '../../../offerMembership/blackFriday/index.dart';
import '../../../offerMembership/christmas/index.dart';

class SdMorningStarLock extends StatefulWidget {
  final String symbol;
  const SdMorningStarLock({
    super.key,
    required this.symbol,
  });

  @override
  State<SdMorningStarLock> createState() => _SdMorningStarLockState();
}

class _SdMorningStarLockState extends State<SdMorningStarLock> {
  bool userPresent = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForPoints();
    });
  }

  void _checkForPoints() {
    UserProvider userProvider = context.read<UserProvider>();
    if (userProvider.user != null) {
      LeaderBoardProvider lbProvider = context.read<LeaderBoardProvider>();
      if (lbProvider.extra == null) {
        lbProvider.getReferData();
      }
    }
  }

  Future _onReferClick(BuildContext context) async {
    UserProvider userProvider = context.read<UserProvider>();
    if (userProvider.user?.affiliateStatus != 1) {
      // if (userProvider.user?.phone == null || userProvider.user?.phone == '') {
      await referLogin();
    } else {
      if (userProvider.user != null) {
        await Share.share(
          "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
        );
      }
    }
  }

  void _onLoginClick(context) async {
    // await loginSheet();
    await loginFirstSheet();

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    StockDetailProviderNew provider =
        Provider.of<StockDetailProviderNew>(context, listen: false);

    if (userProvider.user != null) {
      provider.getOverviewData(symbol: widget.symbol);
    }
  }

  Future _membership() async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    if (provider.user?.phone == null || provider.user?.phone == '') {
      await membershipLogin();
    }
    if (provider.user?.phone != null && provider.user?.phone != '') {
      // await RevenueCatService.initializeSubscription();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => const NewMembership(),
      //   ),
      // );
      closeKeyboard();
      if (provider.user?.showBlackFriday == true) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => const BlackFridayMembershipIndex(),
          ),
        );
      } else if (provider.user?.christmasMembership == true ||
          provider.user?.newYearMembership == true) {
        Navigator.push(
          navigatorKey.currentContext!,
          createRoute(
            const ChristmasMembershipIndex(),
          ),
        );
      } else {
        subscribe();
        // Navigator.push(
        //   navigatorKey.currentContext!,
        //   MaterialPageRoute(
        //     builder: (context) => const NewMembership(),
        //   ),
        // );
      }
    }
  }

  Future _onViewNewsClick(context) async {
    StockDetailProviderNew provider =
        Provider.of<StockDetailProviderNew>(context, listen: false);

    await provider.getOverviewData(
      symbol: widget.symbol,
      pointsDeducted: false,
      requestAccess: true,
    );

    // confirmationPopUp(
    //   points:
    //       provider.overviewRes?.morningStart?.lockInformation?.pointRequired,
    //   message:
    //       provider.overviewRes?.morningStart?.lockInformation?.popUpMessage,
    //   buttonText:
    //       provider.overviewRes?.morningStart?.lockInformation?.popUpButton,
    //   onTap: () async {
    // HomeProvider homeProvider =
    //     Provider.of<HomeProvider>(context, listen: false);
    // await provider.getOverviewData(symbol: widget.symbol, pointsDeducted: true);
    // homeProvider.getHomeSlider();
    // },
    // );
  }

  // Future _navigateToStore() async {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => const Store(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // bool isLogin = userProvider.user != null;
    // bool hasMembership = userProvider.extra?.user?.membership?.purchased == 1;
    // bool havePoints = provider.data?.postDetail?.totalPoints != null &&
    //     (provider.data?.postDetail?.totalPoints > 0);

    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    UserProvider userProvider = context.watch<UserProvider>();
    // LeaderBoardProvider lbProvider = context.watch<LeaderBoardProvider>();

    // bool isLogin = userProvider.user != null;
    // bool hasMembership = userProvider.user?.membership?.purchased == 1;
    // bool havePoints = lbProvider.extra?.balance != null &&
    //     ((lbProvider.extra?.balance ?? 0) > 0);
    // bool havePoints = morningStar?.lockInformation?.balanceStatus ?? false;
    // bool haveEnoughPoints =
    //     (morningStar?.lockInformation?.totalPoints == null ||
    //             morningStar?.lockInformation?.pointRequired == null)
    //         ? false
    //         : (morningStar!.lockInformation!.totalPoints! >=
    //             morningStar.lockInformation!.pointRequired!);

    // bool showLoginButton = !isLogin;
    // bool showViewReport = isLogin && havePoints && haveEnoughPoints;
    // bool showRefer = isLogin && (!havePoints || !haveEnoughPoints);
    // bool showSubscribe =
    //     isLogin && !hasMembership && showMembership && !havePoints;
    // bool showStore = isLogin && hasMembership && showMembership && !havePoints;

    // bool showViewReport = isLogin && havePoints && haveEnoughPoints;
    // MorningStar? morningStar = provider.overviewRes?.morningStart;
    LockInformation? lockInformation =
        provider.overviewRes?.morningStart?.lockInformation;

    bool showLoginButton = userProvider.user == null;
    bool showViewReport = lockInformation?.showViewBtn ?? false;
    bool showSubscribe = lockInformation?.showSubscribeBtn ?? false;
    bool showUpgradeBtn = lockInformation?.showUpgradeBtn ?? false;

    // bool showViewReport = isLogin && havePoints && haveEnoughPoints;
    // bool showRefer = isLogin && (!havePoints || !haveEnoughPoints);

    // bool showSubscribe = isLogin &&
    //     !hasMembership &&
    //     showMembership &&
    //     (!havePoints || !haveEnoughPoints);

    // bool showStore = isLogin &&
    //     hasMembership &&
    //     showMembership &&
    //     (!havePoints || !haveEnoughPoints);

    // MorningStar? morningStar = provider.overviewRes?.morningStart;
    // bool showReferAndUpgrade =
    //     (morningStar?.lockInformation?.balanceStatus == null ||
    //             morningStar?.lockInformation?.balanceStatus == false) &&
    //         userProvider.user != null;
    // bool showViewOption = userProvider.user != null && !showReferAndUpgrade;

    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        // color: ThemeColors.sos,
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            // Color.fromARGB(255, 2, 71, 12),
            // Color.fromARGB(255, 10, 160, 30),

            Color.fromARGB(255, 114, 10, 2),
            Colors.red,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          // margin: const EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            color: ThemeColors.background,
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
                  // "Quantitative Equity Research Report",
                  "${provider.overviewRes?.morningStart?.lockInformation?.readingTitle}",
                  style: stylePTSansBold(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SpacerVertical(height: 10),
                Text(
                  // "Quantitative Equity Research Report",
                  "Undervalued or Overvalued? Find out if “${widget.symbol}” has 1 star or 5 Stars Today!",
                  style: stylePTSansRegular(
                    fontSize: 14,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SpacerVertical(height: 10),
                Text(
                  "${provider.overviewRes?.morningStart?.lockInformation?.readingSubtitle}",
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
                      ThemeButtonSmall(
                        onPressed: () {
                          _onLoginClick(context);
                        },
                        text: "Register/Login to Continue",
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 11,
                        ),
                        textSize: 15,
                        fontBold: true,
                        iconFront: true,
                        icon: Icons.lock,
                        radius: 30,
                        margin: const EdgeInsets.only(top: 10),
                      ),

                    // Spend Point and View
                    if (showViewReport)
                      ThemeButtonSmall(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 11,
                        ),
                        textSize: 15,
                        iconFront: true,
                        fontBold: true,
                        radius: 30,
                        icon: Icons.visibility,
                        onPressed: () => _onViewNewsClick(context),
                        text: "View Research Report",
                        margin: const EdgeInsets.only(top: 10),
                      ),
                    if (showSubscribe)
                      ThemeButtonSmall(
                        color: const Color.fromARGB(255, 194, 216, 51),
                        textColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 11,
                        ),
                        textSize: 15,
                        fontBold: true,
                        iconWidget: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            Images.membership,
                            height: 20,
                            width: 20,
                          ),
                        ),
                        iconFront: true,
                        radius: 30,
                        icon: Icons.card_membership,
                        onPressed: () async => _membership(),
                        textAlign: TextAlign.start,
                        mainAxisSize: MainAxisSize.max,
                        text: "Become a Premium Member",
                        margin: const EdgeInsets.only(top: 10),
                      ),
                    if (showUpgradeBtn)
                      ThemeButtonSmall(
                        color: const Color.fromARGB(255, 194, 216, 51),
                        textColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 11,
                        ),
                        textSize: 15,
                        fontBold: true,
                        iconWidget: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            Images.membership,
                            height: 20,
                            width: 20,
                          ),
                        ),
                        iconFront: true,
                        radius: 30,
                        icon: Icons.card_membership,
                        onPressed: () async => _membership(),
                        textAlign: TextAlign.start,
                        mainAxisSize: MainAxisSize.max,
                        text: "Upgrade Membership",
                        margin: const EdgeInsets.only(top: 10),
                      ),
                    // Refer
                    // if (showRefer)
                    //   ThemeButtonSmall(
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 5,
                    //       vertical: 11,
                    //     ),
                    //     textSize: 15,
                    //     fontBold: true,
                    //     iconFront: true,
                    //     icon: Icons.earbuds_rounded,
                    //     iconWidget: Padding(
                    //       padding: const EdgeInsets.only(right: 10),
                    //       child: Image.asset(
                    //         Images.referAndEarn,
                    //         height: 18,
                    //         width: 18,
                    //         color: ThemeColors.white,
                    //       ),
                    //     ),
                    //     onPressed: () async {
                    //       await _onReferClick(context);
                    //     },
                    //     text: "Refer and Earn",
                    //     radius: 30,
                    //     margin: const EdgeInsets.only(top: 10),
                    //     // showArrow: false,
                    //   ),
                    // Subscribe

                    // if (showStore)
                    //   ThemeButtonSmall(
                    //     color: const Color.fromARGB(255, 255, 255, 255),
                    //     textColor: Colors.black,
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 5,
                    //       vertical: 7,
                    //     ),
                    //     textSize: 15,
                    //     fontBold: true,
                    //     iconFront: true,
                    //     radius: 30,
                    //     icon: Icons.card_membership,
                    //     textAlign: TextAlign.start,
                    //     iconWidget: Padding(
                    //       padding: const EdgeInsets.only(
                    //         right: 10,
                    //       ),
                    //       child: Image.asset(
                    //         Images.pointIcon3,
                    //         height: 28,
                    //         width: 28,
                    //         // color: Colors.black,
                    //       ),
                    //     ),
                    //     mainAxisSize: MainAxisSize.max,
                    //     onPressed: _navigateToStore,
                    //     text: "Buy Points",
                    //     showArrow: false,
                    //     margin: const EdgeInsets.only(top: 10),
                    //   ),
                  ],
                ),

                // if (userProvider.user == null)
                //   SizedBox(
                //     width: double.infinity,
                //     child: ThemeButtonSmall(
                //       onPressed: () {
                //         _onLoginClick(context);
                //       },
                //       text: "Register/Login to Continue",
                //       padding: const EdgeInsets.symmetric(
                //         horizontal: 5,
                //         vertical: 11,
                //       ),
                //       textSize: 15,
                //       fontBold: true,
                //       iconFront: true,
                //       icon: Icons.lock,
                //       radius: 30,
                //     ),
                //   ),
                // if (showReferAndUpgrade)
                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.stretch,
                //     children: [
                //       ThemeButtonSmall(
                //         padding: const EdgeInsets.symmetric(
                //           horizontal: 5,
                //           vertical: 11,
                //         ),
                //         textSize: 15,
                //         fontBold: true,
                //         iconFront: true,
                //         icon: Icons.earbuds_rounded,
                //         iconWidget: Padding(
                //           padding: const EdgeInsets.only(right: 10),
                //           child: Image.asset(
                //             Images.referAndEarn,
                //             height: 18,
                //             width: 18,
                //             color: ThemeColors.white,
                //           ),
                //         ),
                //         onPressed: () async {
                //           await _onReferClick(context);
                //         },
                //         text: "Refer and Earn",
                //         radius: 30,
                //         // showArrow: false,
                //       ),
                //       const SpacerVertical(height: 10),
                //       Visibility(
                //         visible: showMembership,
                //         child: ThemeButtonSmall(
                //           color: const Color.fromARGB(255, 194, 216, 51),
                //           textColor: Colors.black,
                //           padding: const EdgeInsets.symmetric(
                //             horizontal: 5,
                //             vertical: 11,
                //           ),
                //           textSize: 15,
                //           fontBold: true,
                //           iconWidget: Padding(
                //             padding: const EdgeInsets.only(right: 10),
                //             child: Image.asset(
                //               Images.membership,
                //               height: 20,
                //               width: 20,
                //             ),
                //           ),
                //           iconFront: true,
                //           radius: 30,
                //           icon: Icons.card_membership,
                //           onPressed: () async => _membership(),
                //           textAlign: TextAlign.start,
                //           mainAxisSize: MainAxisSize.max,
                //           text: "Upgrade Membership for more points",
                //           // showArrow: false,
                //         ),
                //       ),
                //     ],
                //   ),
                // if (showViewOption)
                //   Column(
                //     children: [
                //       Container(
                //         width: double.infinity,
                //         margin: const EdgeInsets.only(top: 10),
                //         child: ThemeButtonSmall(
                //           padding: const EdgeInsets.symmetric(
                //             horizontal: 5,
                //             vertical: 11,
                //           ),
                //           textSize: 15,
                //           iconFront: true,
                //           fontBold: true,
                //           radius: 30,
                //           icon: Icons.visibility,
                //           onPressed: () => _onViewNewsClick(context),
                //           text: "View Research Report",
                //         ),
                //       ),
                //       if (!hasMembership && showMembership)
                //         Container(
                //           margin: const EdgeInsets.only(top: 8),
                //           child: ThemeButtonSmall(
                //             margin: const EdgeInsets.only(top: 10),
                //             color: const Color.fromARGB(255, 194, 216, 51),
                //             textColor: Colors.black,
                //             padding: const EdgeInsets.symmetric(
                //               horizontal: 5,
                //               vertical: 11,
                //             ),
                //             textSize: 15,
                //             fontBold: true,
                //             iconWidget: Padding(
                //               padding: const EdgeInsets.only(right: 10),
                //               child: Image.asset(
                //                 Images.membership,
                //                 height: 20,
                //                 width: 20,
                //               ),
                //             ),
                //             iconFront: true,
                //             radius: 30,
                //             icon: Icons.card_membership,
                //             onPressed: () async => _membership(),
                //             textAlign: TextAlign.start,
                //             mainAxisSize: MainAxisSize.max,
                //             text: "Upgrade Membership for more points",
                //             // showArrow: false,
                //           ),
                //         ),
                //     ],
                //   ),
                // const SpacerVertical(),
              ],
            ),
          )),
    );
  }
}
