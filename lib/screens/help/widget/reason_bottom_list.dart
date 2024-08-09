// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/help_desk_provider.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';

// import '../../../route/my_app.dart';

// class SelectReasonBottomSheet extends StatelessWidget {
//   const SelectReasonBottomSheet({super.key});

//   @override
//   Widget build(BuildContext context) {
//     HelpDeskProvider provider = context.watch<HelpDeskProvider>();
//     return SizedBox(
//       width: double.infinity,
//       child: Wrap(
//         spacing: 8.0,
//         runSpacing: 4.0,
//         children: provider.data?.subjects?.map((subject) {
//               return GestureDetector(
//                 onTap: () {
//                   context
//                       .read<HelpDeskProvider>()
//                       .setReasonController(subject.title, subject.id);
//                   _onSendTicketClick(subject.title);
//                 },
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//                   decoration: const BoxDecoration(
//                     color: ThemeColors.background,
//                     borderRadius: BorderRadius.all(Radius.circular(20)),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                         left: 10.0,
//                         right: 10), // Remove '.sp' if not using ScreenUtil
//                     child: Text(
//                       subject.title ?? "",
//                       style: stylePTSansBold(color: Colors.white, fontSize: 14),
//                     ),
//                   ),
//                 ),
//               );
//             }).toList() ??
//             [],
//       ),
//     );

//     // return SingleChildScrollView(
//     //   child: ListView.separated(
//     //     shrinkWrap: true,
//     //     physics: const NeverScrollableScrollPhysics(),
//     //     itemCount: provider.data?.subjects?.length ?? 0,
//     //     itemBuilder: (context, index) {
//     //       return GestureDetector(
//     // onTap: () {
//     //   context.read<HelpDeskProvider>().setReasonController(
//     //       provider.data?.subjects?[index].title,
//     //       provider.data?.subjects?[index].id);
//     // },
//     // child: Container(
//     //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//     //   decoration: const BoxDecoration(
//     //       color: ThemeColors.background,
//     //       borderRadius: BorderRadius.all(Radius.circular(20))),
//     //   child: Padding(
//     //     padding: EdgeInsets.only(left: 10.sp),
//     //     child: SizedBox(
//     //       child: Text(
//     //         provider.data?.subjects?[index].title ?? "",
//     //         style: stylePTSansBold(color: Colors.white, fontSize: 14),
//     //       ),
//     //     ),
//     //   ),
//     // ),
//     //       );
//     //     },
//     //     separatorBuilder: (context, index) {
//     //       return const Divider();
//     //     },
//     //   ),
//     // );
//   }

//   void _onSendTicketClick(msg) {
//     HelpDeskProvider provider =
//         navigatorKey.currentContext!.read<HelpDeskProvider>();
//     provider.setMessage(msg);

//     provider.chatData?.logs?.clear();

//     closeKeyboard();

//     provider.sendTicket();
//     return;
//   }
// }
