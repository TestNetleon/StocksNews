import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/lock.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/gainers.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/losers.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/screens/losers/losers.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../base/common_tab.dart';
import 'models/scanner_port.dart';
import 'screens/extra/header.dart';
import 'screens/extra/sorting.dart';
import 'screens/extra/sub_tabs.dart';
import 'screens/gainers/gainers.dart';
import 'screens/scanner/scanner.dart';

class ToolsScannerIndex extends StatefulWidget {
  final int? index;
  static const path = 'ToolsScannerIndex';
  const ToolsScannerIndex({super.key, this.index = 1});

  @override
  State<ToolsScannerIndex> createState() => _ToolsScannerIndexState();
}

class _ToolsScannerIndexState extends State<ToolsScannerIndex>
    with WidgetsBindingObserver {
  List<MarketResData> tabs = [
    MarketResData(title: 'SCANNER', slug: 'slug'),
    MarketResData(title: 'GAINERS', slug: 'gainers'),
    MarketResData(title: 'LOSERS', slug: 'losers'),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addObserver(this);
      context.read<ScannerManager>().getScannerPorts(reset: true);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Utils().showLog('State!! $state');

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      //
    } else if (state == AppLifecycleState.resumed) {
      //
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScannerManager>(
      builder: (context, value, child) {
        bool startStream =
            value.portData?.port?.checkMarketOpenApi?.startStreaming == true;
        CheckMarketOpenRes? checkMarketOpenApi =
            value.portData?.port?.checkMarketOpenApi;

        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            ScannerGainersManager gainersManager =
                context.read<ScannerGainersManager>();
            ScannerLosersManager losersManager =
                context.read<ScannerLosersManager>();

            value.stopListeningPorts();
            gainersManager.stopListeningPorts();
            losersManager.stopListeningPorts();
          },
          child: BaseScaffold(
            body: Stack(
              children: [
                BaseLoaderContainer(
                  hasData: value.portData != null,
                  isLoading:
                      value.isLoadingPort && value.portData?.port == null,
                  error: value.errorPort,
                  showPreparingText: true,
                  child: Column(
                    children: [
                      BaseTabs(
                        selectedIndex: 1,
                        data: tabs,
                        isScrollable: false,
                        onTap: value.onTabChange,
                      ),
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Column(
                              children: [
                                MarketScannerHeader(isOnline: startStream),
                                if (value.selectedIndex != 0)
                                  ScannerSubHeaderTab(
                                    key: ValueKey(value.selectedSubIndex),
                                  ),
                                MarketSortingHeader(),
                                if (value.selectedIndex == 0) ScannerIndex(),
                                if (value.selectedIndex == 1)
                                  ScannerGainersIndex(),
                                if (value.selectedIndex == 2)
                                  ScannerLosersIndex(),
                              ],
                            ),
                            if (value.selectedIndex == 0 &&
                                checkMarketOpenApi?.scannerStatus == 1)
                              _showBanner(),
                            if (value.selectedIndex == 1 &&
                                checkMarketOpenApi?.gainerStatus == 1)
                              _showBanner(),
                            if (value.selectedIndex == 2 &&
                                checkMarketOpenApi?.loserStatus == 1)
                              _showBanner(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                BaseLockItem(
                  manager: value,
                  callAPI: () async {
                    await value.getScannerPorts(reset: true);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _showBanner() {
    return Consumer<ScannerManager>(
      builder: (context, value, child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl:
                    value.portData?.port?.checkMarketOpenApi?.bannerImage ?? '',
                errorWidget: (context, url, error) {
                  return Container(color: ThemeColors.neutral5);
                },
              ),
              SpacerVertical(height: 10),
              IntrinsicWidth(
                child: BaseButton(
                  text: 'Refresh',
                  onPressed: () {
                    value.onRefresh(withPortRefresh: true);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
