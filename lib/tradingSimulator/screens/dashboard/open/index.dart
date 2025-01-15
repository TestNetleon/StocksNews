import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tradingSimulator/modals/trading_search_res.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_open_list_res.dart';
import 'package:stocks_news_new/tradingSimulator/providers/trade_provider.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_open_list_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/open/item.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/tradeSheet.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../manager/sse.dart';

class TsOpenList extends StatefulWidget {
  const TsOpenList({super.key});

  @override
  State<TsOpenList> createState() => _TsOpenListState();
}

class _TsOpenListState extends State<TsOpenList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future _getData() async {
    TsOpenListProvider provider = context.read<TsOpenListProvider>();
    await provider.getData();
  }

  @override
  void dispose() {
    // SSEManager.instance.disconnectScreen(SimulatorEnum.open);
    super.dispose();
    Utils().showLog('OPEN DISPOSED');
  }

  @override
  Widget build(BuildContext context) {
    TsOpenListProvider provider = context.watch<TsOpenListProvider>();

    return BaseUiContainer(
      hasData: provider.data != null && !provider.isLoading,
      isLoading: provider.isLoading || provider.status == Status.ideal,
      error: provider.error,
      errorDispCommon: false,
      onRefresh: _getData,
      showPreparingText: true,
      child: CommonRefreshIndicator(
        onRefresh: () async {
          await _getData();
        },
        child: ListView.separated(
          padding: EdgeInsets.only(bottom: 20),
          itemBuilder: (context, index) {
            TsOpenListRes item = provider.data![index];
            return TsOpenListItem(
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
