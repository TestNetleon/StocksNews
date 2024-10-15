import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/screens/MsAnalysis/faq/faq.dart';
import 'package:stocks_news_new/screens/MsAnalysis/widget/peer_comparison.dart';
import 'package:stocks_news_new/screens/MsAnalysis/widget/price_volatility.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../modals/msAnalysis/ms_top_res.dart';
import '../../socket/socket.dart';
import '../../widgets/custom/refresh_indicator.dart';
import 'highlights/index.dart';
import 'otherStocks/other.dart';
import 'ourTake/index.dart';
import 'overviewTabs/ms_tabs.dart';
import 'radar/radar.dart';
import 'stockScore/score.dart';
import 'swot/index.dart';
import 'widget/app_bar.dart';
import 'widget/ms_top.dart';

class MsAnalysis extends StatefulWidget {
  final String symbol;
  const MsAnalysis({super.key, required this.symbol});

  @override
  State<MsAnalysis> createState() => _MsAnalysisState();
}

class _MsAnalysisState extends State<MsAnalysis> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addSocket();
      context.read<MSAnalysisProvider>().callAPIs(symbol: widget.symbol);
    });
  }

  WebSocketService? _webSocketService;

  _addSocket() {
    MSAnalysisProvider provider = context.read<MSAnalysisProvider>();

    try {
      _webSocketService = WebSocketService(
        url: 'wss://websockets.financialmodelingprep.com',
        apiKey: apiKeyFMP,
        ticker: widget.symbol,
      );
      _webSocketService?.connect();

      // _webSocketService?.onDataReceived =
      //     (price, change, percentage, changeString) {
      //   tickerPrice = price;
      //   tickerChange = change;
      //   tickerPercentage = percentage;
      //   tickerChangeString = changeString;

      //   provider.updateSocket(
      //     change: tickerChange,
      //     changePercentage: tickerPercentage,
      //     changeString: tickerChangeString,
      //     price: tickerPrice,
      //   );
      // };

      _webSocketService?.onDataReceived = ({
        required String price,
        required num change,
        required num percentage,
        required String changeString,
        num? priceValue,
      }) {
        provider.updateSocket(
          change: change,
          changePercentage: percentage,
          changeString: changeString,
          price: price,
          priceVal: priceValue,
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
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    MsStockTopRes? topData = provider.topData;
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      appBar: AppBarHome(
        isPopback: true,
        subTitle: "",
        widget: topData == null ? null : const PredictionAppBar(),
      ),
      body: CommonRefreshIndicator(
        onRefresh: () async {
          provider.callAPIs(symbol: widget.symbol);
        },
        child: BaseUiContainer(
          hasData: !provider.isLoadingComplete && provider.completeData != null,
          isLoading: provider.isLoadingComplete,
          showPreparingText: true,
          error: provider.errorComplete,
          onRefresh: () {
            provider.callAPIs(symbol: widget.symbol);
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MsTopWidgetDetail(),
                  SpacerVertical(height: Dimen.padding),
                  Visibility(
                    visible: provider.completeData?.radarChart != null &&
                        provider.completeData?.radarChart?.isNotEmpty == true,
                    child: MsRadarGraph(),
                  ),
                  Visibility(
                    visible: provider.completeData?.score != null &&
                        provider.completeData?.score?.isNotEmpty == true,
                    child: MsStockScore(),
                  ),
                  MsOtherStocks(),
                  Visibility(
                    visible: provider.completeData?.score != null &&
                        provider.completeData?.score?.isNotEmpty == true,
                    child: MsOurTake(),
                  ),
                  Visibility(
                    visible: provider.completeData?.stockHighLights != null &&
                        provider.completeData?.stockHighLights?.isNotEmpty ==
                            true,
                    child: MsOurHighlights(),
                  ),
                  Visibility(
                    visible: provider.completeData?.swot != null,
                    child: MsSwotAnalysis(),
                  ),
                  Visibility(
                    visible: provider.completeData?.priceVolatility != null,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: Dimen.padding),
                      child: MsPriceVolatility(),
                    ),
                  ),
                  MsTabs(),
                  SpacerVertical(height: Dimen.padding),
                  // MsForecastChart(),
                  Visibility(
                    visible: provider.completeData?.peerComparison != null,
                    child: MsPeerComparison(),
                  ),
                  // SpacerVertical(height: Dimen.padding),
                  // MsFundamentalAnalysisMetrics(),
                  SpacerVertical(height: Dimen.padding),
                  // MsTechnicalAnalysis(),
                  // SpacerVertical(height: Dimen.padding),
                  Visibility(
                    visible: provider.completeData?.faqData != null &&
                        provider.completeData?.faqData?.isNotEmpty == true,
                    child: MsFAQs(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
