import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/drawer_res.dart';
import 'package:stocks_news_new/modals/user_res.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/affiliate/pointsTransaction/trasnsaction.dart';
import 'package:stocks_news_new/screens/auth/login/login_sheet_tablet.dart';
import 'package:stocks_news_new/screens/drawer/about/tile.dart';
import 'package:stocks_news_new/screens/drawer/settings/index.dart';
import 'package:stocks_news_new/screens/drawer/widgets/review_app_pop_up.dart';
import 'package:stocks_news_new/screens/faq/index.dart';
import 'package:stocks_news_new/screens/helpDesk/front/index.dart';
import 'package:stocks_news_new/screens/membership/index.dart';
import 'package:stocks_news_new/screens/morningstarTranscations/morningstar_txn.dart';
import 'package:stocks_news_new/screens/myAccount/my_account.dart';
import 'package:stocks_news_new/screens/t&cAndPolicy/tc_policy.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/plaid/portfolio/index.dart';
import 'package:stocks_news_new/screens/tabs/tabs.dart';
import 'package:stocks_news_new/screens/whatWeDo/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/refer.dart';
import 'package:stocks_news_new/widgets/logout.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../utils/constants.dart';
import '../../../utils/theme.dart';
import '../../../widgets/spacer_vertical.dart';
import '../../affiliate/index.dart';
import '../../claimPoints/index.dart';
import '../widgets/drawer_top_new.dart';
import 'refer_dialog.dart';

class AboutStocksNews extends StatefulWidget {
  final String version;
  const AboutStocksNews({super.key, required this.version});

  @override
  State<AboutStocksNews> createState() => _AboutStocksNewsState();
}

class _AboutStocksNewsState extends State<AboutStocksNews> {
  Future _onShareAppClick() async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    if (provider.user == null) {
      // isPhone ? await loginSheet() : await loginSheetTablet();
      await loginSheetTablet();
    }

    if (provider.user == null) {
      return;
    }

    if (provider.user?.affiliateStatus != 1) {
      _bottomSheet();
    } else {
      await Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const ReferAFriend()),
      );
    }
  }

  Future _bottomSheet() async {
    await showModalBottomSheet(
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        // side: const BorderSide(color: ThemeColors.greyBorder),
      ),
      context: navigatorKey.currentContext!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: SingleChildScrollView(child: ReferDialog()),
            ),
            Image.asset(
              Images.kingGIF,
              height: 70,
              width: 100,
              fit: BoxFit.cover,
            ),
          ],
        );
      },
    );
  }

  // Future _helpDesk() async {
  //   UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

  //   if (provider.user == null) {
  //     isPhone ? await loginSheet() : await loginSheetTablet();
  //   }
  //   if (provider.user == null) return;

  //   await Navigator.push(
  //     navigatorKey.currentContext!,
  //     MaterialPageRoute(builder: (_) => const HelpDesk()),
  //   );
  // }

  Future _closeDrawer() async {
    Navigator.pop(navigatorKey.currentContext!);
  }

  @override
  Widget build(BuildContext context) {
    UserRes? user = context.watch<UserProvider>().user;
    HomeProvider provider = context.watch<HomeProvider>();
    List<DrawerRes> visibleAboutTiles = [];

    // My Account is always visible
    visibleAboutTiles.add(
      DrawerRes(
        iconData: Icons.person_2_outlined,
        text: "My Account",
        onTap: () {
          _closeDrawer();
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => const MyAccount()),
          );
        },
      ),
    );
    // My Membership
    if (user != null && user.membership?.purchased == 1 && showMembership) {
      visibleAboutTiles.add(
        DrawerRes(
          iconData: Icons.wallet_membership,
          text: "My Membership",
          onTap: () {
            _closeDrawer();
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => const MembershipIndex()),
            );
          },
        ),
      );
    }
    // Morningstar Reports
    if (provider.extra?.showMorningstar == true) {
      visibleAboutTiles.add(
        DrawerRes(
          iconData: Icons.library_books_sharp,
          text: "MORNINGSTAR Reports",
          onTap: () {
            _closeDrawer();
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => const MorningStarTransaction()),
            );
          },
        ),
      );
    }
    // Always Visible
    if (user != null) {
      visibleAboutTiles.add(
        DrawerRes(
          iconData: Icons.topic_sharp,
          text: "Points Transactions",
          onTap: () {
            _closeDrawer();
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                builder: (context) => const AffiliateTransaction(
                  fromDrawer: true,
                ),
              ),
            );
          },
        ),
      );
    }
    // Portfolio
    if (provider.extra?.showPortfolio == true) {
      visibleAboutTiles.add(
        DrawerRes(
          iconData: Icons.person_pin_outlined,
          text: "Portfolio",
          onTap: () {
            _closeDrawer();
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => const HomePlaidAdded()),
            );
          },
        ),
      );
    }
    // Trading Simulator
    // if (user != null) {
    //   visibleAboutTiles.add(
    //     DrawerRes(
    //       iconData: Icons.bakery_dining_outlined,
    //       text: "Trading Simulator",
    //       onTap: () {
    //         _closeDrawer();
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => const TsDashboard(),
    //           ),
    //         );
    //       },
    //     ),
    //   );
    // }
    // Refer and Earn
    if (provider.extra?.referral?.shwReferral == true) {
      visibleAboutTiles.add(
        DrawerRes(
          iconData: Icons.leaderboard_outlined,
          text: "Refer and Earn",
          onTap: () {
            _closeDrawer();
            _onShareAppClick();
          },
        ),
      );
    }

    if (provider.extra?.showRewards == true) {
      visibleAboutTiles.add(
        DrawerRes(
          iconData: Icons.star,
          text: "Rewards",
          onTap: () {
            _closeDrawer();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClaimPointsIndex(),
              ),
            );
          },
        ),
      );
    }
    if (provider.extra?.notificationSetting == true) {
      visibleAboutTiles.add(
        DrawerRes(
          iconData: Icons.settings,
          text: "Notification Settings",
          onTap: () {
            _closeDrawer();
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                builder: (_) => const NotificationSetting(),
              ),
            );
          },
        ),
      );
    }
    // About Stocks.News
    if (provider.extra?.showAboutStockNews == true) {
      visibleAboutTiles.add(
        DrawerRes(
          iconData: Icons.list_alt_rounded,
          text: "About Stocks.News",
          onTap: () {
            _closeDrawer();
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) {
                return const TCandPolicy(
                  slug: "about-us",
                  policyType: PolicyType.aboutUs,
                );
              }),
            );
          },
        ),
      );
    }
    // What We Do is always visible
    // if (provider.extra?.showWhatWeDo == true) {
    visibleAboutTiles.add(
      DrawerRes(
        iconData: Icons.featured_play_list_outlined,
        text: "What We Do",
        onTap: () {
          _closeDrawer();
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => const WhatWeDoIndex()),
          );
        },
      ),
    );
    // }
    // Helpdesk
    // visibleAboutTiles.add(
    //   DrawerRes(
    //     iconData: Icons.support_agent,
    //     text: "Helpdesk",
    //     onTap: () async {
    //       Navigator.push(
    //         navigatorKey.currentContext!,
    //         MaterialPageRoute(builder: (_) => const HelpDesk()),
    //       );
    //     },
    //   ),
    // );
    visibleAboutTiles.add(
      DrawerRes(
        iconData: Icons.support_agent,
        text: "Helpdesk",
        onTap: () async {
          Navigator.push(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (_) => const HelpDeskNew()),
          );
        },
      ),
    );

    // FAQ is always visible
    if (provider.extra?.showFAQ == true) {
      visibleAboutTiles.add(
        DrawerRes(
          iconData: Icons.help_outline_rounded,
          text: "FAQ",
          onTap: () {
            _closeDrawer();
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (_) => const FAQ()),
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const DrawerTopNew(text: "About Stocks.News"),
              const SpacerVertical(height: 30),
              GestureDetector(
                onTap: () {
                  _closeDrawer();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Tabs()),
                      (route) => false);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.sp),
                    child: Image.asset(
                      Images.stockIcon,
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
              ),
              const SpacerVertical(height: 10),
              Text(
                "Stocks News",
                style: stylePTSansRegular(color: ThemeColors.white),
              ),
              const SpacerVertical(height: 5),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "App Version: ${widget.version}",
                  style: stylePTSansRegular(
                    fontSize: 13,
                    color: ThemeColors.greyText,
                  ),
                ),
              ),
              Visibility(
                visible: context
                        .watch<HomeProvider>()
                        .extra
                        ?.referral
                        ?.shwReferral ??
                    false,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: ReferApp(),
                ),
              ),
              ListView.separated(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 0,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return AboutTile(data: visibleAboutTiles[index]);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox();
                },
                itemCount: visibleAboutTiles.length,
              ),
              // ListView.separated(
              //   padding: const EdgeInsets.only(
              //     left: 10,
              //     right: 10,
              //     top: 0,
              //   ),
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     if (index == 1) {
              //       return Visibility(
              //         visible:
              //             (user != null && user.membership?.purchased == 1) &&
              //                 showMembership,
              //         child: AboutTile(
              //           index: index,
              //           onTap: aboutTiles[index].onTap,
              //         ),
              //       );
              //     }
              //     if (index == 2) {
              //       return Visibility(
              //         visible: provider.extra?.showMorningstar == true,
              //         child: AboutTile(
              //             index: index, onTap: aboutTiles[index].onTap),
              //       );
              //     }
              //     if (index == 3) {
              //       return Visibility(
              //         visible:
              //             context.watch<HomeProvider>().extra?.showPortfolio ??
              //                 false,
              //         child: AboutTile(
              //             index: index, onTap: aboutTiles[index].onTap),
              //       );
              //     }
              //     if (index == 4) {
              //       return Visibility(
              //         visible: context
              //                 .watch<HomeProvider>()
              //                 .extra
              //                 ?.referral
              //                 ?.shwReferral ==
              //             true,
              //         child: AboutTile(
              //           index: index,
              //           onTap: () {
              //             _onShareAppClick();
              //           },
              //         ),
              //       );
              //     }
              //     if (index == 6) {
              //       return AboutTile(
              //         index: index,
              //         onTap: _helpDesk,
              //       );
              //     }
              //     return AboutTile(
              //       index: index,
              //        onTap: aboutTiles[index].onTap,
              //     );
              //   },
              //   separatorBuilder: (context, index) {
              //     return const SizedBox();
              //   },
              //   itemCount: aboutTiles.length,
              // ),
              Visibility(
                  visible: user == null, child: SpacerVertical(height: 30.sp)),
              Visibility(
                visible: user != null,
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 30.sp),
                  child: Column(
                    children: [
                      Ink(
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: Colors.black, width: 3),
                        //   color: Colors.black,
                        //   borderRadius: BorderRadius.circular(50.sp),
                        // ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50.sp),
                          onTap: () {
                            // showDialog(
                            //   context: context,
                            //   builder: (context) {
                            //     return const LogoutDialog();
                            //   },
                            // );
                            logoutPopUp(pop: true);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.sp, vertical: 10.sp),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 2.sp),
                                  child: const Icon(
                                    Icons.logout_outlined,
                                    size: 20,
                                    color: ThemeColors.sos,
                                  ),
                                ),
                                const SpacerHorizontal(width: 20),
                                Expanded(
                                  child: Text(
                                    'Logout',
                                    style: stylePTSansBold(
                                      fontSize: 16,
                                      color: ThemeColors.sos,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Divider(color: ThemeColors.greyBorder, height: 5),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp),

                child: InkWell(
                  onTap: () {
                    if (context.read<UserProvider>().drawerData != null) {
                      showDialog(
                        context: navigatorKey.currentContext!,
                        barrierColor: Colors.black.withOpacity(0.5),
                        builder: (context) {
                          return const ReviewAppPopUp();
                        },
                      );

                      return;
                    }
                    Map request = {
                      "device_type": Platform.isAndroid ? "android" : "ios",
                    };
                    context.read<UserProvider>().getReviewTextDetail(request);

                    // showDialog(
                    //   context: navigatorKey.currentContext!,
                    //   barrierColor: Colors.black.withOpacity(0.5),
                    //   builder: (context) {
                    //     return const ReviewAppPopUp();
                    //   },
                    // );
                  },
                  borderRadius: BorderRadius.circular(4.sp),
                  child: Ink(
                    decoration: BoxDecoration(
                      color: ThemeColors.greyBorder.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4.sp),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        // Image.asset(
                        //   Images.reviews_outlined,
                        //   height: 20,
                        //   width: 20,
                        //   color: ThemeColors.white,
                        // ),
                        const Icon(
                          Icons.reviews_outlined,
                          size: 25,
                          color: ThemeColors.white,
                        ),
                        const SpacerHorizontal(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Review Stocks.News App",
                              style: stylePTSansBold(fontSize: 15),
                            ),
                            const SpacerVertical(height: 3),
                            Text(
                              "If you like our app recommend to others.",
                              style: stylePTSansRegular(
                                  fontSize: 13, color: ThemeColors.greyText),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // child: Row(
                //   children: [
                //     Expanded(
                //       child: Column(
                //         children: [
                //           GestureDetector(
                //             onTap: () {
                //               if (context.read<UserProvider>().drawerData !=
                //                   null) {
                //                 showDialog(
                //                   context: navigatorKey.currentContext!,
                //                   barrierColor: Colors.black.withOpacity(0.5),
                //                   builder: (context) {
                //                     return const ReviewAppPopUp();
                //                   },
                //                 );

                //                 return;
                //               }
                //               Map request = {
                //                 "device_type":
                //                     Platform.isAndroid ? "android" : "ios",
                //               };
                //               context
                //                   .read<UserProvider>()
                //                   .getReviewTextDetail(request);

                //               // showDialog(
                //               //   context: navigatorKey.currentContext!,
                //               //   barrierColor: Colors.black.withOpacity(0.5),
                //               //   builder: (context) {
                //               //     return const ReviewAppPopUp();
                //               //   },
                //               // );
                //             },
                //             child: Container(
                //               padding: EdgeInsets.all(15.sp),
                //               decoration: const BoxDecoration(
                //                   color: Color.fromARGB(255, 36, 36, 36),
                //                   shape: BoxShape.circle),
                //               child: const Icon(
                //                 Icons.reviews_outlined,
                //                 size: 24,
                //               ),
                //             ),
                //           ),
                //           const SpacerVertical(height: 5),
                //           Text(
                //             "Review app",
                //             style: stylePTSansRegular(
                //               color: ThemeColors.greyText,
                //               fontSize: 13,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     Expanded(
                //       child: Column(
                //         children: [
                //           GestureDetector(
                //             onTap: _onShareAppClick,
                //             // onTap: () {
                //             //   commonShare(
                //             //     title: provider.homeSliderRes?.shareText ?? "",
                //             //     url: provider.homeSliderRes?.shareUrl,
                //             //   );
                //             // },
                //             child: Container(
                //               padding: EdgeInsets.all(15.sp),
                //               decoration: const BoxDecoration(
                //                 color: Color.fromARGB(255, 36, 36, 36),
                //                 shape: BoxShape.circle,
                //               ),
                //               child: const Icon(
                //                 Icons.ios_share_outlined,
                //                 size: 24,
                //               ),
                //             ),
                //           ),
                //           const SpacerVertical(height: 5),
                //           Text(
                //             "Share app",
                //             style: stylePTSansRegular(
                //               color: ThemeColors.greyText,
                //               fontSize: 13,
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
              ),
              SpacerVertical(height: 26.sp),
              Align(
                alignment: Alignment.center,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Disclaimer,',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                createRoute(
                                  const TCandPolicy(
                                    policyType: PolicyType.disclaimer,
                                    slug: "disclaimer",
                                  ),
                                ),
                              );
                            },
                          style: stylePTSansRegular(fontSize: 13)),
                      TextSpan(
                          text: ' Privacy Policy ',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                createRoute(
                                  const TCandPolicy(
                                    policyType: PolicyType.privacy,
                                    slug: "privacy-policy",
                                  ),
                                ),
                              );
                            },
                          style: stylePTSansRegular(fontSize: 13)),
                      TextSpan(
                          text: 'and',
                          style: stylePTSansRegular(
                              fontSize: 13, color: ThemeColors.greyText)),
                      TextSpan(
                          text: ' Terms of Service',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                createRoute(
                                  const TCandPolicy(
                                    policyType: PolicyType.tC,
                                    slug: "terms-of-service",
                                  ),
                                ),
                              );
                            },
                          style: stylePTSansRegular(fontSize: 13)),
                    ],
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Scaffold.of(context).closeDrawer();
                        Navigator.push(
                          context,
                          createRoute(
                            const TCandPolicy(
                              policyType: PolicyType.privacy,
                              slug: "privacy-policy",
                            ),
                          ),
                        );
                      },
                    text: "Read our ",
                    style: stylePTSansRegular(
                        fontSize: 13, color: ThemeColors.greyText),
                  ),
                ),
              ),
              const SpacerVertical(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
