import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/managers/market_scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/common_scanner/scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/common_scanner/scanner_container.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/market/m_index.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/topGainer/g_index.dart';
import 'package:stocks_news_new/ui/tabs/tools/stockScanner/screens/topLoser/l_index.dart';
import 'package:stocks_news_new/utils/theme.dart';

import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

//MARK: APP
class StocksScannerApp extends StatefulWidget {
  const StocksScannerApp({super.key});

  @override
  State<StocksScannerApp> createState() => _StocksScannerAppState();
}

class _StocksScannerAppState extends State<StocksScannerApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MarketScannerM manager = context.read<MarketScannerM>();
      manager.getScannerPorts();
      manager.onScreenChange(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    MarketScannerM manager = context.watch<MarketScannerM>();
    String? bannerImage = manager.port?.port?.checkMarketOpenApi?.bannerImage;
    return manager.isLoading
        ? Loading()
        : bannerImage != null && bannerImage != ''
            ? Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  ScannerContainerLocked(),
                  Container(
                    alignment: Alignment.center,
                    color: Colors.grey.withValues(alpha: 0.1),
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      // color: const Color.fromARGB(255, 35, 34, 34),
                      color: Colors.transparent,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CachedNetworkImagesWidget(bannerImage),
                            SpacerVertical(height: 10),
                            ThemeButtonSmall(
                              text: "Refresh",
                              onPressed: () {
                                context
                                    .read<MarketScannerM>()
                                    .getScannerPorts();
                              },
                              showArrow: false,
                              radius: 20,
                              padding: EdgeInsets.symmetric(horizontal: 25),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  BaseTabs(
                    data: manager.tabs,
                    textStyle: styleBaseBold(fontSize: 13),
                    onTap: manager.onScreenChange,
                    selectedIndex: 1,
                    isScrollable: false,
                  ),
                  SpacerVertical(height:10),
                  if (manager.selectedScreen == 0)
                    Expanded(
                      child: MarketScanner(),
                    ),
                  if (manager.selectedScreen == 1)
                    Expanded(
                      child: ScannerTopGainer(),
                    ),
                  if (manager.selectedScreen == 2)
                    Expanded(
                      child: ScannerTopLosers(),
                    ),
                ],
              );
  }
}
