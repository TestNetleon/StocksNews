// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

// import '../../../providers/search_provider.dart';
// import '../../../utils/colors.dart';

// class DrawerTopNew extends StatelessWidget {
//   final String? text;
//   const DrawerTopNew({super.key, this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         IconButton(
//           onPressed: () {
//             context.read<SearchProvider>().clearSearch();
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: ThemeColors.white,
//           ),
//         ),
//         Text(
//           text ?? "",
//           style: styleBaseBold(fontSize: 20),
//         ),
//         const SpacerHorizontal(width: 40),
//         // IconButton(
//         //   onPressed: () {},
//         //   icon: const Icon(
//         //     Icons.settings,
//         //     color: ThemeColors.white,
//         //   ),
//         // ),
//         // Row(
//         //   children: [
//         // IconButton(
//         //   onPressed: () {
//         //     if (provider.user != null) {
//         //       homeProvider.setNotification(true);
//         //     }
//         //     Navigator.push(context, Notifications.path);
//         //   },
//         //   icon: const Icon(
//         //     Icons.notifications,
//         //     color: ThemeColors.white,
//         //   ),
//         // ),
//         // const SpacerHorizontal(width: 5),
//         // IconButton(
//         //   onPressed: () {},
//         //   icon: const Icon(
//         //     Icons.settings,
//         //     color: ThemeColors.white,
//         //   ),
//         // ),
//         //   ],
//         // )
//       ],
//     );
//   }
// }
