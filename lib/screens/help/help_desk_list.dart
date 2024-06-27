import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/help_desk_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/help/chatScreen/chat_screen.dart';
import 'package:stocks_news_new/screens/help/tickets/tickets.dart';
import 'package:stocks_news_new/screens/help/widget/help_desk_item.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/disclaimer_widget.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HelpDeskList extends StatefulWidget {
  final String? slug;
  const HelpDeskList({required this.slug, super.key});

  @override
  State<HelpDeskList> createState() => _HelpDeskListState();
}

class _HelpDeskListState extends State<HelpDeskList> {
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

    return BaseUiContainer(
      error: provider.data?.noTicketMsg ?? provider.error,
      hasData: provider.data?.tickets != null &&
          provider.data?.tickets?.isNotEmpty == true,
      isLoading: provider.isLoading,
      errorDispCommon: true,
      showPreparingText: true,
      onRefresh: () => provider.getHelpDeskList(),
      child: CommonRefreshIndicator(
        onRefresh: () => provider.getHelpDeskList(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const Tickets(),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: (provider.data?.tickets?.length ?? 0) < 5
                    ? provider.data?.tickets?.length ?? 0
                    : 5,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const SizedBox();
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        navigatorKey.currentContext!,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            slug: "1",
                            ticketId:
                                "${provider.data?.tickets?[index].ticketId}",
                          ),
                        ),
                      );

                      context.read<HelpDeskProvider>().setSlug(
                          "1", '${provider.data?.tickets?[index].ticketId}');
                      context.read<HelpDeskProvider>().setReasonController(
                          "${provider.data?.subjects?[index].title}",
                          "${provider.data?.subjects?[index].id}");
                    },
                    child: HelpDeskItem(
                      index: index,
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Colors.white12,
                  );
                },
              ),
              const SpacerVertical(),
              if (context.read<HelpDeskProvider>().extra?.disclaimer != null)
                DisclaimerWidget(
                    data: context.read<HelpDeskProvider>().extra!.disclaimer!)
            ],
          ),
        ),
      ),
    );
  }
}
