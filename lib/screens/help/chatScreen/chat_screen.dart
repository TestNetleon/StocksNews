// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/screens/help/chatScreen/chat_screen_list.dart';
// import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
// import 'package:stocks_news_new/widgets/base_container.dart';

// import '../../../providers/help_desk_provider.dart';

// class ChatScreen extends StatelessWidget {
//   static const String path = "ChatScreen";

//   final String? slug;
//   final String? ticketId;

//   const ChatScreen({
//     this.slug,
//     this.ticketId,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     HelpDeskProvider provider = context.watch<HelpDeskProvider>();
//     return BaseContainer(
//       // bottomSafeAreaColor:
//       //     provider.slug == "0" ? ThemeColors.primaryLight : null,
//       appBar: AppBarHome(
//         isPopback: true,
//         title: "Ticker Number: ${provider.chatData?.ticketNo ?? ""}",
//       ),
//       body: ChatScreenList(
//         slug: slug,
//         ticketId: ticketId,
//       ),
//     );
//   }
// }
