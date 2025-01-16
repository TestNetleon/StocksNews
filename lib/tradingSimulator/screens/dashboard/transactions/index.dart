import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_pending_list_res.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/tradeSheet.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../manager/sse.dart';
import '../../../modals/trading_search_res.dart';
import '../../../providers/trade_provider.dart';
import '../../../providers/ts_transaction_list.dart';
import 'item.dart';

class TsTransactionList extends StatefulWidget {
  const TsTransactionList({super.key});

  @override
  State<TsTransactionList> createState() => _TsTransactionListState();
}

class _TsTransactionListState extends State<TsTransactionList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future _getData({loadMore = false}) async {
    TsTransactionListProvider provider =
        context.read<TsTransactionListProvider>();
    await provider.getData(loadMore: loadMore);
  }

  @override
  void dispose() {
    // SSEManager.instance.disconnectScreen(SimulatorEnum.transaction);
    Utils().showLog("TRANSACTIONS CLOSED");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TsTransactionListProvider provider =
        context.watch<TsTransactionListProvider>();

    return BaseUiContainer(
      hasData: provider.data != null && !provider.isLoading,
      isLoading: provider.isLoading,
      error: provider.error,
      errorDispCommon: false,
      onRefresh: _getData,
      showPreparingText: true,
      child:
          // provider.data==null
          //   ? const SummaryErrorWidget(title: "No open orders")
          //   :
          RefreshControl(
        // onRefresh: _getData,
        onRefresh: () async {
          await _getData();
        },
        canLoadMore: provider.canLoadMore,
        onLoadMore: () async => await _getData(loadMore: true),
        child: ListView.separated(
          padding: EdgeInsets.only(bottom: 20),
          itemBuilder: (context, index) {
            TsPendingListRes? item = provider.data?[index];
            if (item == null) {
              return SizedBox();
            }
            return TsTransactionListItem(
              item: item,
              onTap: () {
                TradeProviderNew trade = context.read<TradeProviderNew>();
                trade.setTappedStock(StockDataManagerRes(
                  symbol: item.symbol ?? '',
                  change: item.change,
                  changePercentage: item.changesPercentage,
                  price: item.currentPrice,
                ));
                tradeSheet(
                  symbol: item.symbol,
                  doPop: false,
                  qty: item.quantity,
                  data: TradingSearchTickerRes(
                    image: item.image,
                    name: item.company,
                    currentPrice: item.currentPrice,
                    symbol: item.symbol,
                  ),
                );
              },
            );
          },
          separatorBuilder: (context, index) {
            return const SpacerVertical();
          },
          itemCount: provider.data?.length ?? 0,
        ),
      ),
    );
  }
}
