import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_pending_list_res.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_pending_list_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/pending/item.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/pending/ts_slidable_menu.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../manager/sse.dart';
import '../../../modals/trading_search_res.dart';
import '../../../providers/trade_provider.dart';
import '../../../widgets/sim_trade_sheet.dart';

class TsPendingList extends StatefulWidget {
  const TsPendingList({super.key});

  @override
  State<TsPendingList> createState() => _TsPendingListState();
}

class _TsPendingListState extends State<TsPendingList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future _getData({loadMore = false}) async {
    TsPendingListProvider provider = context.read<TsPendingListProvider>();
    await provider.getData(loadMore: loadMore);
  }

  void _onEditClick(TsPendingListRes item, index) {
    //
    popUpAlert(
      icon: Images.alertPopGIF,
      title: "Confirm",
      message: "Do you want to edit this order?",
      cancel: true,
      okText: "Edit",
      onTap: () {
        TsPendingListProvider provider = context.read<TsPendingListProvider>();
        if (item.tradeType == "Short") {
          provider.shortRedirection(index: index);
        } else if (item.orderTypeOriginal == "BRACKET_ORDER") {
          Navigator.pop(context);
          provider.conditionalRedirection(index: index, qty: item.quantity);
        } else {
          provider.editStock(index: index);
        }
      },
    );
  }

  void _onCancelClick(TsPendingListRes item) {
    popUpAlert(
      icon: Images.alertPopGIF,
      title: "Confirm",
      message: "Do you want to cancel this order?",
      cancel: true,
      cancelText: "No",
      okText: "Yes, cancel",
      onTap: () async {
        TsPendingListProvider provider = context.read<TsPendingListProvider>();
        provider.cancleOrder(item.id);
      },
    );
    //
  }

  @override
  Widget build(BuildContext context) {
    TsPendingListProvider provider = context.watch<TsPendingListProvider>();

    return BaseUiContainer(
      hasData: provider.data != null && !provider.isLoading,
      isLoading: provider.isLoading || provider.status == Status.ideal,
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
            TsPendingListRes item = provider.data![index];
            return TsPendingSlidableMenu(
              onEditClick: () => _onEditClick(item, index),
              onCancelClick: () => _onCancelClick(item),
              index: index,
              child: TsPendingListItem(
                item: item,
                onTap: () {
                  TradeProviderNew trade = context.read<TradeProviderNew>();
                  trade.setTappedStock(StockDataManagerRes(
                    symbol: item.symbol ?? '',
                    change: item.change,
                    changePercentage: item.changesPercentage,
                    price: item.currentPrice,
                  ));

                  simTradeSheet(
                    symbol: item.symbol,
                    data: TradingSearchTickerRes(
                      image: item.image,
                      name: item.company,
                      currentPrice: item.currentPrice,
                      symbol: item.symbol,
                    ),
                    qty: item.quantity,
                  );

                  // Navigator.push(
                  //   context,
                  //   createRoute(TradOrderScreen(
                  //     symbol: item.symbol,
                  //     data: TradingSearchTickerRes(
                  //       image: item.image,
                  //       name: item.company,
                  //       currentPrice: item.currentPrice,
                  //       symbol: item.symbol,
                  //     ),
                  //     qty: item.quantity,
                  //   )),
                  // );
                  /* tradeSheet(
                    symbol: item.symbol,
                    doPop: false,
                    qty: item.quantity,
                    data: TradingSearchTickerRes(
                      image: item.image,
                      name: item.company,
                      currentPrice: item.currentPrice,
                      symbol: item.symbol,
                    ),
                  );*/
                },
              ),
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
