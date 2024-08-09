import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/help_desk.dart';
import 'package:stocks_news_new/providers/help_desk_provider.dart';
import 'package:stocks_news_new/screens/helpDesk/listing/item.dart';
import 'package:stocks_news_new/screens/helpDesk/tickets/index.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/helpdesk_error.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../utils/utils.dart';

class HelpDeskAllRequestNew extends StatefulWidget {
  const HelpDeskAllRequestNew({super.key});

  @override
  State<HelpDeskAllRequestNew> createState() => _HelpDeskAllRequestNewState();
}

class _HelpDeskAllRequestNewState extends State<HelpDeskAllRequestNew> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      NewHelpDeskProvider provider = context.read<NewHelpDeskProvider>();
      provider.getTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    NewHelpDeskProvider provider = context.watch<NewHelpDeskProvider>();

    return BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        title: "Help Desk",
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
        child: CommonEmptyError(
          hasData: provider.data?.tickets != null &&
              provider.data?.tickets?.isNotEmpty != true,
          isLoading: provider.isLoadingTickets,
          title: "Helpdesk",
          subTitle: provider.data?.noTicketMsg ?? provider.errorTickets,
          buttonText: "CREATE NEW TICKETS",
          onClick: () async {
            Utils().showLog("Create NEW");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HelpDeskCreateTicket(),
              ),
            );
          },
          child: BaseUiContainer(
            error: provider.data?.noTicketMsg ?? provider.errorTickets,
            hasData: provider.data?.tickets != null &&
                provider.data?.tickets?.isNotEmpty == true,
            isLoading: provider.isLoadingTickets,
            errorDispCommon: true,
            isFull: true,
            showPreparingText: true,
            onRefresh: () => provider.getTickets(),
            child: CommonRefreshIndicator(
              onRefresh: () async {
                provider.getTickets();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.data?.tickets?.length ?? 0,
                        itemBuilder: (context, index) {
                          return HelpDeskItemNew(index: index);
                        },
                        separatorBuilder: (context, index) {
                          return const Divider(color: Colors.white12);
                        },
                      ),
                      const SpacerVertical(),
                      if (context.read<HelpDeskProvider>().extra?.disclaimer !=
                          null)
                        DisclaimerWidget(
                            data: context
                                .read<HelpDeskProvider>()
                                .extra!
                                .disclaimer!)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
