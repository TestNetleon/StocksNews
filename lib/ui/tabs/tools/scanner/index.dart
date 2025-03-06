import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

import '../../../base/common_tab.dart';
import 'screens/gainers/gainers.dart';

class ScannerIndex extends StatefulWidget {
  final int? index;
  static const path = 'ScannerIndex';
  const ScannerIndex({super.key, this.index = 1});

  @override
  State<ScannerIndex> createState() => _ScannerIndexState();
}

class _ScannerIndexState extends State<ScannerIndex> {
  int selectedIndex = 1;

  List<MarketResData> tabs = [
    MarketResData(title: 'SCANNER', slug: 'slug'),
    MarketResData(title: 'GAINERS', slug: 'gainers'),
    MarketResData(title: 'LOSERS', slug: 'losers'),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.index ?? 1;
    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScannerManager>().getScannerPorts();
    });
  }

  @override
  Widget build(BuildContext context) {
    ScannerManager manager = context.watch<ScannerManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
      ),
      body: BaseLoaderContainer(
        hasData: manager.port != null,
        isLoading: manager.isLoading,
        error: manager.error,
        showPreparingText: true,
        child: Column(
          children: [
            BaseTabs(
              selectedIndex: selectedIndex,
              data: tabs,
              isScrollable: false,
              onTap: (index) {},
            ),
            if (selectedIndex == 0) Container(),
            if (selectedIndex == 1) ScannerGainersIndex(),
            if (selectedIndex == 2) Container(),
          ],
        ),
      ),
    );
  }
}
