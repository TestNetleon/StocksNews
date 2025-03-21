import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/leaderboard.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/pointsPaid/filter/league_filter.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/pointsPaid/item.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/pointsPaid/league_total_item.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/pointsPaid/play_trader_item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';


class TournamentPointsPaidIndex extends StatefulWidget {
  final TournamentsHead selectedTournament;
  const TournamentPointsPaidIndex(
      {super.key, required this.selectedTournament});

  @override
  State<TournamentPointsPaidIndex> createState() =>
      _TournamentPointsPaidIndexState();
}

class _TournamentPointsPaidIndexState extends State<TournamentPointsPaidIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    TournamentProvider provider = context.read<TournamentProvider>();
    provider.pointsPaidAPI(loadMore: loadMore, selectedTournament: widget.selectedTournament);
  }

  void _filterClick() {
    BaseBottomSheet().bottomSheet(
      child: LeagueFilter(selectedTournament: widget.selectedTournament),
    );
  }



  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: provider.extraOfPointPaid?.title ?? '',
        onFilterClick:_filterClick,
      ),
      body: BaseLoaderContainer(
        hasData: provider.tradesExecuted != null &&
            provider.tradesExecuted?.isNotEmpty == true,
        isLoading: provider.isLoadingCommonList,
        error: provider.errorCommonList,
        showPreparingText: true,
        onRefresh: _callAPI,
        child: BaseLoadMore(
          onRefresh: _callAPI,
          onLoadMore: () => provider.pointsPaidAPI(selectedTournament: widget.selectedTournament,loadMore: true, clear: false),
          canLoadMore: provider.canLoadMore,
          child: widget.selectedTournament == TournamentsHead.tradTotal
              ? ListView.separated(
                  itemBuilder: (context, index) {
                    LeaderboardByDateRes? data =
                        provider.tradesExecuted?[index];
                    if (data == null) {
                      return SizedBox();
                    }
                    return LeagueTotalItem(
                      data: data,
                    );
                  },
                  itemCount: provider.tradesExecuted?.length ?? 0,
                  separatorBuilder: (context, index) {
                    return BaseListDivider(height: 10);
                  },
                )
              : widget.selectedTournament == TournamentsHead.pPaid
                  ? ListView.separated(
                      itemBuilder: (context, index) {
                        LeaderboardByDateRes? data =
                            provider.tradesExecuted?[index];
                        if (data == null) {
                          return SizedBox();
                        }

                        return PointsPaidItem(
                          data: data,
                        );
                      },
                      itemCount: provider.tradesExecuted?.length ?? 0,
                      separatorBuilder: (context, index) {
                        return BaseListDivider(height: 10);
                      },
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        LeaderboardByDateRes? data =
                            provider.tradesExecuted?[index];
                        if (data == null) {
                          return SizedBox();
                        }

                        return PlayTraderItem(
                          data: data,
                        );
                      },
                      itemCount: provider.tradesExecuted?.length ?? 0,
                      separatorBuilder: (context, index) {
                        return BaseListDivider(height: 10);
                      },
                    ),
        ),
      ),
    );
  }
}
