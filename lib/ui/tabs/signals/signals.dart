import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals/insiders.dart';
import 'package:stocks_news_new/managers/signals/politicians.dart';
import 'package:stocks_news_new/managers/signals/stocks.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/signals/insiders/filter/filter.dart';
import 'package:stocks_news_new/ui/tabs/signals/politicians/filter/filter.dart';
import 'package:stocks_news_new/ui/tabs/signals/stocks/filter/filter.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../base/common_tab.dart';
import 'insiders/insiders.dart';
import 'politicians/politicians.dart';
import 'sentiment/sentiment.dart';
import 'stocks/stocks.dart';

class SignalsIndex extends StatefulWidget {
  final int? index;
  const SignalsIndex({super.key, this.index = 0});

  @override
  State<SignalsIndex> createState() => _SignalsIndexState();
}

class _SignalsIndexState extends State<SignalsIndex> {
  int? _selectedScreen = 0;

  List<MarketResData> tabs = [
    MarketResData(title: 'Stocks'),
    MarketResData(title: 'Sentiment'),
    MarketResData(title: 'Insiders'),
    MarketResData(title: 'Politicians'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // SignalsManager manager = context.read<SignalsManager>();
      // manager.onScreenChange(widget.index ?? 0);
      _selectedScreen = widget.index ?? 0;
    });
  }

  void _onFilterClick() {
    if (_selectedScreen == 0) {
      Navigator.push(context, createRoute(StocksFilter()));
    } else if (_selectedScreen == 2) {
      Navigator.push(context, createRoute(InsiderFilter()));
    } else if (_selectedScreen == 3) {
      Navigator.push(context, createRoute(PoliticianFilter()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // SignalsManager manager = context.watch<SignalsManager>();

    SignalsStocksManager managerStocks = context.watch<SignalsStocksManager>();
    bool isFilteredStocks = managerStocks.filterRequest != null;

    SignalsInsiderManager manager = context.watch<SignalsInsiderManager>();
    bool isFilteredInsider = manager.filterRequest != null;

    SignalsPoliticianManager managerSP =
        context.watch<SignalsPoliticianManager>();
    bool isFilteredPolitician = managerSP.filterRequest != null;

    return BaseScaffold(
      appBar: BaseAppBar(
        showSearch: true,
        showNotification: true,
        showBack: true,
        // leadingFilterClick: manager.selectedScreen == 2 ? _onFilterClick : null,
        leadingFilterClick: _selectedScreen == 1 ? null : _onFilterClick,
        isFiltered: (_selectedScreen == 0 && isFilteredStocks) ||
            (_selectedScreen == 2 && isFilteredInsider) ||
            (_selectedScreen == 3 && isFilteredPolitician),
      ),
      // drawer: MoreIndex(),
      body: Column(
        children: [
          BaseTabs(
            data: tabs,
            // onTap: manager.onScreenChange,
            onTap: (index) {
              setState(() {
                _selectedScreen = index;
              });
            },
            selectedIndex: widget.index ?? 0,
          ),
          if (_selectedScreen == 0)
            Expanded(
              child: SignalStocksIndex(),
            ),
          if (_selectedScreen == 1)
            Expanded(
              child: SignalSentimentIndex(),
            ),
          if (_selectedScreen == 2)
            Expanded(
              child: SignalInsidersIndex(),
            ),
          if (_selectedScreen == 3)
            Expanded(
              child: SignalPoliticiansIndex(),
            ),
        ],
      ),
    );
  }
}
