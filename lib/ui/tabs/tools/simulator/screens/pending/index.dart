import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_pending.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_pending_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/TradingWithTypes/action_in_orders.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/pending/item.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';


class SPendingList extends StatefulWidget {
  const SPendingList({super.key});

  @override
  State<SPendingList> createState() => _SPendingListState();
}

class _SPendingListState extends State<SPendingList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future _getData({loadMore = false}) async {
    SPendingManager manager = context.read<SPendingManager>();
    await manager.getData(loadMore: loadMore);
  }

  @override
  Widget build(BuildContext context) {
    SPendingManager manager = context.watch<SPendingManager>();

    return BaseLoaderContainer(
      hasData: manager.data != null && !manager.isLoading,
      isLoading: manager.isLoading || manager.status == Status.ideal,
      error: manager.error,
      onRefresh: _getData,
      showPreparingText: true,
      child: RefreshControl(
        onRefresh: () async {
          await _getData();
        },
        canLoadMore: manager.canLoadMore,
        onLoadMore: () async => await _getData(loadMore: true),
        child: ListView.separated(
          itemBuilder: (context, index) {
            TsPendingListRes item = manager.data![index];
            return TsPendingListItem(
              item: item,
              onTap: () {
                TradeManager trade = context.read<TradeManager>();
                trade.setTappedStock(StockDataManagerRes(
                  symbol: item.symbol ?? '',
                  change: item.change,
                  changePercentage: item.changesPercentage,
                  price: item.currentPrice,
                ));

                BaseBottomSheet().bottomSheet(
                  barrierColor: ThemeColors.neutral5.withValues(alpha: 0.7),
                  child: ActionInOrders(
                    symbol:  item.symbol,
                    item: item,
                    index: index,
                  )
                );
               /* showModalBottomSheet(
                  enableDrag: true,
                  isDismissible: true,
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  isScrollControlled: true,
                  builder: (context) {
                    return ActionInOrders(
                      symbol:  item.symbol,
                      item: item,
                      index: index,
                    );
                  },
                );*/
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider(height: 24,thickness:1,color: ThemeColors.neutral5);
          },
          itemCount: manager.data?.length ?? 0,
        ),
      ),
    );
  }
}
