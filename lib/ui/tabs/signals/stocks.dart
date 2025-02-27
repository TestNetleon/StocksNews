import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import '../../../models/ticker.dart';
import '../../../widgets/custom/base_loader_container.dart';
import '../../base/base_list_divider.dart';
import '../../base/lock.dart';
import '../../base/stock_item.dart';

class SignalStocksIndex extends StatelessWidget {
  const SignalStocksIndex({super.key});

  @override
  Widget build(BuildContext context) {
    SignalsManager manager = context.watch<SignalsManager>();

    return BaseLoaderContainer(
      isLoading: manager.isLoadingStocks,
      hasData: manager.signalSocksData?.data != null,
      showPreparingText: true,
      error: manager.errorStocks,
      onRefresh: manager.getStocksData,
      child: Stack(
        children: [
          BaseLoadMore(
            onRefresh: manager.getStocksData,
            onLoadMore: () async => manager.getStocksData(loadMore: true),
            canLoadMore: manager.canLoadMoreStocks,
            child: ListView.separated(
              // shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                BaseTickerRes? data = manager.signalSocksData?.data?[index];
                if (data == null) {
                  return SizedBox();
                }
                return BaseStockItem(
                  data: data,
                  index: index,
                  onTap: (p0) {
                    Navigator.pushNamed(context, StockDetailIndex.path,
                        arguments: {'symbol': p0.symbol});
                  },
                );
              },
              separatorBuilder: (context, index) {
                return BaseListDivider();
              },
              itemCount: manager.signalSocksData?.data?.length ?? 0,
            ),
          ),
          BaseLockItem(
            manager: manager,
            callAPI: manager.getStocksData,
          ),
        ],
      ),
    );
  }
}
