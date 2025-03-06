import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_open.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/trade.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_open_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/open/item.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/widget/sim_trade_sheet.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';


class SOpenList extends StatefulWidget {
  const SOpenList({super.key});

  @override
  State<SOpenList> createState() => _SOpenListState();
}

class _SOpenListState extends State<SOpenList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future _getData() async {
    SOpenManager manager = context.read<SOpenManager>();
    manager.getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SOpenManager manager = context.watch<SOpenManager>();
    return BaseLoaderContainer(
      hasData: manager.data != null && !manager.isLoading,
      isLoading: manager.isLoading || manager.status == Status.ideal,
      error: manager.error,
      onRefresh: _getData,
      showPreparingText: true,
      child: CommonRefreshIndicator(
        onRefresh: _getData,
        child: ListView.separated(
          itemBuilder: (context, index) {
            TsOpenListRes item = manager.data![index];
            if (item.orderTypeOriginal == "RECURRING_ORDER") return SizedBox();
            return TsOpenListItem(
              item: item,
              onTap: () {
                TradeManager trade = context.read<TradeManager>();
                trade.setTappedStock(StockDataManagerRes(
                  symbol: item.symbol ?? '',
                  change: item.change,
                  changePercentage: item.changesPercentage,
                  price: item.currentPrice,
                ));
                Map<String, String>? allTradType = {
                  "order_type_original":item.orderTypeOriginal??"",
                  "trade_type":item.tradeType??"",
                };
                simulatorTrades(
                    symbol: item.symbol,
                    data: BaseTickerRes(
                      image: item.image,
                      name: item.company,
                      price: item.currentPrice,
                      symbol: item.symbol,
                    ),
                    qty: item.quantity,
                    tickerID: item.id,
                    fromTo: 1,
                  portfolioTradeType: item.portfolioTradeType,
                    allTradType:allTradType

                );
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
