import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:stocks_news_new/providers/help_desk_provider.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../utils/colors.dart';

class ChatScreenItem extends StatelessWidget {
  final int index;
  const ChatScreenItem({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    HelpDeskProvider provider = context.watch<HelpDeskProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Align(
        alignment: provider.chatData?.logs?[index].replyFrom == 1
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Container(
          margin: provider.chatData?.logs?[index].replyFrom == 1
              ? const EdgeInsets.only(right: 40)
              : const EdgeInsets.only(left: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: provider.chatData?.logs?[index].replyFrom == 1
                // ? const Color.fromARGB(255, 9, 123, 24)
                ? const Color.fromARGB(255, 48, 48, 48)
                : const Color.fromARGB(255, 9, 123, 24),
          ),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(
              //   "${provider.chatData?.logs?[index].reply?.capitalize()}",
              //   style: stylePTSansRegular(color: Colors.white, fontSize: 18),
              // ),

              ReadMoreText(
                textAlign: TextAlign.start,
                "${provider.chatData?.logs?[index].reply?.capitalize()}",
                trimLines: 10,
                colorClickableText: ThemeColors.accent,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' Read more',
                trimExpandedText: ' Read less',
                moreStyle: stylePTSansRegular(
                  color: ThemeColors.accent,
                  fontSize: 16,
                  height: 1.3,
                ),
                style: stylePTSansRegular(color: Colors.white, fontSize: 18),
              ),

              const SpacerVertical(height: 8),
              Text(
                "${provider.chatData?.logs?[index].replyTime}",
                style: stylePTSansRegular(
                    color: const Color.fromARGB(255, 190, 190, 192),
                    fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
