// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/drawer_res.dart';
// import 'package:stocks_news_new/modals/user_res.dart';
// import 'package:stocks_news_new/providers/home_provider.dart';
// import 'package:stocks_news_new/providers/user_provider.dart';
// import 'package:stocks_news_new/screens/alerts/alerts.dart';
// import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet.dart';
// import 'package:stocks_news_new/screens/auth/bottomSheets/login_sheet_tablet.dart';
// import 'package:stocks_news_new/screens/auth/bottomSheets/signup_sheet.dart';
// import 'package:stocks_news_new/screens/blogs/index.dart';
// import 'package:stocks_news_new/screens/contactUs/contact_us.dart';
// import 'package:stocks_news_new/screens/drawer/widgets/back_press.dart';
// import 'package:stocks_news_new/screens/drawer/widgets/profile_image.dart';
// import 'package:stocks_news_new/screens/drawer/widgets/tile_widget.dart';
// import 'package:stocks_news_new/screens/faq/index.dart';
// import 'package:stocks_news_new/screens/myAccount/my_account.dart';
// import 'package:stocks_news_new/screens/stocks/index.dart';
// import 'package:stocks_news_new/screens/t&cAndPolicy/tc_policy.dart';
// import 'package:stocks_news_new/screens/whatWeDo/index.dart';
// // import 'package:stocks_news_new/screens/whatWeDo/index.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/logout.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:stocks_news_new/widgets/theme_button_small.dart';
// //
// import '../../utils/utils.dart';
// import '../watchlist/watchlist.dart';

// class BaseDrawer extends StatefulWidget {
//   final bool resetIndex;
//   const BaseDrawer({super.key, this.resetIndex = true});

//   @override
//   State<BaseDrawer> createState() => _BaseDrawerState();
// }

// class _BaseDrawerState extends State<BaseDrawer> {
//   String? version;
//   bool userPresent = false;
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _getData();
//       widget.resetIndex ? _resetIndex() : null;
//     });
//   }

//   void _getData() async {
//     UserProvider provider = context.read<UserProvider>();
//     if (await provider.checkForUser()) {
//       userPresent = true;
//       setState(() {});
//     }

//     PackageInfo packageInfo = await PackageInfo.fromPlatform();
//     version = packageInfo.version;
//     setState(() {});
//   }

//   void _resetIndex() {
//     for (var i = 0; i < drawerItems.length; i++) {
//       drawerItems[i].isSelected = false;
//     }
//     setState(() {});
//   }

//   Widget _itemsWidget() {
//     return ListView.separated(
//         // padding: EdgeInsets.symmetric(vertical: 10.sp),
//         physics: const NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         itemBuilder: (context, index) {
//           return DrawerTileWidget(
//             index: index,
//             onTap: () => _onitemTap(index: index),
//           );
//         },
//         separatorBuilder: (context, index) {
//           return const SpacerVertical(height: 0);
//         },
//         itemCount: drawerItems.length);
//   }

//   // _onitemTap({required int index}) {
//   //   Navigator.pop(context);
//   //   if (!drawerItems[index].isSelected) {
//   //     setState(() {
//   //       for (int i = 0; i < drawerItems.length; i++) {
//   //         drawerItems[i].isSelected = (i == index);
//   //       }
//   //     });
//   //     // List<String> paths = [
//   //     //   Notifications.path,
//   //     // ];
//   //     // String path = paths[index];

//   //     // Navigator.pushNamed(context, path);
//   //     switch (index) {
//   //       case 0:
//   //         break;
//   //       case 1:
//   //         Navigator.pushNamed(context, StocksIndex.path);

//   //         break;
//   //       case 2:
//   //         Navigator.pushNamed(context, MyAccount.path);

//   //         break;
//   //       case 3:
//   //         Navigator.pushNamed(context, TrendingIndustries.path);
//   //         break;

//   //       case 4:
//   //         Navigator.pushNamed(context, Alerts.path);
//   //         break;
//   //       case 5:
//   //         Navigator.pushNamed(context, WatchList.path);
//   //         break;
//   //       case 6:
//   //         Navigator.pushNamed(context, Notifications.path);
//   //         break;
//   //       case 7:
//   //         Navigator.pushNamed(context, FAQ.path);
//   //         break;
//   //       case 8:
//   //         Navigator.pushNamed(context, ContactUs.path);
//   //         break;
//   //       case 9:
//   //         Navigator.pushNamed(context, TCandPolicy.path,
//   //             arguments: PolicyType.tC);
//   //         break;
//   //       case 10:
//   //         Navigator.pushNamed(context, TCandPolicy.path,
//   //             arguments: PolicyType.privacy);
//   //         break;
//   //       case 11:
//   //         Navigator.pushNamed(context, IndexBlog.path);
//   //         break;
//   //       default:
//   //     }
//   //   }
//   // }

//   _onitemTap({required int index}) {
//     // Timer(const Duration(milliseconds: 30), () {
//     Scaffold.of(context).closeDrawer();
//     // });

//     if (drawerItems[index].isSelected) {
//       return; // Do nothing if the item is already selected
//     }

//     setState(() {
//       for (var item in drawerItems) {
//         item.isSelected = false;
//       }
//       drawerItems[index].isSelected = true;
//     });

//     // Define a map to store the routes based on the index
//     Map<int, String> routes = {
//       // 1: StocksIndex.path,
//       // 2: Alerts.path,
//       // 3: WatchList.path,
//       // 4: TrendingIndustries.path,
//       // 5: Notifications.path,
//       // 6: MyAccount.path,
//       // 7: FAQ.path,
//       // 8: TCandPolicy.path,
//       // 9: ContactUs.path,
//       // 10: TCandPolicy.path,
//       // 11: TCandPolicy.path,
//       // 12: TCandPolicy.path,
//       // 13: IndexBlog.path,

//       0: StocksIndex.path,
//       // 1: Alerts.path,
//       // 2: WatchList.path,
//       // 1: TrendingIndustries.path,
//       // 2: Notifications.path,
//       1: MyAccount.path,
//       2: Blog.path,
//       3: TCandPolicy.path,
//       4: WhatWeDoIndex.path,
//       5: ContactUs.path,
//       6: FAQ.path,

//       // 7: TCandPolicy.path,
//       // 8: TCandPolicy.path,
//       // 6: TCandPolicy.path,
//       //
//     };

//     // Check if the index is within the valid range
//     if (index >= 0 && index <= 6) {
//       String path = routes[index]!;
//       if (index == 3) {
//         Navigator.pushNamed(context, path, arguments: PolicyType.aboutUs);
//       } else {
//         Navigator.pushNamed(context, path);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     HomeProvider provider = context.watch<HomeProvider>();
//     UserRes? user = context.watch<UserProvider>().user;
//     return SafeArea(
//       child: Drawer(
//         backgroundColor: Colors.black,
//         width: ScreenUtil().screenWidth / 1.2,
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Column(
//             children: [
//               const SpacerVertical(height: 20),
//               !userPresent
//                   ? Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10.sp),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SpacerVertical(height: 10),
//                           Text(
//                             "Welcome to stocks.news",
//                             style: stylePTSansBold(fontSize: 20),
//                             textAlign: TextAlign.center,
//                           ),
//                           Text(
//                             provider.homeSliderRes?.text.drawerHeader ?? "",
//                             style: stylePTSansRegular(
//                                 fontSize: 14, color: ThemeColors.greyText),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SpacerVertical(height: 15),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 child: ThemeButtonSmall(
//                                   onPressed: () {
//                                     // Navigator.pushNamed(context, Login.path);
//                                     Timer(const Duration(milliseconds: 200),
//                                         () {
//                                       Scaffold.of(context).closeDrawer();
//                                     });
//                                     isPhone
//                                         ? loginSheet(dontPop: 'true')
//                                         : loginSheetTablet(dontPop: 'true');
//                                     // Navigator.push(
//                                     //     context,
//                                     //     createRoute(const Login(
//                                     //       dontPop: "true",
//                                     //     )));
//                                   },
//                                   text: "Log In",
//                                   showArrow: false,
//                                   // fullWidth: false,
//                                 ),
//                               ),
//                               const SpacerHorizontal(width: 10),
//                               Expanded(
//                                 child: ThemeButtonSmall(
//                                   onPressed: () {
//                                     // Navigator.pushNamed(context, Login.path);
//                                     Timer(const Duration(milliseconds: 200),
//                                         () {
//                                       Scaffold.of(context).closeDrawer();
//                                     });
//                                     signupSheet(dontPop: 'true');
//                                     // Navigator.push(
//                                     //     context,
//                                     //     createRoute(const Login(
//                                     //       dontPop: "true",
//                                     //     )));
//                                   },
//                                   text: "Sign Up",
//                                   showArrow: false,
//                                   // fullWidth: false,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     )
//                   : Padding(
//                       padding: EdgeInsets.only(left: 20.sp),
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                           Navigator.pushNamed(context, MyAccount.path);
//                         },
//                         child: Row(
//                           children: [
//                             ProfileImage(
//                               url: user?.image,
//                               cameraSize: 12,
//                             ),
//                             const SpacerHorizontal(width: 10),
//                             Expanded(
//                                 child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   user?.name?.isNotEmpty == true
//                                       ? "${user?.name}"
//                                       : "Hello",
//                                   style: stylePTSansBold(),
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 Visibility(
//                                   visible:
//                                       user?.email != null && user?.email != '',
//                                   child: Text(
//                                     "${user?.email}",
//                                     style: stylePTSansRegular(
//                                         color: ThemeColors.greyText,
//                                         fontSize: 12),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ],
//                             )),
//                             const SpacerHorizontal(width: 10),
//                             const DrawerBackpress(),
//                           ],
//                         ),
//                       ),
//                     ),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(
//                   20.sp,
//                   0,
//                   20.sp,
//                   20.sp,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Divider(
//                     //     color: ThemeColors.greyBorder,
//                     //     height: 20.sp,
//                     //     thickness: 1),
//                     // TextInputFieldSearchCommon(
//                     //   openConstraints: false,
//                     //   contentPadding: EdgeInsets.symmetric(
//                     //     horizontal: 20.sp,
//                     //     vertical: 18.sp,
//                     //   ),
//                     //   radius: 30,
//                     //   hintText: "Search Symbols",
//                     //   searching: context.watch<SearchProvider>().isLoading,
//                     //   onChanged: (text) {},
//                     // ),
//                     const SpacerVertical(height: 25),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             Scaffold.of(context).closeDrawer();
//                             Navigator.pushNamed(context, Alerts.path);
//                           },
//                           child: Column(
//                             children: [
//                               const Icon(
//                                 Icons.add_alert_outlined,
//                                 size: 22,
//                               ),
//                               const SpacerVertical(height: 5),
//                               Text(
//                                 "${provider.totalAlerts}",
//                                 style: stylePTSansBold(),
//                               ),
//                               const SpacerVertical(height: 5),
//                               Text(
//                                 provider.totalAlerts == 1 ||
//                                         provider.totalAlerts == 0
//                                     ? "Stock Alert"
//                                     : "Stock Alerts",
//                                 style: stylePTSansRegular(
//                                     fontSize: 13,
//                                     color: const Color.fromARGB(
//                                         255, 184, 187, 193)),
//                               )
//                             ],
//                           ),
//                         ),
//                         const SpacerHorizontal(width: 40),
//                         InkWell(
//                           onTap: () {
//                             Scaffold.of(context).closeDrawer();
//                             Navigator.pushNamed(context, WatchList.path);
//                           },
//                           child: Column(
//                             children: [
//                               const Icon(
//                                 Icons.star_border,
//                                 size: 22,
//                               ),
//                               const SpacerVertical(height: 5),
//                               Text(
//                                 "${provider.totalWatchList}",
//                                 style: stylePTSansBold(),
//                               ),
//                               const SpacerVertical(height: 5),
//                               Text(
//                                 "Stock Watchlist",
//                                 style: stylePTSansRegular(
//                                   fontSize: 13,
//                                   color:
//                                       const Color.fromARGB(255, 184, 187, 193),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     // const SpacerVertical(height: 5),
//                     const SpacerVertical(height: 25),
//                     // Divider(
//                     //     color: ThemeColors.greyBorder,
//                     //     height: 20.sp,
//                     //     thickness: 1),
//                     _itemsWidget(),
//                     Visibility(
//                       visible: userPresent,
//                       child: Column(
//                         children: [
//                           Ink(
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.black, width: 3),
//                               color: Colors.black,
//                               borderRadius: BorderRadius.circular(50.sp),
//                             ),
//                             child: InkWell(
//                               borderRadius: BorderRadius.circular(50.sp),
//                               onTap: () {
//                                 // showDialog(
//                                 //   context: context,
//                                 //   builder: (context) {
//                                 //     return const LogoutDialog();
//                                 //   },
//                                 // );
//                                 logoutPopUp();
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 10.sp, vertical: 6.sp),
//                                 child: Row(
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.only(right: 2.sp),
//                                       child: const Icon(
//                                         Icons.logout_outlined,
//                                         size: 20,
//                                         color: ThemeColors.sos,
//                                       ),
//                                     ),
//                                     const SpacerHorizontal(width: 20),
//                                     Expanded(
//                                       child: Text('Logout',
//                                           style: stylePTSansBold(
//                                               fontSize: 14,
//                                               color: ThemeColors.sos)),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Divider(color: ThemeColors.greyBorder, height: 5.sp),
//                         ],
//                       ),
//                     ),
//                     const SpacerVertical(height: 10),
//                     // Visibility(
//                     //   visible: userPresent,
//                     //   child: Container(
//                     //     decoration: BoxDecoration(
//                     //       borderRadius: BorderRadius.circular(30.sp),
//                     //       border: Border.all(
//                     //           color: ThemeColors.greyBorder.withOpacity(0.5),
//                     //           width: 2.sp),
//                     //     ),
//                     //     padding: EdgeInsets.all(4.sp),
//                     //     child: InkWell(
//                     //       borderRadius: BorderRadius.circular(30.sp),
//                     //       onTap: () {
//                     //         showDialog(
//                     //           context: context,
//                     //           builder: (context) {
//                     //             return const LogoutDialog();
//                     //           },
//                     //         );
//                     //       },
//                     //       child: Container(
//                     //         padding: EdgeInsets.symmetric(
//                     //             horizontal: 15.sp, vertical: 6.sp),
//                     //         decoration: BoxDecoration(
//                     //           color: ThemeColors.greyBorder.withOpacity(0.5),
//                     //           borderRadius: BorderRadius.circular(30.sp),
//                     //         ),
//                     //         child: Row(
//                     //           mainAxisSize: MainAxisSize.min,
//                     //           children: [
//                     //             Icon(
//                     //               Icons.power_settings_new_rounded,
//                     //               size: 20.sp,
//                     //             ),
//                     //             const SpacerHorizontal(width: 5),
//                     //             Text(
//                     //               "Logout",
//                     //               style: stylePTSansBold(fontSize: 13),
//                     //             ),
//                     //           ],
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                     const SpacerVertical(height: 5),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10.sp),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     openUrl(
//                                       Platform.isAndroid
//                                           ? 'https://play.google.com/store/apps/details?id=com.stocks.news'
//                                           : 'https://apps.apple.com/us/app/stocks-news/id6476615803',
//                                     );
//                                   },
//                                   child: Container(
//                                     padding: EdgeInsets.all(15.sp),
//                                     decoration: const BoxDecoration(
//                                         color: Color.fromARGB(255, 36, 36, 36),
//                                         shape: BoxShape.circle),
//                                     child: const Icon(
//                                       Icons.reviews_outlined,
//                                       size: 24,
//                                     ),
//                                   ),
//                                 ),
//                                 const SpacerVertical(height: 5),
//                                 Text(
//                                   "Review app",
//                                   style: stylePTSansRegular(
//                                     color: ThemeColors.greyText,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 GestureDetector(
//                                   onTap: () {
//                                     commonShare(
//                                       title:
//                                           provider.homeSliderRes?.shareText ??
//                                               "",
//                                       url: provider.homeSliderRes?.shareUrl,
//                                     );
//                                   },
//                                   child: Container(
//                                     padding: EdgeInsets.all(15.sp),
//                                     decoration: const BoxDecoration(
//                                         color: Color.fromARGB(255, 36, 36, 36),
//                                         shape: BoxShape.circle),
//                                     child: const Icon(
//                                       Icons.ios_share_outlined,
//                                       size: 24,
//                                     ),
//                                   ),
//                                 ),
//                                 const SpacerVertical(height: 5),
//                                 Text(
//                                   "Share app",
//                                   style: stylePTSansRegular(
//                                     color: ThemeColors.greyText,
//                                     fontSize: 13,
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SpacerVertical(height: 20),
//                     // TODO:Social
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.center,
//                     //   children: [
//                     //     Flexible(
//                     //       child: GestureDetector(
//                     //         onTap: () {
//                     //           openUrl(provider.homeSliderRes?.telegramLink);
//                     //         },
//                     //         child: Column(
//                     //           children: [
//                     //             Container(
//                     //               color: const Color(0xFF000000),
//                     //               child: Padding(
//                     //                 padding: EdgeInsets.fromLTRB(
//                     //                     6.sp, 9.sp, 6.sp, 9.sp),
//                     //                 child: Image.asset(
//                     //                   Images.telegram,
//                     //                   height: 40.sp,
//                     //                 ),
//                     //               ),
//                     //             ),
//                     //             Text(
//                     //               "Join us on Telegram",
//                     //               style: styleGeorgiaRegular(),
//                     //             )
//                     //           ],
//                     //         ),
//                     //       ),
//                     //     ),
//                     //     const SpacerHorizontal(width: 10),
//                     //     Flexible(
//                     //       child: GestureDetector(
//                     //         onTap: () {
//                     //           openUrl(provider.homeSliderRes?.whatsappLink);
//                     //         },
//                     //         child: Container(
//                     //           color: const Color(0xFF000000),
//                     //           child: Padding(
//                     //             padding:
//                     //                 EdgeInsets.fromLTRB(6.sp, 9.sp, 6.sp, 9.sp),
//                     //             child: ClipRRect(
//                     //               child: Image.asset(
//                     //                 Images.whatsappC,
//                     //                 height: 40.sp,
//                     //               ),
//                     //             ),
//                     //           ),
//                     //         ),
//                     //       ),
//                     //     ),
//                     //   ],
//                     // ),
//                     const SpacerVertical(height: 20),
//                     Align(
//                       alignment: Alignment.center,
//                       child: RichText(
//                         textAlign: TextAlign.center,
//                         text: TextSpan(
//                           children: [
//                             TextSpan(
//                                 text: 'Disclaimer,',
//                                 recognizer: TapGestureRecognizer()
//                                   ..onTap = () {
//                                     Scaffold.of(context).closeDrawer();
//                                     Navigator.push(
//                                       context,
//                                       createRoute(
//                                         const TCandPolicy(
//                                           policyType: PolicyType.disclaimer,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 style: stylePTSansRegular(fontSize: 13)),
//                             TextSpan(
//                                 text: ' Privacy Policy ',
//                                 recognizer: TapGestureRecognizer()
//                                   ..onTap = () {
//                                     Scaffold.of(context).closeDrawer();
//                                     Navigator.push(
//                                       context,
//                                       createRoute(
//                                         const TCandPolicy(
//                                           policyType: PolicyType.privacy,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 style: stylePTSansRegular(fontSize: 13)),
//                             TextSpan(
//                                 text: 'and',
//                                 style: stylePTSansRegular(
//                                     fontSize: 13, color: ThemeColors.greyText)),
//                             TextSpan(
//                                 text: ' Terms of Service',
//                                 recognizer: TapGestureRecognizer()
//                                   ..onTap = () {
//                                     Scaffold.of(context).closeDrawer();
//                                     Navigator.push(
//                                       context,
//                                       createRoute(
//                                         const TCandPolicy(
//                                           policyType: PolicyType.tC,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 style: stylePTSansRegular(fontSize: 13)),
//                           ],
//                           recognizer: TapGestureRecognizer()
//                             ..onTap = () {
//                               Scaffold.of(context).closeDrawer();
//                               Navigator.push(
//                                 context,
//                                 createRoute(
//                                   const TCandPolicy(
//                                     policyType: PolicyType.privacy,
//                                   ),
//                                 ),
//                               );
//                             },
//                           text: "Read our ",
//                           style: stylePTSansRegular(
//                               fontSize: 13, color: ThemeColors.greyText),
//                         ),
//                       ),
//                     ),
//                     const SpacerVertical(height: 10),
//                     Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         "App Version: $version",
//                         style: stylePTSansRegular(
//                           fontSize: 13,
//                           color: ThemeColors.greyText,
//                         ),
//                       ),
//                     ),
//                     // GestureDetector(
//                     //   onTap: () {
//                     //     context.read<UserProvider>().logout();
//                     //   },
//                     //   child: Container(
//                     //     decoration: BoxDecoration(
//                     //       border: Border.all(color: ThemeColors.primaryLight),
//                     //       borderRadius: BorderRadius.circular(30.sp),
//                     //     ),
//                     //     padding: EdgeInsets.all(3.sp),
//                     //     margin: EdgeInsets.only(
//                     //       left: 10.sp,
//                     //       top: 20.sp,
//                     //     ),
//                     //     child: Container(
//                     //       decoration: BoxDecoration(
//                     //         color: ThemeColors.primaryLight,
//                     //         borderRadius: BorderRadius.circular(30.sp),
//                     //       ),
//                     //       padding: const EdgeInsets.symmetric(
//                     //         horizontal: 8,
//                     //         vertical: 4,
//                     //       ),
//                     //       child: Row(
//                     //         mainAxisSize: MainAxisSize.min,
//                     //         children: [
//                     //           const Icon(Icons.power_settings_new_rounded),
//                     //           const SpacerHorizontal(width: 8),
//                     //           Text(
//                     //             "Log Out",
//                     //             style: stylePTSansBold(fontSize: 14),
//                     //           )
//                     //         ],
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
