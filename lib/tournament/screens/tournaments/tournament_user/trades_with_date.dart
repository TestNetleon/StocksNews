import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/tournament/models/tour_user_detail.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/widgets/ticker_item.dart';
import 'package:stocks_news_new/tradingSimulator/manager/sse.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
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
    TournamentProvider provider = context.read<TournamentProvider>();
    provider.tradeWithDateAll(loadMore: loadMore,selectedBattleID: widget.selectedBattleID);
  }

  @override
  void dispose() {
    super.dispose();
    SSEManager.instance.disconnectScreen(SimulatorEnum.tournamentTrade);
  }
  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();
    return BaseContainer(
      appBar: AppBarHome(
          isPopBack: true,
          canSearch: false,
          showTrailing: false,
          title: provider.extraOfTrade?.title ?? '',

      ),
      body: BaseUiContainer(
        hasData: provider.allTrades != null &&
            provider.allTrades?.isNotEmpty == true,
        isLoading: provider.isLoadingTradeList,
        error: provider.errorTradeList,
        showPreparingText: true,
        onRefresh: _callAPI,
        child: RefreshControl(
          onRefresh: _callAPI,
          onLoadMore: () => provider.tradeWithDateAll(loadMore: true,selectedBattleID: widget.selectedBattleID),
          canLoadMore: provider.canLoadMore,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              RecentTradeRes? data = provider.allTrades?[index];
              if (data == null) {
                return SizedBox();
              }
              return TickerItem(
                data: data,
              );
            },
            itemCount: provider.allTrades?.length ?? 0,
            separatorBuilder: (context, index) {
              return SpacerVertical(height: 10);
            },
          ),
        ),
      ),
    );
  }
}
