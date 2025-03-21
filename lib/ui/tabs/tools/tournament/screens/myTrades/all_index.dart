import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/allTrades/all_trade_index.dart';
import 'package:stocks_news_new/utils/constants.dart';


class AllTradesOrdersIndex extends StatefulWidget {
  final String? typeOfTrade;
  const AllTradesOrdersIndex({super.key, this.typeOfTrade});

  @override
  State<AllTradesOrdersIndex> createState() => _AllTradesOrdersIndexState();
}

class _AllTradesOrdersIndexState extends State<AllTradesOrdersIndex> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: "My Trades in League",
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimen.padding,
          Dimen.padding,
          Dimen.padding,
          0,
        ),
        child: TournamentAllTradeIndex(typeOfTrade:widget.typeOfTrade),
      ),
    );
  }
}
