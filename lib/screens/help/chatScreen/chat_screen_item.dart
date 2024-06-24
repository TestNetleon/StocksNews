import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/help_desk_provider.dart';
import 'package:stocks_news_new/utils/theme.dart';

class ChatScreenItem extends StatelessWidget {
  final int index;
  const ChatScreenItem({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    HelpDeskProvider provider = context.watch<HelpDeskProvider>();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Align(
        alignment: provider.chatData?.logs?[index].replyFrom == 1
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: provider.chatData?.logs?[index].replyFrom == 1
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${provider.chatData?.logs?[index].reply}",
                style: stylePTSansRegular(color: Colors.white, fontSize: 18),
              ),
              Text(
                "${provider.chatData?.logs?[index].replyTime}",
                style: stylePTSansRegular(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
