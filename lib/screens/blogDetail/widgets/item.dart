// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';

// class BlogDetailClickItem extends StatelessWidget {
//   final String? title;

//   final List<Widget> children;
//   final bool fromNews, showTopDivider, showBottomDivider;
// //
//   const BlogDetailClickItem(
//       {super.key,
//       this.title,
//       required this.children,
//       this.fromNews = false,
//       this.showTopDivider = false,
//       this.showBottomDivider = false});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Visibility(
//           visible: showTopDivider,
//           child: Divider(
//             color: ThemeColors.divider,
//             height: 10,
//           ),
//         ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Visibility(
//               visible: title != null,
//               child: Text(
//                 title ?? "",
//                 style: styleBaseBold(
//                   fontSize: 12,
//                   color: ThemeColors.white,
//                 ),
//               ),
//             ),
//             Flexible(
//               child: Wrap(
//                 alignment: WrapAlignment.start,
//                 spacing: fromNews ? 0 : 6,
//                 runSpacing: fromNews ? 0 : 6,
//                 children: children,
//               ),
//             ),
//           ],
//         ),
//         Visibility(
//           visible: showBottomDivider,
//           child: Divider(
//             color: ThemeColors.divider,
//             height: 10,
//           ),
//         ),
//       ],
//     );
//   }
// }
