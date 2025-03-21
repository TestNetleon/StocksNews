import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/exchange/derivatives.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/exchange/spot.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../../utils/constants.dart';
import '../../../../base/common_tab.dart';

class ExchangeIndex extends StatefulWidget {
  const ExchangeIndex({super.key});

  @override
  State<ExchangeIndex> createState() => _ExchangeIndexState();
}

class _ExchangeIndexState extends State<ExchangeIndex> {

  int selectedTab = 0;
  onTabChange(index) {
    selectedTab = index;
    setState(() {});
  }
  List<MarketResData> tabs = [
    MarketResData(title: 'Spot', slug: 'spot'),
    MarketResData(title: 'Derivatives', slug: 'derivatives'),
  ];

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SpacerVertical(height: Pad.pad10),
        BaseTabs(
          data: tabs,
          onTap:onTabChange,
          isScrollable: false,
          showDivider: true,
        ),
        SpacerVertical(height: Pad.pad10),
        if (selectedTab == 0) Expanded(child: SpotIndex()),
        if (selectedTab == 1) Expanded(child: DerivativesIndex()),
      ],
    );
  }
}
