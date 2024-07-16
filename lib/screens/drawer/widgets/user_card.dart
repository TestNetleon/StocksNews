import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/membership/index.dart';
import 'package:stocks_news_new/screens/membership_new/membership.dart';
import 'package:stocks_news_new/service/ask_subscription.dart';
import 'package:stocks_news_new/service/revenue_cat.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../providers/leaderboard.dart';
import '../../../utils/colors.dart';

import '../../../utils/constants.dart';
import '../../auth/membershipAsk/ask.dart';
import '../../myAccount/widgets/my-account_header.dart';
import 'profile_image.dart';

class UserCard extends StatefulWidget {
  final Function()? onTap;
  const UserCard({super.key, this.onTap});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  PurchasesConfiguration? configuration;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  _callAPI() {
    LeaderBoardProvider provider = context.read<LeaderBoardProvider>();
    provider.getReferData(checkAppUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    Utils().showLog("$showMembership");
    return Column(
      children: [
        Stack(
          children: [
            Container(
              margin: showMembership
                  ? EdgeInsets.only(
                      bottom: userProvider.user?.membership?.purchased == 1
                          ? 0
                          : 50)
                  : null,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ThemeColors.greyBorder.withOpacity(0.2),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: widget.onTap,
                        child: ProfileImage(
                          url: userProvider.user?.image,
                          showCameraIcon: false,
                          imageSize: 70,
                          roundImage: false,
                        ),
                      ),
                      const SpacerHorizontal(width: 10),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: widget.onTap,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userProvider.user?.name?.isNotEmpty == true
                                    ? "${userProvider.user?.name}"
                                    : "Hello",
                                style: stylePTSansBold(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                userProvider.user?.email?.isNotEmpty == true
                                    ? "${userProvider.user?.email}"
                                    : "",
                                style: stylePTSansRegular(
                                    color: ThemeColors.greyText, fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: MyVerifiedCard(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: showMembership,
                    child: const Divider(
                      color: ThemeColors.greyBorder,
                      height: 30,
                    ),
                  ),
                  Visibility(
                    visible: showMembership,
                    child: InkWell(
                      onTap: userProvider.user?.membership?.purchased == 1
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const MembershipIndex();
                                  },
                                ),
                              );
                            }
                          : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Current Plan",
                            style: stylePTSansBold(fontSize: 18),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: ThemeColors.white,
                              border: Border(
                                bottom: BorderSide(
                                    color: userProvider
                                                .user?.membership?.purchased ==
                                            1
                                        ? const Color.fromARGB(255, 253, 245, 4)
                                        : const Color.fromARGB(
                                            255, 113, 113, 113),
                                    width: 1.2),
                              ),
                              gradient: LinearGradient(
                                colors: userProvider
                                            .user?.membership?.purchased ==
                                        1
                                    ? [
                                        const Color.fromARGB(255, 242, 234, 12),
                                        const Color.fromARGB(255, 186, 181, 53),
                                      ]
                                    : [
                                        Colors.white,
                                        Colors.grey,
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 0,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 1),
                                  color: userProvider
                                              .user?.membership?.purchased ==
                                          1
                                      ? const Color.fromARGB(255, 242, 234, 12)
                                      : const Color.fromARGB(
                                          255, 156, 153, 153),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            child: userProvider.user?.membership?.purchased == 0
                                ? Text(
                                    "Free",
                                    style: stylePTSansBold(color: Colors.black),
                                  )
                                : Text(
                                    userProvider.user?.membership
                                                    ?.displayName ==
                                                null ||
                                            userProvider.user?.membership
                                                    ?.displayName ==
                                                ''
                                        ? "N/A"
                                        : "${userProvider.user?.membership?.displayName}",
                                    style: stylePTSansBold(color: Colors.black),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: (userProvider.user?.membership?.purchased != null &&
                      userProvider.user?.membership?.purchased == 0) &&
                  showMembership,
              child: Positioned(
                right: 10,
                left: 10,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromARGB(255, 1, 101, 16),
                        ThemeColors.accent
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "Upgrade to Premium",
                          style: stylePTSansBold(),
                        ),
                      ),
                      const SpacerHorizontal(width: 5),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: const Color.fromARGB(255, 0, 98, 13),
                        ),
                        onPressed: () {
                          Scaffold.of(context).closeDrawer();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NewMembership(),
                            ),
                          );
                          // askToSubscribe(
                          //   onPressed: () {
                          //     Navigator.pop(navigatorKey.currentContext!);
                          //     _upgradeSubscription();
                          //   },
                          // );
                        },
                        child: Text(
                          "UPGRADE",
                          style: stylePTSansBold(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),

        // Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(5),
        //     color: ThemeColors.greyBorder.withOpacity(0.2),
        //   ),
        //   child: Column(
        //     children: [
        //       Stack(
        //         children: [
        //           Container(
        //             height: 200,
        //             width: double.infinity,
        //             decoration: BoxDecoration(
        //               borderRadius: const BorderRadius.only(
        //                 topLeft: Radius.circular(5),
        //                 topRight: Radius.circular(5),
        //               ),
        //               color: Colors.black.withOpacity(0.2),
        //             ),
        //             child: ClipRRect(
        //               borderRadius: const BorderRadius.only(
        //                 topLeft: Radius.circular(5),
        //                 topRight: Radius.circular(5),
        //               ),
        //               child: Image.asset(
        //                 Images.upgrade,
        //                 fit: BoxFit.cover,
        //               ),
        //             ),
        //           ),
        //           Stack(
        //             children: [
        //               Container(
        //                 height: 200,
        //                 width: double.infinity,
        //                 decoration: BoxDecoration(
        //                   borderRadius: const BorderRadius.only(
        //                     topLeft: Radius.circular(5),
        //                     topRight: Radius.circular(5),
        //                   ),
        //                   color: Colors.black.withOpacity(0.7),
        //                 ),
        //               ),
        //               Positioned(
        //                 bottom: 10,
        //                 left: 10,
        //                 right: 10,
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
        //                       "Upgrade to",
        //                       style: styleGeorgiaBold(fontSize: 40),
        //                     ),
        //                     Text(
        //                       "Premium Plans",
        //                       style: styleGeorgiaBold(fontSize: 40),
        //                     ),
        //                   ],
        //                 ),
        //               )
        //             ],
        //           ),
        //         ],
        //       ),
        //       Container(
        //         padding:
        //             const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        //         child: Row(
        //           children: [
        //             Flexible(
        //               child: Text(
        //                 "Get more watchlists, price alerts and perks from Stocks.News",
        //                 style: stylePTSansRegular(color: ThemeColors.greyText),
        //               ),
        //             ),
        //             const SpacerHorizontal(width: 5),
        //             ThemeButtonSmall(
        //               text: "UPGRADE",
        //               onPressed: () {
        //                 _initPlatformState();
        //                 Scaffold.of(context).closeDrawer();
        //               },
        //               icon: Icons.upgrade,
        //               padding: const EdgeInsets.symmetric(
        //                   horizontal: 10, vertical: 5),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Future _upgradeSubscription() async {
    UserProvider provider = navigatorKey.currentContext!.read<UserProvider>();

    if (provider.user?.phone == null || provider.user?.phone == '') {
      await membershipLogin();
    }
    if (provider.user?.phone != null && provider.user?.phone != '') {
      await RevenueCatService.initializeSubscription();
    }
  }

  // Future<void> _initPlatformState() async {
  //   Purchases.setLogLevel(LogLevel.debug);

  //   UserRes? userRes = context.read<UserProvider>().user;
  //   Utils().showLog("${userRes?.userId}");

  //   if (Platform.isAndroid) {
  //     configuration = PurchasesConfiguration("goog_KXHVJRLChlyjoOamWsqCWQSJZfI")
  //       ..appUserID = userRes?.userId ?? "";
  //     // popUpAlert(
  //     //   message: "waiting for initialize..",
  //     //   title: "Alert",
  //     //   icon: Images.alertPopGIF,
  //     // );
  //   } else if (Platform.isIOS) {
  //     configuration = PurchasesConfiguration("appl_kHwXNrngqMNktkEZJqYhEgLjbcC")
  //       ..appUserID = userRes?.userId ?? "";
  //   }

  //   if (configuration != null) {
  //     await Purchases.configure(configuration!);

  //     PaywallResult result = await RevenueCatUI.presentPaywall();
  //     Utils().showLog("$result");

  //     CustomerInfo customerInfo = await Purchases.getCustomerInfo();
  //     Utils().showLog("Customer-->${customerInfo.managementURL}");

  //     await _result(result);
  //   }
  // }

  // Future _result(PaywallResult result) async {
  //   switch (result) {
  //     case PaywallResult.cancelled:
  //       break;
  //     case PaywallResult.error:
  //       // popUpAlert(
  //       //   message: Const.errSomethingWrong,
  //       //   title: "Alert",
  //       //   icon: Images.alertPopGIF,
  //       // );
  //       break;
  //     case PaywallResult.notPresented:
  //       // popUpAlert(
  //       //   message: "Paywall Not Presented",
  //       //   title: "Alert",
  //       //   icon: Images.alertPopGIF,
  //       // );
  //       break;

  //     case PaywallResult.purchased:
  //       await _purchaseSuccess();
  //       break;

  //     case PaywallResult.restored:
  //       break;

  //     default:
  //   }
  // }

  // _purchaseSuccess() async {
  //   await showModalBottomSheet(
  //     useSafeArea: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(5),
  //         topRight: Radius.circular(5),
  //       ),
  //     ),
  //     backgroundColor: ThemeColors.transparent,
  //     isScrollControlled: true,
  //     context: navigatorKey.currentContext!,
  //     builder: (context) {
  //       return const SubscriptionPurchased();
  //     },
  //   );
  // }
}
