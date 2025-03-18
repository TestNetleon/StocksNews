// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import '../../../utils/theme.dart';
// import '../../../widgets/custom_gridview.dart';
// import 'drawer_lists.dart';
// import 'drawer_new_widget.dart';
// import 'drawer_top_new.dart';

// class DrawerMoreService extends StatefulWidget {
//   const DrawerMoreService({super.key});

//   @override
//   State<DrawerMoreService> createState() => _DrawerMoreServiceState();
// }

// class _DrawerMoreServiceState extends State<DrawerMoreService>
//     with TickerProviderStateMixin {
//   final ScrollController _scrollController = ScrollController();
//   TabController? _tabController;
//   // double firstTab = ScreenUtil().screenHeight * 0.485;
//   // double secondTab = ScreenUtil().screenHeight * 0.817;
//   // double thirdTab = ScreenUtil().screenHeight * 1.055;
//   // double fourthTab = ScreenUtil().screenHeight * 1.293;
//   // double fifthTab = ScreenUtil().screenHeight * 1.47;
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _tabController = TabController(length: 6, vsync: this);
//   //   _scrollController.addListener(_scrollListener);
//   // }

//   // @override
//   // void dispose() {
//   //   _scrollController.removeListener(_scrollListener);
//   //   _tabController?.dispose();
//   //   super.dispose();
//   // }

//   // void _scrollListener() {
//   //   double offset = _scrollController.offset;
//   //   int index = _getTabIndex(offset + 20);
//   //   _tabController?.animateTo(
//   //     index,
//   //     curve: Curves.easeIn,
//   //     duration: const Duration(milliseconds: 1),
//   //   );
//   // }

//   // void _scrollToIndex(int index) {
//   //   double scrollOffset = 0.0;
//   //   switch (index) {
//   //     case 1:
//   //       scrollOffset = firstTab;
//   //       break;
//   //     case 2:
//   //       scrollOffset = secondTab;
//   //       break;
//   //     case 3:
//   //       scrollOffset = thirdTab;
//   //       break;
//   //     case 4:
//   //       scrollOffset = fourthTab;
//   //       break;
//   //     case 5:
//   //       scrollOffset = fifthTab;
//   //       break;
//   //     default:
//   //       scrollOffset = 0;
//   //   }
//   //   _scrollController.animateTo(
//   //     scrollOffset,
//   //     duration: const Duration(milliseconds: 1),
//   //     curve: Curves.easeOut,
//   //   );
//   // }

//   // int _getTabIndex(double offset) {
//   //   if (offset < firstTab) {
//   //     return 0;
//   //   } else if (offset < secondTab) {
//   //     return 1;
//   //   } else if (offset < thirdTab) {
//   //     return 2;
//   //   } else if (offset < fourthTab) {
//   //     return 3;
//   //   } else if (offset < fifthTab) {
//   //     return 4;
//   //   } else {
//   //     return 5;
//   //   }

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 6, vsync: this);
//     _scrollController.addListener(_scrollListener);
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_scrollListener);
//     _tabController?.dispose();
//     super.dispose();
//   }

//   void _scrollListener() {
//     double offset = _scrollController.offset;
//     int index = _getTabIndex(offset + 20);
//     _tabController?.animateTo(
//       index,
//       curve: Curves.easeIn,
//       duration: const Duration(milliseconds: 1),
//     );
//   }

//   void _scrollToIndex(int index) {
//     double scrollOffset = 0.0;
//     switch (index) {
//       case 1:
//         scrollOffset = ScreenUtil().screenHeight * 0.485;
//         break;
//       case 2:
//         scrollOffset = ScreenUtil().screenHeight * 0.817;
//         break;
//       case 3:
//         scrollOffset = ScreenUtil().screenHeight * 1.055;
//         break;
//       case 4:
//         scrollOffset = ScreenUtil().screenHeight * 1.293;
//         break;
//       case 5:
//         scrollOffset = ScreenUtil().screenHeight * 1.47;
//         break;
//       default:
//         scrollOffset = 0;
//     }
//     _scrollController.animateTo(
//       scrollOffset,
//       duration: const Duration(milliseconds: 1),
//       curve: Curves.easeOut,
//     );
//   }

//   int _getTabIndex(double offset) {
//     if (offset < ScreenUtil().screenHeight * 0.485) {
//       return 0;
//     } else if (offset < ScreenUtil().screenHeight * 0.817) {
//       return 1;
//     } else if (offset < ScreenUtil().screenHeight * 1.055) {
//       return 2;
//     } else if (offset < ScreenUtil().screenHeight * 1.293) {
//       return 3;
//     } else if (offset < ScreenUtil().screenHeight * 1.47) {
//       return 4;
//     } else {
//       return 5;
//     }
//     // if (offset < 450) {
//     //   return 0;
//     // } else if (offset < 720) {
//     //   return 1;
//     // } else if (offset < 920) {
//     //   return 2;
//     // } else if (offset < 1100) {
//     //   return 3;
//     // } else if (offset < 1200) {
//     //   return 4;
//     // } else {
//     //   return 5;
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 6,
//       child: Scaffold(
//         backgroundColor: ThemeColors.background,
//         body: SafeArea(
//           child: Column(
//             children: [
//               const DrawerTopNew(
//                 text: "More Services",
//               ),
//               TabBar(
//                 controller: _tabController,
//                 indicatorColor: ThemeColors.accent,
//                 isScrollable: true,
//                 labelPadding:
//                     EdgeInsets.symmetric(horizontal: 10.sp, vertical: 0),
//                 padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 0),
//                 labelStyle: styleBaseBold(),
//                 labelColor: ThemeColors.accent,
//                 unselectedLabelColor: ThemeColors.white,
//                 indicator: const BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(color: ThemeColors.accent),
//                   ),
//                 ),
//                 tabs: const [
//                   Tab(text: "Market Data"),
//                   Tab(text: "Research Tools"),
//                   Tab(text: "Financial Calendar"),
//                   Tab(text: "Stock Lists"),
//                   Tab(text: "Headlines"),
//                   Tab(text: "Learn"),
//                 ],
//                 onTap: (index) {
//                   _scrollToIndex(index);
//                 },
//               ),
//               Expanded(
//                 child: ListView(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.sp),
//                   controller: _scrollController,
//                   children: [
//                     CustomGridViewPerChild(
//                       paddingHorizontal: 5,
//                       paddingVertical: 25,
//                       childrenPerRow: 3,
//                       length: marketData.length,
//                       getChild: (index) {
//                         return InkWell(
//                           onTap: marketData[index].onTap,
//                           child: DrawerNewWidget(
//                             icon: marketData[index].iconData,
//                             text: marketData[index].text,
//                           ),
//                         );
//                       },
//                     ),
//                     Text(
//                       "Research Tools",
//                       style: styleBaseBold(),
//                     ),
//                     CustomGridViewPerChild(
//                       paddingHorizontal: 5,
//                       paddingVertical: 25,
//                       childrenPerRow: 3,
//                       length: researchTools.length,
//                       getChild: (index) {
//                         return InkWell(
//                           onTap: () {},
//                           child: DrawerNewWidget(
//                             icon: researchTools[index].iconData,
//                             text: researchTools[index].text,
//                           ),
//                         );
//                       },
//                     ),
//                     Text(
//                       "Financial Calendars",
//                       style: styleBaseBold(),
//                     ),
//                     CustomGridViewPerChild(
//                       paddingHorizontal: 5,
//                       paddingVertical: 25,
//                       childrenPerRow: 3,
//                       length: financialCalendar.length,
//                       getChild: (index) {
//                         return InkWell(
//                           onTap: () {},
//                           child: DrawerNewWidget(
//                             icon: financialCalendar[index].iconData,
//                             text: financialCalendar[index].text,
//                           ),
//                         );
//                       },
//                     ),
//                     Text(
//                       "Stock Lists",
//                       style: styleBaseBold(),
//                     ),
//                     CustomGridViewPerChild(
//                       paddingHorizontal: 5,
//                       paddingVertical: 25,
//                       childrenPerRow: 3,
//                       length: stockList.length,
//                       getChild: (index) {
//                         return InkWell(
//                           onTap: () {},
//                           child: DrawerNewWidget(
//                             icon: stockList[index].iconData,
//                             text: stockList[index].text,
//                           ),
//                         );
//                       },
//                     ),
//                     Text(
//                       "Headlines",
//                       style: styleBaseBold(),
//                     ),
//                     CustomGridViewPerChild(
//                       paddingHorizontal: 5,
//                       paddingVertical: 25,
//                       childrenPerRow: 3,
//                       length: headlines.length,
//                       getChild: (index) {
//                         return InkWell(
//                           onTap: () {},
//                           child: DrawerNewWidget(
//                             icon: headlines[index].iconData,
//                             text: headlines[index].text,
//                           ),
//                         );
//                       },
//                     ),
//                     Text(
//                       "Learn",
//                       style: styleBaseBold(),
//                     ),
//                     CustomGridViewPerChild(
//                       paddingHorizontal: 5,
//                       paddingVertical: 25,
//                       childrenPerRow: 3,
//                       length: learn.length,
//                       getChild: (index) {
//                         return InkWell(
//                           onTap: () {},
//                           child: DrawerNewWidget(
//                             icon: learn[index].iconData,
//                             text: learn[index].text,
//                           ),
//                         );
//                       },
//                     ),
//                     const SpacerVertical(
//                       height: 450,
//                     ),
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
