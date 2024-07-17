import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stocks_news_new/providers/blog_provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet.dart';
import 'package:stocks_news_new/screens/auth/membershipAsk/ask.dart';
import 'package:stocks_news_new/screens/auth/refer/refer_code.dart';
import 'package:stocks_news_new/screens/membership/store/store.dart';
import 'package:stocks_news_new/screens/membership_new/membership.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

class BlogDetailsLock extends StatefulWidget {
  final String? slug;

  const BlogDetailsLock({super.key, this.slug});

  @override
  State<BlogDetailsLock> createState() => _BlogDetailsLockState();
}

class _BlogDetailsLockState extends State<BlogDetailsLock> {
  void _onLoginClick(context) async {
    await loginSheet();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    BlogProvider provider = Provider.of<BlogProvider>(context, listen: false);
    if (userProvider.user != null) {
      provider.getBlogDetailData(slug: widget.slug);
    }
  }

  Future _onReferClick(BuildContext context) async {
    UserProvider userProvider = context.read<UserProvider>();

    if (userProvider.user?.phone == null || userProvider.user?.phone == '') {
      await referLogin();
    } else {
      if (userProvider.user != null) {
        await Share.share(
          "${navigatorKey.currentContext!.read<HomeProvider>().extra?.referral?.shareText}${"\n\n"}${shareUri.toString()}",
        );
      }
    }
  }

  void _onViewNewsClick(context) async {
    BlogProvider provider = Provider.of<BlogProvider>(context, listen: false);
    await provider.getBlogDetailData(slug: widget.slug, pointsDeducted: true);
  }

  Future _membership() async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();
    if (provider.user?.phone == null || provider.user?.phone == '') {
      await membershipLogin();
    }
    if (provider.user?.phone != null && provider.user?.phone != '') {
      // await RevenueCatService.initializeSubscription();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const NewMembership(),
        ),
      );
    }
  }

  Future _navigateToStore() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const Store(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BlogProvider provider = context.watch<BlogProvider>();
    UserProvider userProvider = context.watch<UserProvider>();

    bool isLogin = userProvider.user != null;
    bool hasMembership = userProvider.user?.membership?.purchased == 1;
    bool havePoints = provider.blogsDetail?.totalPoints != null &&
        (provider.blogsDetail?.totalPoints > 0);

    double height = (ScreenUtil().screenHeight -
            ScreenUtil().bottomBarHeight -
            ScreenUtil().statusBarHeight) /
        2.2;

    if ((provider.blogsDetail?.readingStatus == false) &&
        !provider.isLoadingDetail) {
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
              height: height / 1.2,
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
                    if (!isLogin)
                      ThemeButtonSmall(
                        onPressed: () {
                          _onLoginClick(context);
                        },
                        mainAxisSize: MainAxisSize.max,
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
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                    if (isLogin && havePoints)
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
                        onPressed: () => _onViewNewsClick(context),
                        text: "View News",
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                    if (isLogin && !havePoints)
                      ThemeButtonSmall(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 11,
                        ),
                        textSize: 15,
                        fontBold: true,
                        iconWidget: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            Images.referAndEarn,
                            height: 18,
                            width: 18,
                            color: ThemeColors.white,
                          ),
                        ),
                        iconFront: true,
                        icon: Icons.earbuds_rounded,
                        mainAxisSize: MainAxisSize.max,
                        radius: 30,
                        onPressed: () async {
                          await _onReferClick(context);
                        },
                        text: "Refer and Earn",
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                    if (isLogin && !hasMembership && showMembership)
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
                            color: ThemeColors.white,
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
                    if (isLogin &&
                        !havePoints &&
                        hasMembership &&
                        showMembership)
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
                            color: ThemeColors.white,
                          ),
                        ),
                        mainAxisSize: MainAxisSize.max,
                        onPressed: _navigateToStore,
                        text: "Points Central",
                        showArrow: false,
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                  ],
                ),
              )),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
