import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/marketData/lock/common_lock.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/stocksScanner/manager/gainers_stream.dart';
import 'package:stocks_news_new/stocksScanner/manager/losers_stream.dart';
import 'package:stocks_news_new/stocksScanner/manager/scanner_stream.dart';
import 'package:stocks_news_new/stocksScanner/screens/marketScanner/market_scanner_filter.dart';
import 'package:stocks_news_new/stocksScanner/screens/stockScanner/scanner_webview.dart';
import 'package:stocks_news_new/stocksScanner/screens/stockScanner/stock_scanner_app.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../providers/market_scanner_provider.dart';

//MARK: WEB
class StocksScanner extends StatefulWidget {
  const StocksScanner({super.key});

  @override
  State<StocksScanner> createState() => _StocksScannerState();
}

class _StocksScannerState extends State<StocksScanner> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    // MarketScannerProvider provider = context.watch<MarketScannerProvider>();
    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
        title: "Stocks Scanner",
        canSearch: false,
        showTrailing: false,
        isScannerFilter: false,
      ),
      body: ScannerWebview(),
    );
  }
}

//MARK: APP
class StocksScannerIndex extends StatelessWidget {
  const StocksScannerIndex({super.key});

  @override
  Widget build(BuildContext context) {
    MarketScannerProvider provider = context.watch<MarketScannerProvider>();
    // String? msg =
    //     provider.port?.port?.checkMarketOpenApi?.postMarketBannerMessage;

    String? bannerImage = provider.port?.port?.checkMarketOpenApi?.bannerImage;

    UserProvider userProvider = context.watch<UserProvider>();
    HomeProvider homeProvider = context.watch<HomeProvider>();

    bool purchased = userProvider.user?.membership?.purchased == 1;

    bool isLocked = homeProvider.extra?.membership?.permissions?.any(
            (element) => (element.key == "real-time-stock-screener" &&
                element.status == 0)) ??
        false;

    bool? havePermissions;
    if (purchased && isLocked) {
      havePermissions = userProvider.user?.membership?.permissions?.any(
              (element) => (element.key == "real-time-stock-screener" &&
                  element.status == 1)) ??
          false;
      isLocked = !havePermissions;
    }

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        MarketScannerStream().stopListeningPorts();
        MarketGainersStream().stopListeningPorts();
        MarketLosersStream().stopListeningPorts();
      },
      child: BaseContainer(
        appBar: AppBarHome(
          isPopBack: true,
          title: "Stocks Scanner",
          canSearch: false,
          showTrailing: false,
          isScannerFilter: true,
          onFilterClick: bannerImage == null || bannerImage == ''
              ? () {
                  Navigator.push(
                    context,
                    createRoute(MarketScannerFilter()),
                  );
                }
              : null,
        ),
        body: isLocked
            ? Stack(
                children: [
                  ScannerContainerLocked(),
                  if (isLocked)
                    CommonLock(
                      showLogin: true,
                      isLocked: isLocked,
                      showUpgradeBtn: havePermissions == false,
                    ),
                ],
              )
            : StocksScannerApp(),
      ),
    );
  }
}

class ScannerContainerLocked extends StatelessWidget {
  const ScannerContainerLocked({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> tabs = ["SCANNER", "GAINERS", "LOSERS"];
    List<IconData> tabIcons = [
      FontAwesomeIcons.magnifyingGlassChart,
      FontAwesomeIcons.arrowTrendUp,
      FontAwesomeIcons.arrowTrendDown,
    ];

    return CustomTabContainer(
      tabs: List.generate(
        tabs.length,
        (index) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  tabIcons[index],
                  size: 14,
                  color: tabs[index] == 'GAINERS'
                      ? ThemeColors.themeGreen
                      : tabs[index] == 'LOSERS'
                          ? ThemeColors.sos
                          : ThemeColors.white,
                ),
                SpacerHorizontal(width: 5),
                Text(
                  tabs[index],
                  style: styleGeorgiaBold(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
      widgets: [
        const SizedBox(),
        const SizedBox(),
        const SizedBox(),
      ],
    );
  }
}
