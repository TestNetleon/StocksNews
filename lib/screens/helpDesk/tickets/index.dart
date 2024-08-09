import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/help_desk.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import '../../../utils/colors.dart';
import '../../../widgets/screen_title.dart';
import 'item.dart';

class HelpDeskCreateTicket extends StatelessWidget {
  const HelpDeskCreateTicket({super.key});

  @override
  Widget build(BuildContext context) {
    NewHelpDeskProvider provider = context.watch<NewHelpDeskProvider>();
    return BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        title: provider.extraTickets?.title ?? "Help Desk",
      ),
      body: Column(
        children: [
          const Expanded(
            child: SizedBox(),
          ),
          Container(
            constraints: const BoxConstraints(maxHeight: 400),
            decoration: const BoxDecoration(
              color: ThemeColors.primaryLight,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ScreenTitle(
                    title: 'Select Ticket Subject',
                    divider: false,
                    dividerPadding: EdgeInsets.only(bottom: 20),
                  ),
                  provider.data?.subjects == null ||
                          provider.data?.subjects?.isEmpty == true
                      ? Text(
                          provider.errorSubject ?? "N/A",
                          style: styleSansBold(color: ThemeColors.white),
                        )
                      : HelpDeskReasonsNew(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
