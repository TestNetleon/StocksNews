import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import '../allTrades/all_trade_index.dart';

class AllTradesOrdersIndex extends StatefulWidget {
  final String? typeOfTrade;
  const AllTradesOrdersIndex({super.key, this.typeOfTrade});

  @override
  State<AllTradesOrdersIndex> createState() => _AllTradesOrdersIndexState();
}

class _AllTradesOrdersIndexState extends State<AllTradesOrdersIndex> {
  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
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
