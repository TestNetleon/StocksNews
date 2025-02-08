import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
import 'package:stocks_news_new/stocksScanner/screens/stockScanner/scanner_container.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_button_small.dart';

import 'index.dart';

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
      context.read<MarketScannerProvider>().getScannerPorts();
    });
  }

  @override
  Widget build(BuildContext context) {
    MarketScannerProvider provider = context.watch<MarketScannerProvider>();
    // String? msg =
    //     provider.port?.port?.checkMarketOpenApi?.postMarketBannerMessage;
    String? bannerImage = provider.port?.port?.checkMarketOpenApi?.bannerImage;
    return provider.isLoading
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
                      // padding:
                      //     EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      // decoration: BoxDecoration(
                      //   color: Colors.black,
                      //   borderRadius: BorderRadius.circular(8),
                      // ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Text(
                            //   msg ?? '',
                            //   textAlign: TextAlign.center,
                            //   style: styleGeorgiaBold(fontSize: 20),
                            // ),

                            // Image.asset(Images.scannerStop),
                            CachedNetworkImagesWidget(bannerImage),

                            SpacerVertical(height: 10),
                            ThemeButtonSmall(
                              text: "Refresh",
                              onPressed: () {
                                context
                                    .read<MarketScannerProvider>()
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
            : ScannerContainer();
  }
}
