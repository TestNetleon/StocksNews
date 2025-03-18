import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/helpdesk.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/chats/container.dart';

class HelpDeskAllChatsIndex extends StatefulWidget {
  static const String path = "HelpDeskAllChatsIndex";
  final String ticketId;
  const HelpDeskAllChatsIndex({super.key, required this.ticketId});

  @override
  State<HelpDeskAllChatsIndex> createState() => _HelpDeskAllChatsIndexState();
}

class _HelpDeskAllChatsIndexState extends State<HelpDeskAllChatsIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewHelpDeskManager>().getAllChats(
            ticketId: widget.ticketId,
            showProgress: false,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    NewHelpDeskManager manager = context.watch<NewHelpDeskManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: "Ticket Number: ${manager.chatData?.chatRes?.ticketNo ?? ""}",
      ),
      body: AllChatNewListing(
        ticketId: widget.ticketId,
      ),
    );
  }
}
