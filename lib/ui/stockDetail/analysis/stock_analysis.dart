import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class SDStocksAnalysis extends StatelessWidget {
  const SDStocksAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    return BaseLoaderContainer(
      hasData: manager.dataStocksAnalysis != null,
      isLoading: manager.isLoadingStocksAnalysis,
      error: manager.errorStocksAnalysis,
      onRefresh: manager.onSelectedTabRefresh,
      showPreparingText: true,
      child: Container(),
    );
  }
}
