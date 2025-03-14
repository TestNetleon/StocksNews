import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/index.dart';
import 'package:stocks_news_new/ui/tabs/signals/insiders/filter/filter.dart';
import 'package:stocks_news_new/utils/utils.dart';
import '../../base/common_tab.dart';
import 'insiders/insiders.dart';
import 'politicians/politicians.dart';
import 'sentiment/sentiment.dart';
import 'stocks.dart';

class SignalsIndex extends StatefulWidget {
  const SignalsIndex({super.key});

  @override
  State<SignalsIndex> createState() => _SignalsIndexState();
}

class _SignalsIndexState extends State<SignalsIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SignalsManager manager = context.read<SignalsManager>();
      manager.onScreenChange(0);
    });
  }

  void _onFilterClick() {
    Navigator.push(
      context,
      createRoute(
        InsiderFilter(marketIndex: 0, marketInnerIndex: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SignalsManager manager = context.watch<SignalsManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showSearch: true,
        showDrawer: true,
        leadingFilterClick: manager.selectedScreen == 2 ? _onFilterClick : null,
      ),
      drawer: MoreIndex(),
      body: Column(
        children: [
          BaseTabs(
            data: manager.tabs,
            onTap: manager.onScreenChange,
          ),
          if (manager.selectedScreen == 0)
            Expanded(
              child: SignalStocksIndex(),
            ),
          if (manager.selectedScreen == 1)
            Expanded(
              child: SignalSentimentIndex(),
            ),
          if (manager.selectedScreen == 2)
            Expanded(
              child: SignalInsidersIndex(),
            ),
          if (manager.selectedScreen == 3)
            Expanded(
              child: SignalPoliticiansIndex(),
            ),
        ],
      ),
    );
  }
}
