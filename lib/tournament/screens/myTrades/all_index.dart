import 'package:flutter/material.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';

import '../../../../widgets/custom_tab_container.dart';
import 'widgets/trades.dart';

class AllTradesOrdersIndex extends StatefulWidget {
  const AllTradesOrdersIndex({super.key});

  @override
  State<AllTradesOrdersIndex> createState() => _AllTradesOrdersIndexState();
}

class _AllTradesOrdersIndexState extends State<AllTradesOrdersIndex> {
  final List<String> _tabs = ['Trades', 'Orders'];

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimen.padding,
          Dimen.padding,
          Dimen.padding,
          0,
        ),
        child: CustomTabContainer(
          tabs: List.generate(
            _tabs.length,
            (index) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _tabs[index],
                ),
              );
            },
          ),
          widgets: [
            TournamentTrades(),
            Container(),
          ],
        ),
      ),
    );
  }
}
