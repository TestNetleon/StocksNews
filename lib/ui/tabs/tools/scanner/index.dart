import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';

import '../../../base/common_tab.dart';

class ScannerIndex extends StatefulWidget {
  final int? index;
  static const path = 'ScannerIndex';
  const ScannerIndex({super.key, this.index = 0});

  @override
  State<ScannerIndex> createState() => _ScannerIndexState();
}

class _ScannerIndexState extends State<ScannerIndex> {
  int selectedIndex = 0;

  List<MarketResData> tabs = [
    MarketResData(title: 'SCANNER', slug: 'slug'),
    MarketResData(title: 'GAINERS', slug: 'gainers'),
    MarketResData(title: 'LOSERS', slug: 'losers'),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.index ?? 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        showClose: true,
      ),
      body: Column(
        children: [
          BaseTabs(
            data: tabs,
            isScrollable: false,
            onTap: (index) {},
          ),
        ],
      ),
    );
  }
}
