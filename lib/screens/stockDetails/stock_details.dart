import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer_copy.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details_base.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/socket/socket.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class StockDetails extends StatefulWidget {
  final String symbol;
  final String? inAppMsgId;
  static const String path = "StockDetails";
  const StockDetails({
    super.key,
    required this.symbol,
    this.inAppMsgId,
  });

  @override
  State<StockDetails> createState() => _StockDetailsState();
}

//
class _StockDetailsState extends State<StockDetails> {
  // late WebSocketService _webSocketService;
  // String? tickerPrice;
  // String? tickerChange;
  // String? tickerPercentage;

  late CryptoWebSocket _webSocket;

  @override
  void initState() {
    super.initState();
    _addSocket();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': "Stock Detail"},
      );
    });
  }

  _addSocket() {
    // _webSocketService = WebSocketService(
    //   url: 'wss://websockets.financialmodelingprep.com',
    //   apiKey: '5e5573e6668fcd5327987ab3b912ef3e',
    //   ticker: widget.symbol, // Replace with your ticker symbol
    // );

    // _webSocketService.onDataReceived = (price, change, percentage) {
    //   setState(() {
    //     tickerPrice = price;
    //     tickerChange = change;
    //     tickerPercentage = percentage;
    //   });
    //   Utils().showLog("ticker price $tickerPrice");
    //   Utils().showLog("ticker percentage $tickerPercentage");
    //   Utils().showLog("ticker change $tickerChange");
    // };

    // _webSocketService.connect();
    _webSocket = CryptoWebSocket(
      apiKey: '5e5573e6668fcd5327987ab3b912ef3e',
      ticker: widget.symbol,
    );
  }

  void _getData() {
    StockDetailProvider provider = context.read<StockDetailProvider>();
    provider.getStockDetails(symbol: widget.symbol, refresh: true);
    provider.getStockGraphData(symbol: widget.symbol);
  }

  @override
  void dispose() {
    // _webSocketService.disconnect();
    _webSocket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // StockDetailProvider provider = context.watch<StockDetailProvider>();
    return BaseContainer(
      moreGradient: true,
      drawer: const BaseDrawer(),
      appBar: const AppBarHome(
        isPopback: true,
        canSearch: true,
      ),
      // body: provider.isLoading && provider.data == null
      //     ? const Loading()
      //     : !provider.isLoading &&
      //             provider.data == null &&
      //             provider.otherData == null &&
      //             provider.analysisRes == null &&
      //             provider.technicalAnalysisRes == null &&
      //             provider.dataMentions == null
      //         ? ErrorDisplayWidget(
      //             error: provider.error,
      //             onRefresh: _getData,
      //           )
      //         : provider.data != null
      //             ? const StockDetailsBase()
      //             : const SizedBox()
      body: StockDetailsBase(
        symbol: widget.symbol,
        inAppMsgId: widget.inAppMsgId,
      ),

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
