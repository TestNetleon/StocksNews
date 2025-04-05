import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/tools.dart';
import 'package:stocks_news_new/service/events/service.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import '../../../../models/lock.dart';
import '../../../base/login_required.dart';
import '../../../base/scaffold.dart';
import 'header.dart';
import 'table.dart';

class ToolsCompareIndex extends StatefulWidget {
  static const path = 'ToolsCompareIndex';
  const ToolsCompareIndex({super.key});

  @override
  State<ToolsCompareIndex> createState() => _ToolsCompareIndexState();
}

class _ToolsCompareIndexState extends State<ToolsCompareIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ToolsManager>().getCompareData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ToolsManager manager = context.watch<ToolsManager>();
    BaseLockInfoRes? loginRequired = manager.compareData?.loginRequired;

    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        showSearch: true,
        showNotification: true,
        title: manager.compareData?.title,
        onBackEventCall: EventsService.instance.backCompareToolsPage,
      ),
      body: loginRequired != null && !manager.isLoadingCompare
          ? BaseLoginRequired(
              data: loginRequired,
              onPressed: () async {
                manager.getCompareData();
              },
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: !manager.isLoadingCompare,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Pad.pad16),
                    child: ToolsCompareHeaderStocks(),
                  ),
                ),
                Expanded(
                  child: BaseLoaderContainer(
                    isLoading: manager.isLoadingCompare,
                    hasData: manager.compareData != null &&
                        manager.compareData?.data != null &&
                        manager.compareData?.data?.isNotEmpty == true,
                    showPreparingText: true,
                    error: manager.errorCompare,
                    onRefresh: manager.getCompareData,
                    child: BaseScroll(
                      margin: EdgeInsets.only(top: Pad.pad16),
                      onRefresh: manager.getCompareData,
                      children: [
                        ToolsCompareTable(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
