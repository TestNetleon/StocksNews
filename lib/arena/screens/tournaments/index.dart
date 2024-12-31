import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/arena/provider/arena.dart';
import 'package:stocks_news_new/arena/screens/tournaments/widgets/header.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'widgets/grid.dart';

class TournamentsIndex extends StatefulWidget {
  const TournamentsIndex({super.key});

  @override
  State<TournamentsIndex> createState() => _TournamentsIndexState();
}

class _TournamentsIndexState extends State<TournamentsIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI() async {
    ArenaProvider provider = context.read<ArenaProvider>();
    provider.getTournamentData();
    provider.getSearchDefaults();
  }

  @override
  Widget build(BuildContext context) {
    ArenaProvider provider = context.watch<ArenaProvider>();
    return BaseUiContainer(
      hasData: provider.data != null,
      isLoading: provider.isLoadingTournament,
      error: provider.error,
      showPreparingText: true,
      child: CommonRefreshIndicator(
        onRefresh: _callAPI,
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            Visibility(
              visible: provider.data?.tournamentHeader != null &&
                  provider.data?.tournamentHeader?.isNotEmpty == true,
              child: SliverToBoxAdapter(
                child: TournamentHeader(),
              ),
            ),
            Visibility(
              visible: provider.data?.tournaments != null &&
                  provider.data?.tournaments?.isNotEmpty == true,
              child: SliverToBoxAdapter(
                child: TournamentGrids(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
