import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/home_provider.dart';
import 'package:stocks_news_new/providers/user_provider.dart';
import 'package:stocks_news_new/screens/marketData/lock/common_lock.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/common_scanner/stock_scanner_app.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/services/streams/gainers_stream.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/services/streams/losers_stream.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/services/streams/scanner_stream.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

//MARK: APP
class ScannerIndex extends StatelessWidget {
  static const path = 'ScannerIndex';

  const ScannerIndex({super.key});

  @override
  Widget build(BuildContext context) {
    // MarketScannerM provider = context.watch<MarketScannerM>();
    // String? bannerImage = provider.port?.port?.checkMarketOpenApi?.bannerImage;

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
      child: BaseScaffold(
          appBar: BaseAppBar(
            showBack: true,
            title: "Stocks Scanner",
            // isScannerFilter: true,
            // onFilterClick:
            //    !isLocked && (bannerImage == '')
            //     ? () {
            //   Navigator.push(
            //     context,
            //     createRoute(MarketScannerFilter()),
            //   );
            // }
            //     : null,
          ),
          body: Stack(
            //alignment: Alignment.topRight,
            children: [
              isLocked
                  ? Stack(
                      children: [
                        ScannerContainerLocked(),
                        if (isLocked)
                          CommonLock(
                            showLogin: true,
                            isLocked: isLocked,
                            showUpgradeBtn: havePermissions == false,
                            //fromToPage: "scanner",
                          ),
                      ],
                    )
                  : StocksScannerApp()
            ],
          )),
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
      initialIndex: 1,
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
