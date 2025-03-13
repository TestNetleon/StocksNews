// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class ReferCardHeader extends StatelessWidget {
//   const ReferCardHeader({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 190, // Adjust the height to fit your needs
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: 10, // Number of items in the list
//         itemBuilder: (context, index) {
//           return Container(
//             width: 190, // Adjust the width to fit your needs
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: ThemeColors.background,
//             ), // Adjust the width to fit your needs
//             margin: const EdgeInsets.only(
//                 left: Dimen.padding, right: Dimen.padding),
//             padding: const EdgeInsets.all(Dimen.padding),

//             child: Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(
//                     Icons.request_page_sharp,
//                     size: 50,
//                   ),
//                   const SpacerVertical(height: 10),
//                   Text(
//                     'Instant USDT Payouts in your wallet',
//                     style: styleBaseRegular(),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
