import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/screens/MsAnalysis/faq/faq.dart';
import 'package:stocks_news_new/screens/MsAnalysis/widget/peer_comparison.dart';
import 'package:stocks_news_new/screens/MsAnalysis/widget/price_volatility.dart';
import 'package:stocks_news_new/screens/drawer/base_drawer.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../socket/socket.dart';
import '../../widgets/custom/refresh_indicator.dart';
import '../../widgets/disclaimer_widget.dart';
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
      context
          .read<MSAnalysisProvider>()
          .callAPIs(symbol: widget.symbol, reset: true);
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
    // MsStockTopRes? topData = provider.topData;

    String? recommendation = provider.completeData?.recommendationNew?.color;
//------------------------------------------------------------------------------------
    bool showStockScore = provider.completeData?.score != null &&
        provider.completeData?.score?.isNotEmpty == true &&
        provider.completeData?.text?.stockScore?.status == true;
//------------------------------------------------------------------------------------
    return BaseContainer(
      drawer: const BaseDrawer(resetIndex: true),
      baseColor: provider.isLoadingComplete && provider.completeData == null
          ? Colors.black
          : recommendation?.toLowerCase() == 'orange'
              ? const Color.fromARGB(255, 255, 171, 44)
              : recommendation?.toLowerCase() == 'red'
                  ? const Color.fromARGB(255, 163, 12, 1)
                  : ThemeColors.accent,
      appBar: const AppBarHome(
        isPopback: true,
        subTitle: "",
        widget: PredictionAppBar(),
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
                  const MsTopWidgetDetail(),
                  const SpacerVertical(height: Dimen.padding),
                  Visibility(
                    visible: provider.completeData?.radarChart != null &&
                        provider.completeData?.radarChart?.isNotEmpty == true,
                    child: const MsRadarGraph(),
                  ),
                  Visibility(
                    visible: provider.completeData?.timeFrameText != null &&
                        provider.completeData?.timeFrameText != '',
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child:
                          _tile(provider.completeData?.timeFrameText ?? "", 20),
                    ),
                  ),
                  Visibility(
                    visible: showStockScore,
                    child: const MsStockScore(),
                  ),
                  const MsOtherStocks(),
                  Visibility(
                    visible: provider.completeData?.keyHighlights != null &&
                        provider.completeData?.keyHighlights?.isNotEmpty ==
                            true,
                    child: const MsOurTake(),
                  ),
                  Visibility(
                    visible: provider.completeData?.stockHighLights != null &&
                        provider.completeData?.stockHighLights?.isNotEmpty ==
                            true,
                    child: const MsOurHighlights(),
                  ),
                  Visibility(
                    visible: provider.completeData?.swotAnalysis != null,
                    child: const MsSwotAnalysis(),
                  ),
                  Visibility(
                    visible: provider.completeData?.priceVolatilityNew != null,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: Dimen.padding),
                      child: MsPriceVolatility(),
                    ),
                  ),
                  const MsTabs(),
                  const SpacerVertical(height: Dimen.padding),
                  // MsForecastChart(),
                  Visibility(
                    visible: provider.completeData?.peerComparison != null,
                    child: const MsPeerComparison(),
                  ),
                  // SpacerVertical(height: Dimen.padding),
                  // MsFundamentalAnalysisMetrics(),
                  const SpacerVertical(height: Dimen.padding),
                  // MsTechnicalAnalysis(),
                  // SpacerVertical(height: Dimen.padding),
                  Visibility(
                    visible: provider.completeData?.lastUpdateDate != null &&
                        provider.completeData?.lastUpdateDate != '',
                    child:
                        _tile(provider.completeData?.lastUpdateDate ?? "", 15),
                  ),
                  Visibility(
                    visible: provider.completeData?.faqData != null &&
                        provider.completeData?.faqData?.isNotEmpty == true,
                    child: const MsFAQs(),
                  ),
                  if (provider.extraTop?.disclaimer != null &&
                      provider.extraTop?.disclaimer != '')
                    DisclaimerWidget(data: provider.extraTop?.disclaimer ?? ''),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Align _tile(String label, double fontSize) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: ThemeColors.greyBorder.withOpacity(0.5),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 99, 99, 99),
              blurRadius: 1.2,
              spreadRadius: 0.1,
              offset: Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.4, 0.9],
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 34, 34, 34),
            ],
          ),
        ),
        child: Text(
          label,
          style: stylePTSansRegular(
            fontSize: fontSize,
            color: ThemeColors.greyText,
          ),
        ),
      ),
    );
  }
}
