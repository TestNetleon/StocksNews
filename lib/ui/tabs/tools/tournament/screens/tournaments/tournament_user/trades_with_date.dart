import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/tour_user_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/widgets/ticker_item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class TradesWithDate extends StatefulWidget {
  final String? selectedBattleID;
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
    return BaseScaffold(
      appBar: BaseAppBar(
          showBack: true,
          title: manager.extraOfTrade?.title ?? '',

      ),
      body: BaseLoaderContainer(
        hasData: manager.allTrades != null &&
            manager.allTrades?.isNotEmpty == true,
        isLoading: manager.isLoadingTradeList,
        error: manager.errorTradeList,
        showPreparingText: true,
        onRefresh: _callAPI,
        child: BaseLoadMore(
          onRefresh: _callAPI,
          onLoadMore: () => manager.tradeWithDateAll(loadMore: true,selectedBattleID: widget.selectedBattleID),
          canLoadMore: manager.canLoadMoreTrade,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              RecentTradeRes? data = manager.allTrades?[index];
              if (data == null) {
                return SizedBox();
              }
              return TickerItem(
                data: data,
                fromTO: 2,
              );
            },
            itemCount: manager.allTrades?.length ?? 0,
            separatorBuilder: (context, index) {
              return SpacerVertical(height: 10);
            },
          ),
        ),
      ),
    );
  }
}
