import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/providers/blog_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/auth/membershipAsk/ask.dart';
import 'package:stocks_news_new/screens/auth/refer/refer_code.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/service/revenue_cat.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/confirmation_point_popup.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';
import '../../../api/api_response.dart';
import '../../../utils/utils.dart';
import '../../../widgets/custom/warning_text.dart';
import '../../auth/base/base_auth.dart';
import '../../offerMembership/blackFriday/index.dart';
import '../../offerMembership/christmas/index.dart';

class BlogDetailsLock extends StatefulWidget {
  final String? slug;

  const BlogDetailsLock({super.key, this.slug});

  @override
  State<BlogDetailsLock> createState() => _BlogDetailsLockState();
}

class _BlogDetailsLockState extends State<BlogDetailsLock> {
  void _onLoginClick(context) async {
    // await loginSheet();
    await loginFirstSheet();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    BlogProvider provider = Provider.of<BlogProvider>(context, listen: false);
    if (userProvider.user != null) {
      provider.getBlogDetailData(slug: widget.slug);
    }
  }

  Future _onReferClick(BuildContext context) async {
    UserProvider userProvider = context.read<UserProvider>();

    // if (userProvider.user?.phone == null || userProvider.user?.phone == '') {
    if (userProvider.user?.affiliateStatus != 1) {
      await referLogin();
    } else {
      if (userProvider.user != null) {
        await Share.share(
          "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
        );
      }
    }
  }

  Future _onBlogClick(context) async {
    BlogProvider provider = Provider.of<BlogProvider>(context, listen: false);
    confirmationPopUp(
      points: provider.blogsDetail?.pointsRequired,
      message: provider.blogsDetail?.popUpMessage,
      buttonText: provider.blogsDetail?.popUpButton,
      onTap: () async {
        HomeProvider homeProvider =
            Provider.of<HomeProvider>(context, listen: false);
        await provider.getBlogDetailData(
            slug: widget.slug, pointsDeducted: true);

        homeProvider.getHomeSlider();
      },
    );
  }

  Future _membership() async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    Extra? extra = navigatorKey.currentContext!.read<HomeProvider>().extra;
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

      if (extra?.showBlackFriday == true) {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => const BlackFridayMembershipIndex(),
          ),
        );
      } else if (extra?.christmasMembership == true ||
          extra?.newYearMembership == true) {
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
    BlogProvider provider = context.watch<BlogProvider>();
    UserProvider userProvider = context.watch<UserProvider>();

    bool isLogin = userProvider.user != null;
    bool showUpgradeBtn = provider.blogsDetail?.showUpgradeBtn ?? false;
    bool showViewReport = provider.blogsDetail?.balanceStatus ?? false;
    bool showSubscribe = provider.blogsDetail?.showSubscribeBtn ?? false;
    bool isLocked = (provider.blogsDetail?.premiumReaderOnly ?? false) ||
        provider.blogsDetail?.readingStatus == false;

    Utils().showLog("BLOG LOCK => $isLocked  ${!provider.isLoadingDetail}");

    // bool isLogin = userProvider.user != null;
    // bool hasMembership = userProvider.user?.membership?.purchased == 1;
    // bool havePoints = provider.blogsDetail?.totalPoints != null &&
    //     (provider.blogsDetail?.totalPoints > 0);

    // bool haveEnoughPoints = (provider.blogsDetail?.totalPoints == null ||
    //         provider.blogsDetail?.pointsRequired == null)
    //     ? false
    //     : (provider.blogsDetail!.totalPoints! >=
    //         provider.blogsDetail!.pointsRequired!);

    // bool showLoginButton = !isLogin;
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

    double height = (ScreenUtil().screenHeight -
            ScreenUtil().bottomBarHeight -
            ScreenUtil().statusBarHeight) /
        2.2;

    if (isLocked && !provider.isLoadingDetail) {
      // if ((provider.blogsDetail?.readingStatus == false) &&
      //     !provider.isLoadingDetail) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              height: height / 2,
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
            // height: height / 1.1,
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
                    "${provider.blogsDetail?.readingTitle}",
                    style: stylePTSansBold(fontSize: 18),
                  ),
                  const SpacerVertical(height: 10),
                  Text(
                    "${provider.blogsDetail?.readingSubtitle}",
                    style: stylePTSansRegular(
                      fontSize: 14,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SpacerVertical(height: 10),
                  // if (showLoginButton)
                  //   ThemeButtonSmall(
                  //     onPressed: () {
                  //       _onLoginClick(context);
                  //     },
                  //     mainAxisSize: MainAxisSize.max,
                  //     text: "Register/Login to Continue",
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 5,
                  //       vertical: 11,
                  //     ),
                  //     textSize: 15,
                  //     fontBold: true,
                  //     iconFront: true,
                  //     icon: Icons.lock,
                  //     radius: 30,
                  //     margin: const EdgeInsets.only(bottom: 10),
                  //   ),
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
                      mainAxisSize: MainAxisSize.max,
                      onPressed: () => _onBlogClick(context),
                      text: "View Blog",
                      margin: const EdgeInsets.only(bottom: 10),
                    ),
                  // if (showRefer)
                  //   ThemeButtonSmall(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 5,
                  //       vertical: 11,
                  //     ),
                  //     textSize: 15,
                  //     fontBold: true,
                  //     iconWidget: Padding(
                  //       padding: const EdgeInsets.only(right: 10),
                  //       child: Image.asset(
                  //         Images.referAndEarn,
                  //         height: 18,
                  //         width: 18,
                  //         color: ThemeColors.white,
                  //       ),
                  //     ),
                  //     iconFront: true,
                  //     icon: Icons.earbuds_rounded,
                  //     mainAxisSize: MainAxisSize.max,
                  //     radius: 30,
                  //     onPressed: () async {
                  //       await _onReferClick(context);
                  //     },
                  //     text: "Refer and Earn",
                  //     margin: const EdgeInsets.only(bottom: 10),
                  //   ),
                  if (showSubscribe)
                    ThemeButtonSmall(
                      color: const Color.fromARGB(
                        255,
                        194,
                        216,
                        51,
                      ),
                      textColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 11,
                      ),
                      textSize: 15,
                      fontBold: true,
                      iconFront: true,
                      radius: 30,
                      icon: Icons.card_membership,
                      textAlign: TextAlign.start,
                      iconWidget: Padding(
                        padding: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: Image.asset(
                          Images.membership,
                          height: 18,
                          width: 18,
                          color: Colors.black,
                        ),
                      ),
                      mainAxisSize: MainAxisSize.max,
                      onPressed: () async {
                        await _membership();
                      },
                      // text: "Upgrade Membership for more points",
                      text: "Become a Premium Member",
                      showArrow: false,
                      margin: const EdgeInsets.only(bottom: 10),
                    ),
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
                  //       padding: const EdgeInsets.only(right: 10),
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
                  //     margin: const EdgeInsets.only(bottom: 10),
                  //   ),

                  if (showUpgradeBtn)
                    ThemeButtonSmall(
                      color: const Color.fromARGB(
                        255,
                        194,
                        216,
                        51,
                      ),
                      textColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 11,
                      ),
                      textSize: 15,
                      fontBold: true,
                      iconFront: true,
                      radius: 30,
                      icon: Icons.card_membership,
                      textAlign: TextAlign.start,
                      iconWidget: Padding(
                        padding: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: Image.asset(
                          Images.membership,
                          height: 18,
                          width: 18,
                          color: Colors.black,
                        ),
                      ),
                      mainAxisSize: MainAxisSize.max,
                      onPressed: () async {
                        await _membership();
                      },
                      text: "Upgrade Membership",
                      showArrow: false,
                      margin: const EdgeInsets.only(bottom: 10),
                    ),

                  Visibility(
                    visible: !isLogin,
                    child: GestureDetector(
                      onTap: () async {
                        // isPhone ? await loginSheet() : await loginSheetTablet();
                        await loginFirstSheet();
                        if (!isLogin) {
                          return;
                        }
                        Navigator.popUntil(navigatorKey.currentContext!,
                            (route) => route.isFirst);
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
                  ),

                  WarningTextOnLock(
                    warningText: provider.blogsDetail?.warningText,
                  ),
                  SpacerVertical(height: ScreenUtil().scaleWidth + 200),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
