import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../models/leaderboard.dart';
import 'item.dart';

class TournamentPointsPaidIndex extends StatefulWidget {
  const TournamentPointsPaidIndex({super.key});

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
    provider.pointsPaidAPI(loadMore: loadMore);
  }

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();

    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
        canSearch: false,
        showTrailing: false,
        title: 'Trades Executed',
      ),
      body: BaseUiContainer(
        hasData: provider.tradesExecuted != null &&
            provider.tradesExecuted?.isNotEmpty == true,
        isLoading: provider.isLoadingCommonList,
        error: provider.errorCommonList,
        showPreparingText: true,
        onRefresh: _callAPI,
        child: RefreshControl(
          onRefresh: _callAPI,
          onLoadMore: () => _callAPI(loadMore: true),
          canLoadMore: provider.canLoadMore,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              LeaderboardByDateRes? data = provider.tradesExecuted?[index];
              if (data == null) {
                return SizedBox();
              }
              return PointsPaidItem(
                data: data,
              );
            },
            itemCount: provider.tradesExecuted?.length ?? 0,
            separatorBuilder: (context, index) {
              return SpacerVertical(height: 10);
            },
          ),
        ),
      ),
    );
  }
}
