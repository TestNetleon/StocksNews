// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/help_desk_provider.dart';
// import 'package:stocks_news_new/route/my_app.dart';
// import 'package:stocks_news_new/screens/help/chatScreen/chat_screen.dart';
// import 'package:stocks_news_new/screens/help/widget/help_desk_item.dart';
// import 'package:stocks_news_new/screens/help/widget/view_all_list.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/screen_title.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class Tickets extends StatelessWidget {
//   static const String path = "Tickets";

//   const Tickets({super.key});

//   @override
//   Widget build(BuildContext context) {
//     HelpDeskProvider provider = context.watch<HelpDeskProvider>();

//     return Column(
//       children: [
//         ScreenTitle(
//             title: provider.extra?.title ?? "Helpdesk",
//             subTitle: provider.extra?.subTitle),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             gradient: const LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color.fromARGB(255, 23, 23, 23),
//                 Color.fromARGB(255, 48, 48, 48),
//               ],
//             ),
//           ),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Container(
//                       decoration: const BoxDecoration(
//                           shape: BoxShape.circle, color: ThemeColors.accent),
//                       padding: const EdgeInsets.all(5),
//                       child: const Icon(
//                         Icons.edit_note_outlined,
//                         size: 28,
//                       ),
//                     ),
//                     const SpacerHorizontal(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Tickets",
//                             style: stylePTSansBold(),
//                           ),
//                           Text(
//                             "${provider.data?.totalTickets ?? 0} Active",
//                             style: stylePTSansRegular(
//                                 color: ThemeColors.greyText, fontSize: 13),
//                           ),
//                         ],
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           navigatorKey.currentContext!,
//                           MaterialPageRoute(
//                               builder: (_) => ChatScreen(
//                                     slug: "0",
//                                     ticketId: provider.data?.tickets?.isEmpty ==
//                                             true
//                                         ? ""
//                                         : provider.data?.tickets?[0].ticketId ??
//                                             "",
//                                   )),
//                         );

//                         context
//                             .read<HelpDeskProvider>()
//                             .setReasonController("", "");
//                       },
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "CREATE NEW",
//                             style: stylePTSansBold(fontSize: 13),
//                           ),
//                           const SpacerHorizontal(width: 5),
//                           const Icon(
//                             Icons.add_circle_outline_rounded,
//                             size: 16,
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               if (provider.data?.tickets != null &&
//                   provider.data?.tickets?.isNotEmpty == true)
//                 const HelpDeskItem(
//                   index: 0,
//                 ),
//               const Divider(
//                 color: ThemeColors.dividerDark,
//                 height: 1,
//               ),
//               GestureDetector(
//                 onTap: () => _onViewAllRequestClick(),
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Text(
//                     "View all Requests",
//                     style: styleGeorgiaBold(),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SpacerVertical(),
//       ],
//     );
//   }

//   _onViewAllRequestClick() {
//     Navigator.push(
//       navigatorKey.currentContext!,
//       MaterialPageRoute(builder: (_) => const ViewAllList(slug: null)),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/help_desk_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/help/chatScreen/chat_screen.dart';
import 'package:stocks_news_new/screens/help/widget/help_desk_item.dart';
import 'package:stocks_news_new/screens/help/widget/view_all_list.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class Tickets extends StatelessWidget {
  static const String path = "Tickets";

  const Tickets({super.key});

  @override
  Widget build(BuildContext context) {
    HelpDeskProvider provider = context.watch<HelpDeskProvider>();

    return Column(
      children: [
        ScreenTitle(
            title: provider.extra?.title ?? "Helpdesk",
            subTitle: provider.extra?.subTitle),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 23, 23, 23),
                Color.fromARGB(255, 48, 48, 48),
              ],
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(15, 8, 8, 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: ThemeColors.accent),
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.edit_note_outlined,
                        size: 28,
                      ),
                    ),
                    const SpacerHorizontal(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tickets",
                            style: stylePTSansBold(),
                          ),
                          Text(
                            "${provider.data?.totalTickets ?? 0} Active",
                            style: stylePTSansRegular(
                                color: ThemeColors.greyText, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !provider.isLoading,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            navigatorKey.currentContext!,
                            MaterialPageRoute(
                                builder: (_) => ChatScreen(
                                      slug: "0",
                                      ticketId:
                                          provider.data?.tickets?.isEmpty ==
                                                  true
                                              ? ""
                                              : provider.data?.tickets?[0]
                                                      .ticketId ??
                                                  "",
                                    )),
                          );

                          context
                              .read<HelpDeskProvider>()
                              .setReasonController("", "");
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(25, 10, 15, 10),
                          decoration: BoxDecoration(
                            color: ThemeColors.greyBorder.withOpacity(0.4),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(80),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "CREATE NEW",
                                style: stylePTSansBold(fontSize: 13),
                              ),
                              const SpacerHorizontal(width: 5),
                              const Icon(
                                Icons.add_circle_outline_rounded,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (provider.data?.tickets == null ||
                  provider.data?.tickets?.isEmpty == true)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                  child: Text(
                    "Great, the complaint box is empty",
                    textAlign: TextAlign.center,
                    style: stylePTSansRegular(
                        color: ThemeColors.greyText, fontSize: 20),
                  ),
                ),
              if (provider.data?.tickets != null &&
                  provider.data?.tickets?.isNotEmpty == true)
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        navigatorKey.currentContext!,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            slug: "1",
                            ticketId: "${provider.data?.tickets?[0].ticketId}",
                          ),
                        ),
                      );

                      context.read<HelpDeskProvider>().setSlug(
                          "1", '${provider.data?.tickets?[0].ticketId}');
                      context.read<HelpDeskProvider>().setReasonController(
                          "${provider.data?.subjects?[0].title}",
                          "${provider.data?.subjects?[0].id}");
                    },
                    child: const HelpDeskItem(
                      index: 0,
                      showBg: false,
                    )),
              const Divider(
                color: ThemeColors.dividerDark,
                height: 1,
              ),
              GestureDetector(
                onTap: () => _onViewAllRequestClick(),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "View all Requests",
                    style: styleGeorgiaBold(),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SpacerVertical(),
      ],
    );
  }

  _onViewAllRequestClick() {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => const ViewAllList(slug: null)),
    );
  }
}
