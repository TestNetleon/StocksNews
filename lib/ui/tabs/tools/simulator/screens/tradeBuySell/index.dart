import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/ticker_app_bar.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/tradeBuySell/container.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/constants.dart';


class TradeBuySellIndex extends StatelessWidget {
  static const String path = "TradeBuySellIndex";
  final num? qty;
  final num? editTradeID;
  final StockType? selectedStock;

  const TradeBuySellIndex({
    super.key,
    this.qty,
    this.editTradeID,
    this.selectedStock,
  });

  @override
  Widget build(BuildContext context) {
    TradeManager manager = context.watch<TradeManager>();
    BaseTickerRes? detailRes = manager.detailRes;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        SSEManager.instance.disconnectScreen(SimulatorEnum.detail);
      },
      child: BaseScaffold(
        appBar: BaseTickerAppBar(
          data: detailRes,
          addToWatchlist: (){},
          addToAlert: (){},

        ),
        body: BuySellContainer(
          selectedStock: selectedStock,
          qty: qty,
          editTradeID: editTradeID,
        ),
      ),
    );
  }
}
