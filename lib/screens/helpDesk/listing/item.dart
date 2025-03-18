// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/help_desk.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import '../chats/index.dart';

// class HelpDeskItemNew extends StatelessWidget {
//   const HelpDeskItemNew({
//     required this.index,
//     super.key,
//     this.showBg = true,
//   });
//   final int index;
//   final bool showBg;

//   @override
//   Widget build(BuildContext context) {
//     NewHelpDeskProvider provider = context.watch<NewHelpDeskProvider>();

//     int status = provider.data?.tickets?[index].status ?? 0;

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HelpDeskAllChatsNew(
//               ticketId: provider.data?.tickets?[index].ticketId ?? "N/A",
//             ),
//           ),
//         );
//       },
//       child: Container(
//         decoration: showBg
//             ? BoxDecoration(
//                 border:
//                     Border.all(color: ThemeColors.greyBorder.withOpacity(0.4)),
//                 borderRadius: BorderRadius.circular(10),
//                 gradient: const LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Color.fromARGB(255, 23, 23, 23),
//                     Color.fromARGB(255, 48, 48, 48),
//                   ],
//                 ),
//               )
//             : BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.transparent,
//               ),
//         width: double.infinity,
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     decoration: const BoxDecoration(
//                         shape: BoxShape.circle, color: ThemeColors.accent),
//                     padding: const EdgeInsets.all(6),
//                     // child: const Icon(
//                     //   Icons.edit,
//                     //   size: 28,
//                     // ),
//                     child: Image.asset(
//                       Images.ticket,
//                       height: 26,
//                       width: 26,
//                       color: ThemeColors.white,
//                     ),
//                   ),
//                   const SpacerHorizontal(width: 10),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "#${provider.data?.tickets?[index].ticketNo} ${provider.data?.tickets?[index].subject}",
//                           style: styleBaseBold(fontSize: 16),
//                         ),
//                         const SpacerVertical(height: 4),
//                         Text(
//                           "${provider.data?.tickets?[index].message?.capitalize()}",
//                           style: styleBaseRegular(
//                               color: ThemeColors.greyText, fontSize: 14),
//                         ),
//                         // SpacerVertical(height: 10),
//                         // Text(
//                         //   "Resolved date: ",
//                         //   style: styleBaseRegular(
//                         //       color: ThemeColors.greyText, fontSize: 13),
//                         // ),

//                         const SpacerVertical(height: 12),
//                         Visibility(
//                           visible: provider.data?.tickets?[index].status == 0,
//                           child: Text(
//                             "Created on: ${provider.data?.tickets?[index].ticketDate}",
//                             style: styleBaseRegular(
//                                 color: ThemeColors.greyText, fontSize: 14),
//                           ),
//                         ),

//                         Visibility(
//                           visible: provider.data?.tickets?[index].status == 1,
//                           child: Text(
//                             "Resolved on: ${provider.data?.tickets?[index].resolvedOn ?? ""}",
//                             style: styleBaseRegular(
//                                 color: ThemeColors.greyText, fontSize: 14),
//                           ),
//                         ),
//                         const SpacerVertical(height: 8),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 4, horizontal: 15),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: status == 0
//                                   ? ThemeColors.blue
//                                   : status == 1 || status == 3
//                                       ? ThemeColors.sos
//                                       : status == 2
//                                           ? Colors.orange
//                                           : ThemeColors.greyBorder,
//                             ),
//                             // color: provider.data?.tickets?[index].status == 1
//                             //     ? const Color(0xfff8abad)
//                             //     : const Color(0xffc6f6f4),
//                             color: status == 0
//                                 ? Color(0xffc6f6f4)
//                                 : status == 1 || status == 3
//                                     ? Color(0xfff8abad)
//                                     : status == 2
//                                         ? Color(0xFFFFD089)
//                                         : ThemeColors.greyBorder,
//                             borderRadius: const BorderRadius.all(
//                               Radius.circular(4),
//                             ),
//                           ),
//                           child: Text(
//                             "${provider.data?.tickets?[index].statusText}",
//                             style: styleBaseBold(
//                                 color: Colors.black, fontSize: 14),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
