import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

import '../../models/ticker.dart';
import '../base/ticker_app_bar.dart';
import 'analysis/stock/stock_analysis.dart';
import 'forecast/analyst_forecast.dart';
import 'header.dart';
import 'key/key_stats.dart';
import 'news/index.dart';
import 'overview/overview.dart';
import 'tabs.dart';

class StockDetailIndex extends StatefulWidget {
  final String symbol;
  static const path = 'StockDetailIndex';
  const StockDetailIndex({
    super.key,
    required this.symbol,
  });

  @override
  State<StockDetailIndex> createState() => _StockDetailIndexState();
}

class _StockDetailIndexState extends State<StockDetailIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SDManager>().getSDTab(widget.symbol);
    });
  }

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    BaseTickerRes? tickerDetail = manager.data?.tickerDetail;

    return BaseScaffold(
      appBar: BaseTickerAppBar(
        data: tickerDetail,
        shareURL: () {
          openUrl(tickerDetail?.shareUrl);
        },
        addToAlert: () {},
        addToWatchlist: () {},
      ),
      body: BaseLoaderContainer(
        hasData: manager.data != null,
        isLoading: manager.isLoading,
        error: manager.error,
        showPreparingText: true,
        onRefresh: () {
          manager.getSDTab(widget.symbol);
        },
        child: Column(
          children: [
            if (manager.data?.tickerDetail != null)
              SDHeader(data: manager.data!.tickerDetail!),
            SDTabs(tabs: manager.data?.tabs),
            if (manager.selectedIndex == 0)
              Expanded(
                child: SDOverview(),
              ),
            if (manager.selectedIndex == 1)
              Expanded(
                child: SDKeyStats(),
              ),
            if (manager.selectedIndex == 2)
              Expanded(
                child: SDStocksAnalysis(),
              ),
            if (manager.selectedIndex == 4)
              Expanded(
                child: SDAnalystForecast(),
              ),
            if (manager.selectedIndex == 5)
              Expanded(
                child: SDLatestNews(),
              ),
          ],
        ),
      ),
    );
  }
}
