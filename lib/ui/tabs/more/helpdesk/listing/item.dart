import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/helpdesk.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/chats/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HelpDeskItemNew extends StatelessWidget {
  const HelpDeskItemNew({
    required this.index,
    super.key,
  });
  final int index;

  @override
  Widget build(BuildContext context) {
    NewHelpDeskManager manager = context.watch<NewHelpDeskManager>();
    int status = manager.data?.helpDesk?.ticketList?[index].status ?? 0;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, HelpDeskAllChatsIndex.path, arguments: {
          "ticketId":
              manager.data?.helpDesk?.ticketList?[index].ticketId ?? "N/A"
        });
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(width: 1, color: ThemeColors.neutral5)),
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
                        shape: BoxShape.circle, color: ThemeColors.splashBG),
                    padding: const EdgeInsets.all(6),
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
                          style: styleBaseBold(fontSize: 16),
                        ),
                        const SpacerVertical(height: 4),
                        Text(
                          "${manager.data?.helpDesk?.ticketList?[index].message?.capitalize()}",
                          style: styleBaseRegular(
                              color: ThemeColors.neutral80, fontSize: 14),
                        ),
                        SpacerVertical(height: Pad.pad10),
                        Visibility(
                          visible: manager
                                  .data?.helpDesk?.ticketList?[index].status ==
                              0,
                          child: Text(
                            "Created on: ${manager.data?.helpDesk?.ticketList?[index].ticketDate}",
                            style: styleBaseRegular(
                                color: ThemeColors.neutral80, fontSize: 14),
                          ),
                        ),
                        Visibility(
                          visible: manager
                                  .data?.helpDesk?.ticketList?[index].status ==
                              1,
                          child: Text(
                            "Resolved on: ${manager.data?.helpDesk?.ticketList?[index].resolveDate ?? ""}",
                            style: styleBaseRegular(
                                color: ThemeColors.neutral80, fontSize: 14),
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
                            manager.data?.helpDesk?.ticketList?[index]
                                    .statusLabel ??
                                "",
                            style: styleBaseBold(
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
