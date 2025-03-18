// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/routes/my_app.dart';
// import 'package:stocks_news_new/screens/membership/index.dart';
// import 'package:stocks_news_new/service/revenue_cat.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import '../../../api/api_response.dart';
// import '../../../modals/user_res.dart';
// import '../../../providers/home_provider.dart';
// import '../../../utils/colors.dart';
// import '../../../utils/constants.dart';
// import '../../offerMembership/blackFriday/index.dart';
// import '../../offerMembership/blackFriday/widgets/permission_box.dart';
// import '../../myAccount/widgets/my-account_header.dart';
// import '../../offerMembership/christmas/index.dart';
// import 'profile_image.dart';

// class UserCard extends StatefulWidget {
//   final Function()? onTap;
//   const UserCard({super.key, this.onTap});

//   @override
//   State<UserCard> createState() => _UserCardState();
// }

// class _UserCardState extends State<UserCard> {
//   PurchasesConfiguration? configuration;
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     UserProvider userProvider = context.watch<UserProvider>();
//     Utils().showLog("$showMembership");
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             color: ThemeColors.greyBorder.withOpacity(0.2),
//           ),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   GestureDetector(
//                     behavior: HitTestBehavior.translucent,
//                     onTap: widget.onTap,
//                     child: ProfileImage(
//                       // isSVG: isSVG,
//                       url: userProvider.user?.image,
//                       showCameraIcon: false,
//                       imageSize: 70,
//                       roundImage: true,
//                     ),
//                   ),
//                   const SpacerHorizontal(width: 10),
//                   Expanded(
//                     child: GestureDetector(
//                       behavior: HitTestBehavior.translucent,
//                       onTap: widget.onTap,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             userProvider.user?.name?.isNotEmpty == true
//                                 ? "${userProvider.user?.name}"
//                                 : "Hello",
//                             style: styleBaseBold(),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(
//                             userProvider.user?.email?.isNotEmpty == true
//                                 ? "${userProvider.user?.email}"
//                                 : "",
//                             style: styleBaseRegular(
//                                 color: ThemeColors.greyText, fontSize: 12),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.only(top: 5),
//                             child: MyVerifiedCard(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Visibility(
//                 visible: showMembership,
//                 child: const Divider(
//                   color: ThemeColors.greyBorder,
//                   height: 30,
//                 ),
//               ),
//               Visibility(
//                 visible: showMembership,
//                 child: InkWell(
//                   onTap: userProvider.user?.membership?.purchased == 1
//                       ? () {
//                           Scaffold.of(context).closeDrawer();
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) {
//                                 return const MembershipIndex();
//                               },
//                             ),
//                           );
//                         }
//                       : null,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "Current Plan",
//                         style: styleBaseBold(fontSize: 18),
//                       ),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: ThemeColors.white,
//                           border: Border(
//                             bottom: BorderSide(
//                                 color: userProvider
//                                             .user?.membership?.purchased ==
//                                         1
//                                     ? const Color.fromARGB(255, 253, 245, 4)
//                                     : const Color.fromARGB(255, 113, 113, 113),
//                                 width: 1.2),
//                           ),
//                           gradient: LinearGradient(
//                             colors:
//                                 userProvider.user?.membership?.purchased == 1
//                                     ? [
//                                         const Color.fromARGB(255, 242, 234, 12),
//                                         const Color.fromARGB(255, 186, 181, 53),
//                                       ]
//                                     : [
//                                         Colors.white,
//                                         Colors.grey,
//                                       ],
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               blurRadius: 0,
//                               spreadRadius: 1,
//                               offset: const Offset(0, 1),
//                               color: userProvider.user?.membership?.purchased ==
//                                       1
//                                   ? const Color.fromARGB(255, 242, 234, 12)
//                                   : const Color.fromARGB(255, 156, 153, 153),
//                             ),
//                           ],
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 2),
//                         child: userProvider.user?.membership?.purchased == 0
//                             ? Text(
//                                 "Free",
//                                 style: styleBaseBold(color: Colors.black),
//                               )
//                             : Text(
//                                 userProvider.user?.membership?.displayName ==
//                                             null ||
//                                         userProvider.user?.membership
//                                                 ?.displayName ==
//                                             ''
//                                     ? "N/A"
//                                     : "${userProvider.user?.membership?.displayName}",
//                                 style: styleBaseBold(color: Colors.black),
//                               ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Visibility(
//           // visible: ((userProvider.user?.membership?.purchased != null &&
//           //             userProvider.user?.membership?.purchased == 0) ||
//           //         userProvider.user?.membership?.canUpgrade == true) &&
//           //     showMembership,
//           visible: userProvider.user?.membership?.purchased != null &&
//               showMembership,
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 10),
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             height: 50,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//                 colors: [Color.fromARGB(255, 1, 101, 16), ThemeColors.accent],
//               ),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(5),
//                 bottomRight: Radius.circular(5),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Flexible(
//                   child: Text(
//                     userProvider.user?.membership?.upgradeText?.text ??
//                         "Upgrade to Premium",
//                     style: styleBaseBold(),
//                   ),
//                 ),
//                 const SpacerHorizontal(width: 5),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     backgroundColor: const Color.fromARGB(255, 0, 98, 13),
//                   ),
//                   onPressed: () {
//                     Scaffold.of(context).closeDrawer();
//                     _upgradeSubscription();
//                   },
//                   child: Text(
//                     userProvider.user?.membership?.upgradeText?.button ??
//                         "UPGRADE",
//                     style: styleBaseBold(fontSize: 14),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }

//   Future _upgradeSubscription() async {
//     // Navigator.push(
//     //   navigatorKey.currentContext!,
//     //   MaterialPageRoute(
//     //     builder: (_) => const NewMembership(),
//     //   ),
//     // );

//     closeKeyboard();
//     UserRes? userRes = navigatorKey.currentContext!.read<UserProvider>().user;
//     Extra? extra = navigatorKey.currentContext!.read<HomeProvider>().extra;

//     if (userRes?.blackFriday != null) {
//       blackFridayPermission();
//     } else if (extra?.showBlackFriday == true) {
//       Navigator.push(
//         navigatorKey.currentContext!,
//         MaterialPageRoute(
//           builder: (context) => const BlackFridayMembershipIndex(),
//         ),
//       );
//     } else if (extra?.christmasMembership == true ||
//         extra?.newYearMembership == true) {
//       Navigator.push(
//         navigatorKey.currentContext!,
//         createRoute(
//           const ChristmasMembershipIndex(),
//         ),
//       );
//     } else {
//       subscribe();
//       // Navigator.push(
//       //   navigatorKey.currentContext!,
//       //   MaterialPageRoute(
//       //     builder: (context) => const NewMembership(),
//       //   ),
//       // );
//     }
//   }
// }
