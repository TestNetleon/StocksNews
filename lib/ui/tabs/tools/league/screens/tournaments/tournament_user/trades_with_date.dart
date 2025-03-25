import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/all_trades.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/widgets/ticker_item.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';


class TradesWithDate extends StatefulWidget {
  final String? selectedBattleID;
  static const path = 'TradesWithDate';
  const TradesWithDate({super.key, this.selectedBattleID});

  @override
  State<TradesWithDate> createState() => _TradesWithDateState();
}

class _TradesWithDateState extends State<TradesWithDate> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }
  Future _callAPI({loadMore = false}) async {
    LeagueManager manager = context.read<LeagueManager>();
    manager.tradeWithDateAll(loadMore: loadMore,selectedBattleID: widget.selectedBattleID);
  }

  @override
  void dispose() {
    super.dispose();
    SSEManager.instance.disconnectScreen(SimulatorEnum.tournamentTrade);
  }
  @override
  Widget build(BuildContext context) {
    LeagueManager manager = context.watch<LeagueManager>();
    AllTradesRes? tradesWithDateRes= manager.allTrades;
    return BaseScaffold(
      appBar: BaseAppBar(
          showBack: true,
          title: tradesWithDateRes?.title ?? '',

      ),
      body: BaseLoaderContainer(
        hasData: tradesWithDateRes?.data != null && tradesWithDateRes?.data?.isNotEmpty == true,
        isLoading: manager.isLoadingTradeList,
        error: manager.errorTradeList,
        showPreparingText: true,
        onRefresh: _callAPI,
        child: BaseLoadMore(
          onRefresh: _callAPI,
          onLoadMore: () => manager.tradeWithDateAll(loadMore: true,selectedBattleID: widget.selectedBattleID),
          canLoadMore: manager.canLoadMoreTrade,
          child: ListView.separated(
            itemBuilder: (context, index) {
              BaseTickerRes? data = tradesWithDateRes?.data?[index];
              if (data == null) {
                return SizedBox();
              }
              return TickerItem(
                data: data,
                fromTO: 2,
              );
            },
            itemCount: tradesWithDateRes?.data?.length ?? 0,
            separatorBuilder: (context, index) {
              return BaseListDivider(height:  Pad.pad20);
            },
          ),
        ),
      ),
    );
  }
}
