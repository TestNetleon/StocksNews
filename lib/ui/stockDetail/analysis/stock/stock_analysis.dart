import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/stockDetail/analysis/stock/basic_data.dart';
import 'package:stocks_news_new/ui/stockDetail/analysis/stock/stocks_peer.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

import '../../../../models/stockDetail/overview.dart';
import '../../../../models/stockDetail/stock_analysis.dart';

class SDStocksAnalysis extends StatelessWidget {
  const SDStocksAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();

    List<BaseKeyValueRes>? basicData = manager.dataStocksAnalysis?.basicData;

    StocksPeersRes? peersData = manager.dataStocksAnalysis?.peersData;

    return BaseLoaderContainer(
      hasData: manager.dataStocksAnalysis != null,
      isLoading: manager.isLoadingStocksAnalysis,
      error: manager.errorStocksAnalysis,
      onRefresh: manager.onSelectedTabRefresh,
      showPreparingText: true,
      child: BaseScroll(
        onRefresh: manager.onSelectedTabRefresh,
        margin: EdgeInsets.zero,
        children: [
          SDStocksAnalysisBasicData(basicData: basicData),
          SDStocksAnalysisPeer(peersData: peersData),
        ],
      ),
    );
  }
}
