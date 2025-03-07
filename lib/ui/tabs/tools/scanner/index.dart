import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/gainers.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/losers.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/screens/losers/losers.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

import '../../../base/common_tab.dart';
import 'screens/extra/header.dart';
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

class _ToolsScannerIndexState extends State<ToolsScannerIndex> {
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
      context.read<ScannerManager>().getScannerPorts(reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScannerManager manager = context.watch<ScannerManager>();
    bool startStream =
        manager.portData?.port?.checkMarketOpenApi?.startStreaming == true;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ScannerGainersManager gainersManager =
            context.read<ScannerGainersManager>();
        ScannerLosersManager losersManager =
            context.read<ScannerLosersManager>();

        manager.stopListeningPorts();
        gainersManager.stopListeningPorts();
        losersManager.stopListeningPorts();
      },
      child: BaseScaffold(
        appBar: BaseAppBar(
          showBack: true,
        ),
        body: BaseLoaderContainer(
          hasData: manager.portData?.port != null,
          isLoading: manager.isLoadingPort && manager.portData == null,
          error: manager.errorPort,
          showPreparingText: true,
          child: Column(
            children: [
              BaseTabs(
                selectedIndex: 1,
                data: tabs,
                isScrollable: false,
                onTap: manager.onTabChange,
              ),
              MarketScannerHeader(
                  key: ValueKey(manager.selectedSubIndex),
                  isOnline: startStream),
              if (manager.selectedIndex != 0) ScannerSubHeaderTab(),
              if (manager.selectedIndex == 0) ScannerIndex(),
              if (manager.selectedIndex == 1) ScannerGainersIndex(),
              if (manager.selectedIndex == 2) ScannerLosersIndex(),
            ],
          ),
        ),
      ),
    );
  }
}
