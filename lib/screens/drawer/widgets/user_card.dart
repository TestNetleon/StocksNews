// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/route/my_app.dart';
// import 'package:stocks_news_new/screens/membership/index.dart';
// import 'package:stocks_news_new/screens/membership_new/membership.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import '../../../providers/leaderboard.dart';
// import '../../../utils/colors.dart';

// import '../../../utils/constants.dart';
// import '../../myAccount/widgets/my-account_header.dart';
// import 'profile_image.dart';

// class UserCard extends StatefulWidget {
//   final Function()? onTap;
//   const UserCard({super.key, this.onTap});

//   @override
//   State<UserCard> createState() => _UserCardState();
// }

// class _UserCardState extends State<UserCard> {
//   PurchasesConfiguration? configuration;
//   // bool isSVG = false;
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _callAPI();
//       // _isSVG();
//     });
//   }

//   _callAPI() {
//     // HomeProvider provider = context.read<HomeProvider>();
//     UserProvider provider = context.read<UserProvider>();
//     if (provider.user?.affiliateStatus == 1) {
//       LeaderBoardProvider provider = context.read<LeaderBoardProvider>();
//       provider.getReferData(checkAppUpdate: false);
//     }
//   }

//   // Future _isSVG() async {
//   //   UserProvider provider = context.read<UserProvider>();
//   //   isSVG = await isSvgFromUrl(provider.user?.image ?? "");
//   //   Utils().showLog("is SVG? $isSVG");
//   //   setState(() {});
//   // }

//   @override
//   Widget build(BuildContext context) {
//     UserProvider userProvider = context.watch<UserProvider>();
//     Utils().showLog("$showMembership");
//     return Column(
//       children: [
//         Stack(
//           children: [
//             Container(
//               margin: showMembership
//                   ? EdgeInsets.only(
//                       bottom: userProvider.user?.membership?.purchased == 1
//                           ? 0
//                           : 50)
//                   : null,
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 color: ThemeColors.greyBorder.withOpacity(0.2),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       GestureDetector(
//                         behavior: HitTestBehavior.translucent,
//                         onTap: widget.onTap,
//                         child: ProfileImage(
//                           // isSVG: isSVG,
//                           url: userProvider.user?.image,
//                           showCameraIcon: false,
//                           imageSize: 70,
//                           roundImage: true,
//                         ),
//                       ),
//                       const SpacerHorizontal(width: 10),
//                       Expanded(
//                         child: GestureDetector(
//                           behavior: HitTestBehavior.translucent,
//                           onTap: widget.onTap,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 userProvider.user?.name?.isNotEmpty == true
//                                     ? "${userProvider.user?.name}"
//                                     : "Hello",
//                                 style: stylePTSansBold(),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               Text(
//                                 userProvider.user?.email?.isNotEmpty == true
//                                     ? "${userProvider.user?.email}"
//                                     : "",
//                                 style: stylePTSansRegular(
//                                     color: ThemeColors.greyText, fontSize: 12),
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               const Padding(
//                                 padding: EdgeInsets.only(top: 5),
//                                 child: MyVerifiedCard(),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Visibility(
//                     visible: showMembership,
//                     child: const Divider(
//                       color: ThemeColors.greyBorder,
//                       height: 30,
//                     ),
//                   ),
//                   Visibility(
//                     visible: showMembership,
//                     child: InkWell(
//                       onTap: userProvider.user?.membership?.purchased == 1
//                           ? () {
//                               Scaffold.of(context).closeDrawer();
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) {
//                                     return const MembershipIndex();
//                                   },
//                                 ),
//                               );
//                             }
//                           : null,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Current Plan",
//                             style: stylePTSansBold(fontSize: 18),
//                           ),
//                           Container(
//                             decoration: BoxDecoration(
//                               color: ThemeColors.white,
//                               border: Border(
//                                 bottom: BorderSide(
//                                     color: userProvider
//                                                 .user?.membership?.purchased ==
//                                             1
//                                         ? const Color.fromARGB(255, 253, 245, 4)
//                                         : const Color.fromARGB(
//                                             255, 113, 113, 113),
//                                     width: 1.2),
//                               ),
//                               gradient: LinearGradient(
//                                 colors: userProvider
//                                             .user?.membership?.purchased ==
//                                         1
//                                     ? [
//                                         const Color.fromARGB(255, 242, 234, 12),
//                                         const Color.fromARGB(255, 186, 181, 53),
//                                       ]
//                                     : [
//                                         Colors.white,
//                                         Colors.grey,
//                                       ],
//                               ),
//                               borderRadius: BorderRadius.circular(20),
//                               boxShadow: [
//                                 BoxShadow(
//                                   blurRadius: 0,
//                                   spreadRadius: 1,
//                                   offset: const Offset(0, 1),
//                                   color: userProvider
//                                               .user?.membership?.purchased ==
//                                           1
//                                       ? const Color.fromARGB(255, 242, 234, 12)
//                                       : const Color.fromARGB(
//                                           255, 156, 153, 153),
//                                 ),
//                               ],
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 8, vertical: 2),
//                             child: userProvider.user?.membership?.purchased == 0
//                                 ? Text(
//                                     "Free",
//                                     style: stylePTSansBold(color: Colors.black),
//                                   )
//                                 : Text(
//                                     userProvider.user?.membership
//                                                     ?.displayName ==
//                                                 null ||
//                                             userProvider.user?.membership
//                                                     ?.displayName ==
//                                                 ''
//                                         ? "N/A"
//                                         : "${userProvider.user?.membership?.displayName}",
//                                     style: stylePTSansBold(color: Colors.black),
//                                   ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Visibility(
//               visible: (userProvider.user?.membership?.purchased != null &&
//                       userProvider.user?.membership?.purchased == 0) &&
//                   showMembership,
//               child: Positioned(
//                 right: 10,
//                 left: 10,
//                 bottom: 0,
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   height: 50,
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.centerLeft,
//                       end: Alignment.centerRight,
//                       colors: [
//                         Color.fromARGB(255, 1, 101, 16),
//                         ThemeColors.accent
//                       ],
//                     ),
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(5),
//                       bottomRight: Radius.circular(5),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Flexible(
//                         child: Text(
//                           "Upgrade to Premium",
//                           style: stylePTSansBold(),
//                         ),
//                       ),
//                       const SpacerHorizontal(width: 5),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           backgroundColor: const Color.fromARGB(255, 0, 98, 13),
//                         ),
//                         onPressed: () {
//                           Scaffold.of(context).closeDrawer();
//                           _upgradeSubscription();
//                         },
//                         child: Text(
//                           "UPGRADE",
//                           style: stylePTSansBold(fontSize: 14),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ],
//     );
//   }

//   Future _upgradeSubscription() async {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(
//         builder: (_) => const NewMembership(
//           withClickCondition: true,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/membership/index.dart';
import 'package:stocks_news_new/screens/membership_new/membership.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../providers/leaderboard.dart';
import '../../../utils/colors.dart';

import '../../../utils/constants.dart';
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
  // bool isSVG = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
      // _isSVG();
    });
  }

  _callAPI() {
    // HomeProvider provider = context.read<HomeProvider>();
    UserProvider provider = context.read<UserProvider>();
    if (provider.user?.affiliateStatus == 1) {
      LeaderBoardProvider provider = context.read<LeaderBoardProvider>();
      provider.getReferData(checkAppUpdate: false);
    }
  }

  // Future _isSVG() async {
  //   UserProvider provider = context.read<UserProvider>();
  //   isSVG = await isSvgFromUrl(provider.user?.image ?? "");
  //   Utils().showLog("is SVG? $isSVG");
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    Utils().showLog("$showMembership");
    return Column(
      children: [
        Container(
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
                      // isSVG: isSVG,
                      url: userProvider.user?.image,
                      showCameraIcon: false,
                      imageSize: 70,
                      roundImage: true,
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
                          Scaffold.of(context).closeDrawer();
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
                                    : const Color.fromARGB(255, 113, 113, 113),
                                width: 1.2),
                          ),
                          gradient: LinearGradient(
                            colors:
                                userProvider.user?.membership?.purchased == 1
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
                              color: userProvider.user?.membership?.purchased ==
                                      1
                                  ? const Color.fromARGB(255, 242, 234, 12)
                                  : const Color.fromARGB(255, 156, 153, 153),
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
                                userProvider.user?.membership?.displayName ==
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
          visible: ((userProvider.user?.membership?.purchased != null &&
                      userProvider.user?.membership?.purchased == 0) ||
                  userProvider.user?.membership?.canUpgrade == true) &&
              showMembership,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color.fromARGB(255, 1, 101, 16), ThemeColors.accent],
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
                    _upgradeSubscription();
                  },
                  child: Text(
                    "UPGRADE",
                    style: stylePTSansBold(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future _upgradeSubscription() async {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => const NewMembership(
          withClickCondition: true,
        ),
      ),
    );
  }
}
