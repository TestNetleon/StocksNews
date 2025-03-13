import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/helpdesk.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/tickets/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

class HelpDeskCreateIndex extends StatelessWidget {
  static const String path = "HelpDeskCreate";

  const HelpDeskCreateIndex({super.key});

  @override
  Widget build(BuildContext context) {
    NewHelpDeskManager manager = context.watch<NewHelpDeskManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: manager.data?.title,
      ),
      body: Column(
        children: [
          const Expanded(
            child: SizedBox(),
          ),
          Container(
            constraints: const BoxConstraints(maxHeight: 400),
            decoration: BoxDecoration(
                color: ThemeColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Pad.pad24),
                  topRight: Radius.circular(Pad.pad24),
                ),
                border: Border.all(color: ThemeColors.neutral5)),
            padding: const EdgeInsets.symmetric(
                horizontal: Pad.pad16, vertical: Pad.pad10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseHeading(
                    title: 'Select Ticket Subject',
                  ),
                  manager.data?.helpDesk?.subjects == null ||
                          manager.data?.helpDesk?.subjects?.isEmpty == true
                      ? Text(
                          manager.errorSubject ?? "N/A",
                          style: styleBaseBold(color: ThemeColors.white),
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
