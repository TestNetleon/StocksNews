import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/help_desk_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HelpDeskItem extends StatelessWidget {
  const HelpDeskItem({required this.index, super.key});
  final int index;

  @override
  Widget build(BuildContext context) {
    HelpDeskProvider provider = context.watch<HelpDeskProvider>();

    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
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
                        "#${provider.data?.tickets?[index].ticketNo} ${provider.data?.tickets?[index].subject}",
                        style: stylePTSansBold(),
                      ),
                      Text(
                        "${provider.data?.tickets?[index].message}",
                        style: stylePTSansRegular(
                            color: ThemeColors.greyText, fontSize: 13),
                      ),
                      Text(
                        "${provider.data?.tickets?[index].ticketDate}",
                        style: stylePTSansRegular(
                            color: ThemeColors.greyText, fontSize: 13),
                      ),
                      const SpacerVertical(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                            color: provider.data?.tickets?[index].status == 1
                                ? const Color(0xfff8abad)
                                : const Color(0xffc6f6f4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4))),
                        child: Text(
                          "${provider.data?.tickets?[index].statusText}",
                          style: stylePTSansRegular(
                              color: ThemeColors.greyText, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
