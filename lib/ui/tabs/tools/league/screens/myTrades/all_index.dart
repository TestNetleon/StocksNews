import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/allTrades/all_trade_index.dart';


class AllTradesIndex extends StatefulWidget {
  final String? typeOfTrade;
  static const path = 'AllTradesIndex';
  const AllTradesIndex({super.key, this.typeOfTrade});

  @override
  State<AllTradesIndex> createState() => _AllTradesIndexState();
}

class _AllTradesIndexState extends State<AllTradesIndex> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: "Trade list",
      ),
      body:LeagueTrades(typeOfTrade:widget.typeOfTrade)
    );
  }
}
