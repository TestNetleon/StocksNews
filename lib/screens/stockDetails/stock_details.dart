import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer_copy.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details_base.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/socket/socket.dart';
import 'package:stocks_news_new/utils/colors.dart';
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
  late WebSocketService _webSocketService;

  @override
  void initState() {
    super.initState();
    _webSocketService = WebSocketService();
    _webSocketService.connect();
    _webSocketService.subscribe(widget.symbol);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': "Stock Detail"},
      );
    });
  }

  void _getData() {
    StockDetailProvider provider = context.read<StockDetailProvider>();
    provider.getStockDetails(symbol: widget.symbol, refresh: true);
    provider.getStockGraphData(symbol: widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      moreGradient: true,
      drawer: const BaseDrawer(),
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      bottomSafeAreaColor: ThemeColors.background.withOpacity(0.8),
      body: StockDetailsBase(
        symbol: widget.symbol,
        inAppMsgId: widget.inAppMsgId,
      ),
    );
  }
}
