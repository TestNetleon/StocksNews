import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/ticker_app_bar.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/ConditionalOrder/container_conditioal_buy_sell.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/ConditionalOrder/trade_container.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/constants.dart';


class ConditionalTradesIndex extends StatelessWidget {
  static const String path = "ConditionalTradesIndex";
  final num? qty;
  final num? editTradeID;
  final ConditionType? conditionalType;
  final int? tickerID;
  final String? tradeType;

  const ConditionalTradesIndex({
    super.key,
    this.qty,
    this.editTradeID,
    this.conditionalType,
    this.tickerID, this.tradeType,
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
          manager: manager,
          addToWatchlist: (){},
          addToAlert: (){},
          onRefresh: (){
            manager.getDetailTopData(symbol:  detailRes?.symbol??"");
          },
        ),
        body:
        tradeType!=null?
        ContainerConditioalBuySell(
          conditionalType: conditionalType,
          qty: qty,
          tradeType: tradeType,
        ):
        ConditionalContainer(
          conditionalType: conditionalType,
          qty: qty,
          editTradeID: editTradeID,
          tickerID: tickerID,
        ),
      ),
    );
  }
}
