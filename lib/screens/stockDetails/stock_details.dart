import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details_base.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/error_display_common.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class StockDetails extends StatefulWidget {
  final String symbol;
  static const String path = "StockDetails";
  const StockDetails({super.key, required this.symbol});

  @override
  State<StockDetails> createState() => _StockDetailsState();
}

//
class _StockDetailsState extends State<StockDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': "Stock Detail"},
      );
    });
  }

  void _getData() {
    context.read<StockDetailProvider>().getStockDetails(symbol: widget.symbol);
    context
        .read<StockDetailProvider>()
        .getStockGraphData(symbol: widget.symbol);

    context
        .read<StockDetailProvider>()
        .getStockOtherDetails(symbol: widget.symbol);
    context.read<StockDetailProvider>().analysisData(symbol: widget.symbol);
    context
        .read<StockDetailProvider>()
        .technicalAnalysisData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProvider provider = context.watch<StockDetailProvider>();
    log("${provider.data == null}, ${provider.isLoading}");
    return BaseContainer(
        moreGradient: true,
        drawer: const BaseDrawer(),
        appBar: const AppBarHome(
          isPopback: true,
          canSearch: true,
        ),
        body: provider.isLoading && provider.data == null
            ? const Loading()
            : !provider.isLoading &&
                    provider.data == null &&
                    provider.otherData == null &&
                    provider.analysisRes == null &&
                    provider.technicalAnalysisRes == null &&
                    provider.dataMentions == null
                ? ErrorDisplayWidget(
                    error: provider.error,
                    onRefresh: _getData,
                  )
                : provider.data != null
                    ? const StockDetailsBase()
                    : const SizedBox()

        // RefreshIndicator(
        //     onRefresh: () async {
        //       _getData();
        //     },
        //     child: const StockDetailsBase(),
        //   )

        // BaseUiContainer(
        //   isLoading: provider.isLoading && provider.data == null,
        //   hasData: provider.data != null,
        //   error: provider.error,
        //   errorDispCommon: true,
        //   onRefresh: () => _getData(),
        //   child: const StockDetailsBase(),
        // ),
        );
  }
}
