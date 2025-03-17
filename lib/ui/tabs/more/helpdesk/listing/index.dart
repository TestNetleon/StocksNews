import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/helpdesk.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/listing/item.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/tickets/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/helpdesk_error.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class RequestNewIndex extends StatefulWidget {
  static const String path = "RequestNewIndex";
  const RequestNewIndex({super.key});

  @override
  State<RequestNewIndex> createState() => _RequestNewIndexState();
}

class _RequestNewIndexState extends State<RequestNewIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      NewHelpDeskManager manager = context.read<NewHelpDeskManager>();
      manager.getTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    NewHelpDeskManager manager = context.watch<NewHelpDeskManager>();

    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: "Help Desk",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Pad.pad10),
        child: CommonEmptyError(
          hasData: manager.data?.helpDesk?.ticketList != null &&
              manager.data?.helpDesk?.ticketList?.isNotEmpty != true,
          isLoading: manager.isLoadingTickets,
          title: "Helpdesk",
          subTitle:
              manager.data?.helpDesk?.noTicketsMessage ?? manager.errorTickets,
          buttonText: "CREATE NEW TICKETS",
          onClick: () async {
            Navigator.pushNamed(context, HelpDeskCreateIndex.path);
          },
          child: BaseLoaderContainer(
            error: manager.data?.helpDesk?.noTicketsMessage ??
                manager.errorTickets,
            hasData: manager.data?.helpDesk?.ticketList != null &&
                manager.data?.helpDesk?.ticketList?.isNotEmpty == true,
            isLoading: manager.isLoadingTickets,
            showPreparingText: true,
            onRefresh: () => manager.getTickets(),
            child: CommonRefreshIndicator(
                onRefresh: () async {
                  manager.getTickets();
                },
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        //physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            manager.data?.helpDesk?.ticketList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return HelpDeskItemNew(index: index);
                        },
                        separatorBuilder: (context, index) {
                          return const BaseListDivider();
                        },
                      ),
                    ),
                    const SpacerVertical(),
                    /*
                      if (context.read<HelpDeskProvider>().extra?.disclaimer !=
                          null)
                        DisclaimerWidget(
                            data: context
                                .read<HelpDeskProvider>()
                                .extra!
                                .disclaimer!)*/
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
