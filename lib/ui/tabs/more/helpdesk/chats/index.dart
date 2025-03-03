/*
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/help_desk.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import 'container.dart';

class HelpDeskAllChatsNew extends StatefulWidget {
  final String ticketId;
  const HelpDeskAllChatsNew({super.key, required this.ticketId});

  @override
  State<HelpDeskAllChatsNew> createState() => _HelpDeskAllChatsNewState();
}

class _HelpDeskAllChatsNewState extends State<HelpDeskAllChatsNew> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewHelpDeskProvider>().getAllChats(
            ticketId: widget.ticketId,
            showProgress: false,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    NewHelpDeskProvider provider = context.watch<NewHelpDeskProvider>();
    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
        title: "Ticker Number: ${provider.chatData?.ticketNo ?? ""}",
      ),
      body: HelpDeskAllChatNewListing(
        ticketId: widget.ticketId,
      ),
    );
  }
}
*/
