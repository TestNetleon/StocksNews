import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/competitors/compititor.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/insider/sd_insider_trade.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/keystats/key_states.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/mergers/mergers.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/news/news.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/overview/sd_overview.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/ownership/ownership.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/secFiling/sd_sec_filing.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import '../../socket/socket.dart';
import '../../utils/constants.dart';
import '../stockDetails/widgets/AlertWatchlist/add_alert_watchlist.dart';
import 'widgets/chart/chart.dart';
import 'widgets/dividends/dividends.dart';
import 'widgets/earnings/earnings.dart';
import 'widgets/financial/financial.dart';
import 'widgets/forecast/forecast.dart';
import 'widgets/stockAnalysis/analysis.dart';
import 'widgets/technicalAnalysis/technical_analysis.dart';

class StockDetail extends StatefulWidget {
  final String symbol;
  final String? inAppMsgId;
  final String? notificationId;
  static const String path = "StockDetail";

  const StockDetail({
    super.key,
    required this.symbol,
    this.inAppMsgId,
    this.notificationId,
  });

  @override
  State<StockDetail> createState() => _StockDetailState();
}

class _StockDetailState extends State<StockDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callApi();
      _addSocket();
      FirebaseAnalytics.instance.logEvent(
        name: 'ScreensVisit',
        parameters: {'screen_name': "Stock Detail"},
      );
    });
  }

  _callApi() {
    context.read<StockDetailProviderNew>().getTabData(symbol: widget.symbol);
  }

  WebSocketService? _webSocketService;
  String? tickerPrice;
  num? tickerChange;
  num? tickerPercentage;
  String? tickerChangeString;

  _addSocket() {
    StockDetailProviderNew provider = context.read<StockDetailProviderNew>();

    try {
      _webSocketService = WebSocketService(
        url: 'wss://websockets.financialmodelingprep.com',
        apiKey: apiKeyFMP,
        ticker: widget.symbol,
      );
      _webSocketService?.connect();

      _webSocketService?.onDataReceived =
          (price, change, percentage, changeString) {
        setState(() {
          tickerPrice = price;
          tickerChange = change;
          tickerPercentage = percentage;
          tickerChangeString = changeString;
        });
        provider.updateSocket(
          change: tickerChange,
          changePercentage: tickerPercentage,
          changeString: tickerChangeString,
          price: tickerPrice,
        );
      };
    } catch (e) {
//
    }
  }

  @override
  void dispose() {
    _webSocketService?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();
    return BaseContainer(
      appBar: const AppBarHome(isPopback: true, canSearch: true),
      bottomSafeAreaColor: ThemeColors.background.withOpacity(0.8),
      body: BaseUiContainer(
        hasData: !provider.isLoadingTab && provider.tabRes != null,
        isLoading: provider.isLoadingTab,
        error: provider.errorTab,
        showPreparingText: true,
        onRefresh: _callApi,
        child: Column(
          children: [
            Expanded(
              child: CommonTabContainer(
                onChange: (index) {
                  provider.setOpenIndex(-1);
                },
                padding: const EdgeInsets.only(bottom: 10),
                // physics: const NeverScrollableScrollPhysics(),
                scrollable: true,
                tabs: List.generate(
                  provider.tabRes?.tabs?.length ?? 0,
                  (index) => provider.tabRes?.tabs?[index].name ?? "",
                ),
                widgets: [
                  SdOverview(symbol: widget.symbol),
                  const SdKeyStats(),
                  SdAnalysis(symbol: widget.symbol),
                  SdTechnical(symbol: widget.symbol),
                  SdForecast(symbol: widget.symbol),
                  // SdSocialActivities(symbol: widget.symbol),
                  SdNews(symbol: widget.symbol),
                  SdEarnings(symbol: widget.symbol),
                  SdDividends(symbol: widget.symbol),
                  SdInsiderTrade(symbol: widget.symbol),
                  SdCompetitor(symbol: widget.symbol),
                  SdOwnership(symbol: widget.symbol),
                  SdCharts(symbol: widget.symbol),
                  SdFinancial(symbol: widget.symbol),
                  SdSecFilings(symbol: widget.symbol),
                  SdMergers(symbol: widget.symbol),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: const Border(
                  top: BorderSide(color: ThemeColors.greyBorder),
                ),
                color: ThemeColors.background.withOpacity(0.8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const AddToAlertWatchlist(),
            ),
          ],
        ),
      ),
    );
  }
}
