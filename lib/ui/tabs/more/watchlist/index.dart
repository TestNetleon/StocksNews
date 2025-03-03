import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/watchlist.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/no_item.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/stock/slidable_edit.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class WatchListIndex extends StatefulWidget {
  static const String path = "WatchList";

  const WatchListIndex({super.key});

  @override
  State<WatchListIndex> createState() => _WatchListIndexState();
}

class _WatchListIndexState extends State<WatchListIndex> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    WatchListManagers manager = context.read<WatchListManagers>();
    manager.getWatchList(showProgress: false);
  }


  @override
  Widget build(BuildContext context) {
    WatchListManagers manager = context.watch<WatchListManagers>();
    return BaseScaffold(
        appBar: BaseAppBar(
          showBack: true,
          title:manager.watchData?.title ?? "Watchlist",
        ),
        body: BaseLoaderContainer(
          isLoading: manager.isLoading,
          hasData: manager.watchData != null && !manager.isLoading,
          showPreparingText: true,
          error: manager.error,
          onRefresh: () {
            _callAPI();
          },
          child:
          manager.watchData?.noData!=null?
          BaseNoItem(noDataRes: manager.watchData?.noData,onTap: (){
            manager.redirectToMarket();
          }):
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: manager.watchData?.subTitle != '',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad8),
                  child: Text(
                    textAlign: TextAlign.start,
                    manager.watchData?.subTitle ?? "",
                    style: stylePTSansRegular(fontSize: 16,color: ThemeColors.neutral80),
                  ),
                ),
              ),
              SpacerVertical(height:10),
              Expanded(
                child: BaseLoadMore(
                  onRefresh: manager.getWatchList,
                  onLoadMore: () async => manager.getWatchList(loadMore: true),
                  canLoadMore: manager.canLoadMore,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: Pad.pad3),
                    itemBuilder: (context, index) {
                      BaseTickerRes? data = manager.watchData?.watches?[index];
                      if (data == null) {
                        return SizedBox();
                      }
                      return SlidableStockEditItem(
                        data: data,
                        deleteDataRes: manager.watchData?.deleteBox,
                        index: index,
                        onTap: (p0) {
                          Navigator.pushNamed(context, StockDetailIndex.path, arguments: {'symbol': p0.symbol});
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return BaseListDivider();
                    },
                    itemCount: manager.watchData?.watches?.length ?? 0,
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
