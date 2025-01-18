import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/widgets/header.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'widgets/grid.dart';
import 'widgets/top_traders.dart';

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
    TournamentProvider provider = context.read<TournamentProvider>();
    provider.tournament();
    // provider.getSearchDefaults();
  }

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();
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
              visible: provider.data?.heading != null &&
                  provider.data?.heading != '',
              child: SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${provider.data?.heading}',
                    style: styleGeorgiaBold(fontSize: 18),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: provider.data?.subHeading != null &&
                  provider.data?.subHeading != '',
              child: SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${provider.data?.subHeading}',
                    style: styleGeorgiaBold(fontSize: 18),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: provider.data?.tournamentHeader != null &&
                  provider.data?.tournamentHeader?.isNotEmpty == true,
              child: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TournamentHeader(),
                ),
              ),
            ),
            Visibility(
              visible: provider.data?.tournaments != null &&
                  provider.data?.tournaments?.isNotEmpty == true,
              child: SliverToBoxAdapter(
                child: TournamentGrids(),
              ),
            ),
            Visibility(
              visible: provider.data?.topTradingTitans != null,
              child: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      ScreenTitle(
                        title: provider.data?.topTradingTitans?.title,
                        style: styleGeorgiaBold(fontSize: 17),
                        subTitle: provider.data?.topTradingTitans?.subTitle,
                        dividerPadding: EdgeInsets.zero,
                      ),
                      TopTraders(
                        list: provider.data?.topTradingTitans?.data,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
