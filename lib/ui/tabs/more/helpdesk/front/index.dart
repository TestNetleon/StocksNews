import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/helpdesk.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/button_outline.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/listing/index.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/listing/item.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/tickets/index.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HelpDeskIndex extends StatefulWidget {
  static const String path = "HelpDeskIndex";
  const HelpDeskIndex({super.key});

  @override
  State<HelpDeskIndex> createState() => _HelpDeskIndexState();
}

class _HelpDeskIndexState extends State<HelpDeskIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    NewHelpDeskManager manager = context.read<NewHelpDeskManager>();
    manager.getTickets();
  }

  void _onViewAllRequestClick() {
    // Navigator.pushNamed(context, RequestNewIndex.path);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RequestNewIndex()));
  }

  @override
  Widget build(BuildContext context) {
    NewHelpDeskManager manager = context.watch<NewHelpDeskManager>();
    return Consumer<ThemeManager>(
      builder: (context, value, child) {
        return BaseScaffold(
          appBar: BaseAppBar(
            showBack: true,
            title: manager.data?.title ?? "",
            showSearch: true,
            showNotification: true,
          ),
          body: BaseLoaderContainer(
            isLoading: manager.isLoadingTickets,
            hasData: manager.data != null && !manager.isLoadingTickets,
            showPreparingText: true,
            error: manager.data?.helpDesk?.noTicketsMessage ?? manager.error,
            onRefresh: () {
              _callAPI();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Pad.pad16, vertical: Pad.pad8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: manager.data?.subTitle != '',
                    child: Text(
                      textAlign: TextAlign.start,
                      manager.data?.subTitle ?? "",
                      style: styleBaseRegular(
                          fontSize: 16, color: ThemeColors.neutral80),
                    ),
                  ),
                  SpacerVertical(height: 10),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 8, 8, 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Consumer<ThemeManager>(
                              builder: (context, value, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ThemeColors.black,
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.edit_note_outlined,
                                    size: 28,
                                    color:
                                        // value.isDarkMode
                                        //     ? ThemeColors.white
                                        //     :
                                        ThemeColors.white,
                                  ),
                                );
                              },
                            ),
                            const SpacerHorizontal(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tickets",
                                    style: styleBaseBold(
                                        color: ThemeColors.splashBG),
                                  ),
                                  Text(
                                    "${manager.data?.helpDesk?.header?.activeTicketsCount ?? 0} Active",
                                    style: styleBaseSemiBold(
                                        color: ThemeColors.neutral80,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: (manager.data?.helpDesk?.subjects
                                          ?.isNotEmpty ==
                                      true &&
                                  manager.data?.helpDesk?.subjects != null),
                              child: InkWell(
                                onTap: () {
                                  // Navigator.pushNamed(
                                  //     context, HelpDeskCreateIndex.path);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HelpDeskCreateIndex()));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Pad.pad8, vertical: Pad.pad8),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      border: Border.all(
                                          width: 1,
                                          color: ThemeColors.neutral5)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "CREATE NEW",
                                        style: styleBaseBold(
                                            fontSize: 13,
                                            color: ThemeColors.splashBG),
                                      ),
                                      const SpacerHorizontal(width: 5),
                                      Icon(Icons.add_circle_outline_rounded,
                                          size: 16,
                                          color: ThemeColors.splashBG),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (manager.data?.helpDesk?.ticketList == null ||
                          manager.data?.helpDesk?.ticketList?.isEmpty == true)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Pad.pad10, horizontal: Pad.pad10),
                          child: Text(
                            manager.isLoading
                                ? "Loading your complaint box"
                                : "Great, the complaint box is empty",
                            textAlign: TextAlign.start,
                            style: styleBaseRegular(
                                color: ThemeColors.neutral80, fontSize: 20),
                          ),
                        ),
                      if (manager.data?.helpDesk?.ticketList != null &&
                          manager.data?.helpDesk?.ticketList?.isNotEmpty ==
                              true &&
                          manager.data?.helpDesk?.ticketList?[0].status == 0)
                        HelpDeskItemNew(index: 0),
                      BaseButtonOutline(
                        margin: EdgeInsets.only(top: Pad.pad16),
                        onPressed: () {
                          _onViewAllRequestClick();
                        },
                        text: "View all Requests",
                        textColor: ThemeColors.splashBG,
                        borderColor: ThemeColors.neutral5,
                        borderWidth: 1,
                      ),
                    ],
                  ),
                  Expanded(
                    child: CommonRefreshIndicator(
                      onRefresh: () => manager.getTickets(),
                      child: Visibility(
                        visible: manager.data?.helpDesk?.ticketList != null &&
                            manager.data?.helpDesk?.ticketList?.isNotEmpty ==
                                true,
                        child: ListView.separated(
                          itemCount: (manager
                                          .data?.helpDesk?.ticketList?.length ??
                                      0) <
                                  5
                              ? manager.data?.helpDesk?.ticketList?.length ?? 0
                              : 5,
                          itemBuilder: (context, index) {
                            if (index == 0 &&
                                manager.data?.helpDesk?.ticketList?[index]
                                        .status ==
                                    0) {
                              return const SizedBox();
                            }
                            return HelpDeskItemNew(index: index);
                          },
                          separatorBuilder: (context, index) {
                            return const SpacerVertical(height: Pad.pad16);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
