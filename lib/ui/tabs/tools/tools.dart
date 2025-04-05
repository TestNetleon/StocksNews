import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/tools.dart';
import 'package:stocks_news_new/models/tools.dart';
import 'package:stocks_news_new/service/events/service.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/tabs/more/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import '../../base/scaffold.dart';

class ToolsIndex extends StatelessWidget {
  const ToolsIndex({super.key});

  @override
  Widget build(BuildContext context) {
    ToolsManager manager = context.watch<ToolsManager>();

    return BaseScaffold(
      appBar: BaseAppBar(showNotification: true, showSearch: true),
      drawer: MoreIndex(),
      body: BaseLoaderContainer(
        isLoading: manager.isLoading,
        hasData: manager.data != null && !manager.isLoading,
        showPreparingText: true,
        error: manager.error,
        onRefresh: manager.getToolsData,
        child: BaseScroll(
          onRefresh: manager.getToolsData,
          children: List.generate(
            manager.data?.tools?.length ?? 0,
            (index) {
              ToolsCardsRes? data = manager.data?.tools?[index];
              if (data == null) {
                return SizedBox();
              }
              return Container(
                margin: EdgeInsets.only(bottom: Pad.pad16),
                child: ToolsItem(
                  card: data,
                  onTap: () {
                    if (data.slug == null || data.slug == null) return;
                    manager.startNavigation(data.slug ?? ToolsEnum.scanner);
                    EventsService.instance.clickToolsPage(type: data.slug);
                  },
                ),
              );
            },
          ),

          // children: [
          //   CustomGridView(
          //     paddingVertical: 0,
          //     paddingHorizontal: 0,
          //     itemSpace: 10,
          //     length: manager.data?.tools?.length ?? 0,
          //     getChild: (index) {
          //       ToolsCardsRes? data = manager.data?.tools?[index];
          //       if (data == null) {
          //         return SizedBox();
          //       }
          //       return Container(
          //         margin: EdgeInsets.only(bottom: Pad.pad16),
          //         child: ToolsItem(
          //           card: data,
          //           onTap: () {
          //             if (data.slug == null || data.slug == null) return;
          //             manager.startNavigation(data.slug ?? ToolsEnum.scanner);
          //           },
          //         ),
          //       );
          //     },
          //   ),
          // ],
        ),
      ),
    );
  }
}
