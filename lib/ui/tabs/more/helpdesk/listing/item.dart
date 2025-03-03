

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/helpdesk.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HelpDeskItemNew extends StatelessWidget {
  const HelpDeskItemNew({
    required this.index,
    super.key,
    this.showBg = true,
  });
  final int index;
  final bool showBg;

  @override
  Widget build(BuildContext context) {
    NewHelpDeskManager manager = context.watch<NewHelpDeskManager>();

    int status = manager.data?.helpDesk?.ticketList?[index].status ?? 0;

    return GestureDetector(
      onTap: () {
       /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HelpDeskAllChatsNew(
              ticketId: manager.data?.helpDesk?.ticketList?[index].ticketId ?? "N/A",
            ),
          ),
        );*/
      },
      child: Container(
        decoration: showBg
            ? BoxDecoration(
                border:
                    Border.all(color: ThemeColors.greyBorder.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(255, 23, 23, 23),
                    Color.fromARGB(255, 48, 48, 48),
                  ],
                ),
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: ThemeColors.accent),
                    padding: const EdgeInsets.all(6),
                    // child: const Icon(
                    //   Icons.edit,
                    //   size: 28,
                    // ),
                    child: Image.asset(
                      Images.ticket,
                      height: 26,
                      width: 26,
                      color: ThemeColors.white,
                    ),
                  ),
                  const SpacerHorizontal(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "#${manager.data?.helpDesk?.ticketList?[index].ticketNo} ${manager.data?.helpDesk?.ticketList?[index].subject}",
                          style: stylePTSansBold(fontSize: 16),
                        ),
                        const SpacerVertical(height: 4),
                        Text(
                          "${manager.data?.helpDesk?.ticketList?[index].message?.capitalize()}",
                          style: stylePTSansRegular(
                              color: ThemeColors.greyText, fontSize: 14),
                        ),

                        const SpacerVertical(height: 12),
                        Visibility(
                          visible: manager.data?.helpDesk?.ticketList?[index].status == 0,
                          child: Text(
                            "Created on: ${manager.data?.helpDesk?.ticketList?[index].ticketDate}",
                            style: stylePTSansRegular(
                                color: ThemeColors.greyText, fontSize: 14),
                          ),
                        ),

                        Visibility(
                          visible: manager.data?.helpDesk?.ticketList?[index].status == 1,
                          child: Text(
                            "Resolved on: ${manager.data?.helpDesk?.ticketList?[index].resolveDate ?? ""}",
                            style: stylePTSansRegular(
                                color: ThemeColors.greyText, fontSize: 14),
                          ),
                        ),
                        const SpacerVertical(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: status == 0
                                  ? ThemeColors.blue
                                  : status == 1 || status == 3
                                      ? ThemeColors.sos
                                      : status == 2
                                          ? Colors.orange
                                          : ThemeColors.greyBorder,
                            ),

                            color: status == 0
                                ? Color(0xffc6f6f4)
                                : status == 1 || status == 3
                                    ? Color(0xfff8abad)
                                    : status == 2
                                        ? Color(0xFFFFD089)
                                        : ThemeColors.greyBorder,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                          child: Text(
                            "${manager.data?.helpDesk?.ticketList?[index].statusLabel}",
                            style: stylePTSansBold(
                                color: Colors.black, fontSize: 14),
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
      ),
    );
  }
}
