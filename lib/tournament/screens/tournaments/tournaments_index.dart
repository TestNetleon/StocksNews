import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/featured/widgets/title.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/pointsPaid/index.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/widgets/header.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
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
           /* SliverToBoxAdapter(
              child: Container(
                margin:const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    transform: GradientRotation(0.9),
                    colors: [
                      ThemeColors.bottomsheetGradient,
                      ThemeColors.accent,
                    ],
                  ),
                ),
                child: Row(children: [
                  InfoBox(
                      label: 'Performance',
                      value:""),
                   InfoBox(
                                label: 'Rank',
                                value:""),
                  InfoBox(
                      label: 'Points',
                      value:""),
                ]),
              ),
            ),*/
            SliverToBoxAdapter(
              child: Visibility(
                visible: provider.data?.heading != null &&
                    provider.data?.heading != '',
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${provider.data?.heading}',
                    style: styleGeorgiaBold(fontSize: 18),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Visibility(
                visible: provider.data?.subHeading != null &&
                    provider.data?.subHeading != '',
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${provider.data?.subHeading}',
                    style: styleGeorgiaBold(fontSize: 18),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Visibility(
                visible: provider.data?.tournamentHeader != null &&
                    provider.data?.tournamentHeader?.isNotEmpty == true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TournamentHeader(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Visibility(
                visible: provider.data?.tournaments != null &&
                    provider.data?.tournaments?.isNotEmpty == true,
                child: TournamentGrids(),
              ),
            ),
            SliverToBoxAdapter(
              child: Visibility(
                visible: provider.data?.topTradingTitans != null,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      const SpacerVertical(height:8),
                      FeaturedWatchlistTitle(
                        title:provider.data?.topTradingTitans?.title,
                        onTap: () {
                          var selectedTournament = TournamentsHead.playTraders;
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return TournamentPointsPaidIndex(selectedTournament:selectedTournament);
                            },
                          ));
                        },
                      ),
                      const SpacerVertical(height:3),
                      ScreenTitle(
                        subTitle: provider.data?.topTradingTitans?.subTitle,
                        dividerPadding: EdgeInsets.zero,
                      ),
                      const SpacerVertical(height:10),
                      TopTraders(
                        list: provider.data?.topTradingTitans?.data,
                      ),
                      const SpacerVertical(),
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
