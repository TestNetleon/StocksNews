// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/screens/tabs/tabs.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:stocks_news_new/widgets/theme_button_small.dart';

// class NoDataCustom extends StatelessWidget {
//   final String error;
//   final bool showHome;
//   final bool showDivider;
//   final Function()? onRefresh;
//   const NoDataCustom({
//     super.key,
//     this.error = Const.errSomethingWrong,
//     this.onRefresh,
//     this.showHome = false,
//     this.showDivider = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Visibility(
//               //   visible: showDivider,
//               //   child: const Divider(
//               //     color: ThemeColors.greyBorder,
//               //     height: 30,
//               //   ),
//               // ),
//               Visibility(
//                 visible: showDivider,
//                 child: const SpacerVertical(
//                   height: 30,
//                 ),
//               ),
//               Text(
//                 error,
//                 textAlign: TextAlign.center,
//                 style: styleBaseRegular(color: ThemeColors.white),
//               ),
//               const SpacerVertical(height: 40),
//               Image.asset(
//                 Images.noDataGIF,
//                 height: 165,
//                 width: double.infinity,
//                 fit: BoxFit.contain,
//               ),
//               const SpacerVertical(height: 40),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Visibility(
//                     visible: showHome,
//                     child: ThemeButtonSmall(
//                       icon: Icons.home,
//                       onPressed: () {
//                         Navigator.pushAndRemoveUntil(
//                             context, Tabs.path, (route) => false);
//                       },
//                       text: "Go to Home",
//                     ),
//                   ),
//                   Visibility(
//                     visible: onRefresh != null,
//                     child: ThemeButtonSmall(
//                       icon: Icons.refresh,
//                       onPressed: onRefresh ?? () => null,
//                       text: "Refresh",
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
