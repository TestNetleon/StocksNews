import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/league_titan_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/trading_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/pointsPaid/filter/league_filter.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/pointsPaid/play_trader_item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class AllTopTtIndex extends StatefulWidget {
  final TournamentsHead selectedTournament;
  final String? title;
  static const path = 'AllTopTtIndex';
  const AllTopTtIndex(
      {super.key, required this.selectedTournament, this.title});

  @override
  State<AllTopTtIndex> createState() => _AllTopTtIndexState();
}

class _AllTopTtIndexState extends State<AllTopTtIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    LeagueManager manager = context.read<LeagueManager>();
    manager.getAllTitans(
        loadMore: loadMore, selectedTournament: widget.selectedTournament);
  }

  void _filterClick() {
    BaseBottomSheet().bottomSheet(
      child: LeagueFilter(selectedTournament: widget.selectedTournament),
    );
  }

  @override
  Widget build(BuildContext context) {
    LeagueManager manager = context.watch<LeagueManager>();
    LeagueTitanRes? leagueTitanRes = manager.leagueTitanRes;

    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: leagueTitanRes?.title ?? '',
        onFilterClick: _filterClick,
      ),
      body: BaseLoaderContainer(
        hasData: leagueTitanRes?.data != null &&
            leagueTitanRes?.data?.isNotEmpty == true,
        isLoading: manager.isLoadingCommonList,
        error: manager.errorCommonList,
        showPreparingText: true,
        onRefresh: _callAPI,
        child: BaseLoadMore(
          onRefresh: _callAPI,
          onLoadMore: () => manager.getAllTitans(
              selectedTournament: widget.selectedTournament,
              loadMore: true,
              clear: false),
          canLoadMore: manager.canLoadMore,
          child: ListView.separated(
            itemBuilder: (context, index) {
              TradingRes? data = leagueTitanRes?.data?[index];
              if (data == null) {
                return SizedBox();
              }
              return PlayTraderItem(
                data: data,
              );
            },
            itemCount: leagueTitanRes?.data?.length ?? 0,
            separatorBuilder: (context, index) {
              return BaseListDivider(height: Pad.pad16);
            },
          ),
        ),
      ),
    );
  }
}
