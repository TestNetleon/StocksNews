// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/screens/MsAnalysis/performance_tabbarview/overview.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';

// class PerformanceTabBar extends StatefulWidget {
//   const PerformanceTabBar({super.key});

//   @override
//   State<PerformanceTabBar> createState() => _PerformanceTabBarState();
// }

// class _PerformanceTabBarState extends State<PerformanceTabBar>
//     with SingleTickerProviderStateMixin {
//   late TabController controller;

//   @override
//   void initState() {
//     super.initState();

//     controller = TabController(vsync: this, length: 3);
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   List<String> menus = [
//     'Overview',
//     'News',
//     'Events',
//   ];

//   int selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CupertinoSlidingSegmentedControl<int>(
//           groupValue: selectedIndex,
//           thumbColor: ThemeColors.greyBorder.withOpacity(0.4),
//           padding: const EdgeInsets.all(4),
//           backgroundColor: const Color.fromARGB(255, 28, 28, 28),
//           onValueChanged: (int? index) {
//             setState(() {
//               if (index == 0) {
//                 selectedIndex = index!;
//               } else if (index == 1) {
//                 selectedIndex = index!;
//               } else if (index == 2) {
//                 selectedIndex = index!;
//               }
//             });
//           },
//           children: {
//             for (int i = 0; i < menus.length; i++)
//               i: SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 // padding:const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//                 child: Center(
//                   child: Text(
//                     menus[i],
//                     style: styleGeorgiaRegular(
//                       fontSize: 13,
//                       color: selectedIndex == i
//                           ? ThemeColors.accent
//                           : ThemeColors.white,
//                       //color: ThemeColors.white,
//                     ),
//                   ),
//                 ),
//               ),
//           },
//         ),
//         selectedIndex == 0
//             ? PerformanceOverview()
//             : selectedIndex == 1
//                 ? Text('hello')
//                 : selectedIndex == 2
//                     ? Text('hiii')
//                     : PerformanceOverview(),
//       ],
//     );
//   }
// }
