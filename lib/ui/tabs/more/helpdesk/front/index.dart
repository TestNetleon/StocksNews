import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/helpdesk.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/helpdesk/front/container.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class HelpDeskIndex extends StatefulWidget {
  static const String path = "HelpDesk";
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


  @override
  Widget build(BuildContext context) {
    NewHelpDeskManager manager = context.watch<NewHelpDeskManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        title: manager.data?.title,
      ),
      body: BaseLoaderContainer(
          isLoading: manager.isLoadingTickets,
          hasData: manager.data != null && !manager.isLoadingTickets,
          showPreparingText: true,
          error: manager.data?.helpDesk?.noTicketsMessage ?? manager.error,
          onRefresh: () {
            _callAPI();
          },
          child: Column(
            children: [
              Visibility(
                visible: manager.data?.subTitle != '',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad8),
                  child: Text(
                    textAlign: TextAlign.start,
                    manager.data?.subTitle ?? "",
                    style: stylePTSansRegular(fontSize: 16,color: ThemeColors.neutral80),
                  ),
                ),
              ),
              SpacerVertical(height:10),
              HelpDeskNewContainer()
            ],
          )
      ),

    );
  }
}
