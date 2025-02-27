import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

import '../../models/ticker.dart';
import '../base/ticker_app_bar.dart';
import 'header.dart';
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
      context.read<StocksDetailManager>().getStocksDetailTab(widget.symbol);
    });
  }

  @override
  Widget build(BuildContext context) {
    StocksDetailManager manager = context.watch<StocksDetailManager>();
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
          manager.getStocksDetailTab(widget.symbol);
        },
        child: Column(
          children: [
            if (manager.data?.tickerDetail != null)
              StocksDetailHeader(data: manager.data!.tickerDetail!),
            StocksDetailTabs(tabs: manager.data?.tabs),
            Expanded(
              child: BaseScroll(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
