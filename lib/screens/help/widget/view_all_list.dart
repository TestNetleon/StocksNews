import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/help_desk_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/help/chatScreen/chat_screen.dart';
import 'package:stocks_news_new/screens/help/widget/help_desk_item.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/helpdesk_error.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class ViewAllList extends StatefulWidget {
  static const String path = "ViewAllList";

  final String? slug;
  const ViewAllList({required this.slug, super.key});

  @override
  State<ViewAllList> createState() => _ViewAllListState();
}

class _ViewAllListState extends State<ViewAllList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      HelpDeskProvider provider = context.read<HelpDeskProvider>();

      provider.getHelpDeskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    HelpDeskProvider provider = context.watch<HelpDeskProvider>();

    return BaseContainer(
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      body: Padding(
        padding: EdgeInsets.all(Dimen.padding.sp),
        child: CommonEmptyError(
          hasData: provider.data?.tickets == null ||
              provider.data?.tickets?.isNotEmpty != true,
          isLoading: provider.isLoading,
          title: "Helpdesk",
          subTitle: provider.data?.noTicketMsg ?? provider.error,
          buttonText: "CREATE NEW TICKETS",
          onClick: () async {
            Navigator.push(
              navigatorKey.currentContext!,
              MaterialPageRoute(
                  builder: (_) => ChatScreen(
                        slug: "0",
                        ticketId: provider.data?.tickets?.isEmpty == true
                            ? ""
                            : provider.data?.tickets?[0].ticketId ?? "",
                      )),
            );

            context.read<HelpDeskProvider>().setReasonController("", "");
          },
          child: BaseUiContainer(
            error: provider.data?.noTicketMsg ?? provider.error,
            hasData: provider.data?.tickets != null &&
                provider.data?.tickets?.isNotEmpty == true,
            isLoading: provider.isLoading,
            errorDispCommon: true,
            showPreparingText: true,
            onRefresh: () => provider.getHelpDeskList(),
            child: RefreshControl(
              onRefresh: () async => provider.getHelpDeskList(),
              canLoadMore: false,
              onLoadMore: () async => {},
              child: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(10),
                        //   gradient: const LinearGradient(
                        //     begin: Alignment.topCenter,
                        //     end: Alignment.bottomCenter,
                        //     colors: [
                        //       Color.fromARGB(255, 23, 23, 23),
                        //       Color.fromARGB(255, 48, 48, 48),
                        //     ],
                        //   ),
                        // ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.data?.tickets?.length ?? 0,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  navigatorKey.currentContext!,
                                  MaterialPageRoute(
                                      builder: (_) => ChatScreen(
                                            slug: "1",
                                            ticketId:
                                                "${provider.data?.tickets?[index].ticketId}",
                                          )),
                                );

                                context.read<HelpDeskProvider>().setSlug("1",
                                    '${provider.data?.tickets?[index].ticketId}');
                                context
                                    .read<HelpDeskProvider>()
                                    .setReasonController(
                                        "${provider.data?.subjects?[index].title}",
                                        "${provider.data?.subjects?[index].id}");
                              },
                              child: HelpDeskItem(
                                index: index,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(color: Colors.white12);
                          },
                        ),
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
