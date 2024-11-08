import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/competitors/compititor.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/insider/sd_insider_trade.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/keystats/key_states.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/mergers/mergers.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/news/news.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/overview/sd_overview.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/ownership/ownership.dart';
import 'package:stocks_news_new/screens/stockDetail/stockDetailTabs/secFiling/sd_sec_filing.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/service/amplitude/service.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/theme_button.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';
import '../../socket/socket.dart';
import '../../utils/constants.dart';
// import '../simulator/buyAndSell/index.dart';
import '../../utils/utils.dart';
import '../auth/base/base_auth_bottom.dart';
import 'widgets/AlertWatchlist/add_alert_watchlist.dart';
import 'stockDetailTabs/chart/chart.dart';
import 'stockDetailTabs/dividends/dividends.dart';
import 'stockDetailTabs/earnings/earnings.dart';
import 'stockDetailTabs/financial/financial.dart';
import 'stockDetailTabs/forecast/forecast.dart';
import 'stockDetailTabs/stockAnalysis/analysis.dart';
import 'stockDetailTabs/technicalAnalysis/technical_analysis.dart';

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
    AmplitudeService.logUserInteractionEvent(type: 'Stock Detail');

    context.read<StockDetailProviderNew>().getTabData(symbol: widget.symbol);

    // LeaderBoardProvider provider = context.read<LeaderBoardProvider>();
    // if (provider.extra == null) {
    //   provider.getLeaderBoardData();
    // }
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

      // _webSocketService?.onDataReceived =
      //     (price, change, percentage, changeString) {
      //   setState(() {
      //     tickerPrice = price;
      //     tickerChange = change;
      //     tickerPercentage = percentage;
      //     tickerChangeString = changeString;
      //   });
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

    KeyStats? keyStats = provider.tabRes?.keyStats;
    CompanyInfo? companyInfo = provider.tabRes?.companyInfo;

    return BaseContainer(
      appBar: AppBarHome(
        isPopback: true,
        title: keyStats?.symbol ?? "",
        subTitle: keyStats?.name ?? "",
        widget: keyStats?.symbol == null
            ? null
            : Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // color: Colors.white,
                      color: Colors.transparent,
                      // border: Border.all(color: ThemeColors.white),
                      border: Border.all(color: ThemeColors.accent),
                    ),
                    padding: const EdgeInsets.all(8),
                    width: 48,
                    height: 48,
                    child: ThemeImageView(
                      url: companyInfo?.image ?? "",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SpacerHorizontal(width: 8),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              keyStats?.symbol ?? "",
                              style: stylePTSansBold(fontSize: 17),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: ThemeColors.greyBorder,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                keyStats?.exchange ?? "",
                                style: stylePTSansRegular(fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          keyStats?.name ?? "",
                          style: stylePTSansRegular(
                            fontSize: 13,
                            color: ThemeColors.greyText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      body: BaseUiContainer(
        hasData: !provider.isLoadingTab && provider.tabRes != null,
        isLoading: provider.isLoadingTab,
        error: provider.errorTab,
        showPreparingText: true,
        onRefresh: _callApi,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: CommonTabContainer(
                  onChange: (index) {
                    closeKeyboard();

                    provider.setOpenIndex(-1);
                  },
                  padding: const EdgeInsets.only(bottom: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  tabPaddingNew: false,
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
                    // SdNews(symbol: widget.symbol),
                    SdNewsN(symbol: widget.symbol),
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
            ),
            // ThemeButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => BuyAndSellIndex(),
            //       ),
            //     );
            //   },
            // ),
            BaseAuth(),
            Container(
              decoration: BoxDecoration(
                color: ThemeColors.background.withOpacity(0.8),
                border: const Border(
                  top: BorderSide(color: ThemeColors.greyBorder),
                ),
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
