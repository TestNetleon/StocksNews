import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/widgets/grid.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/widgets/header.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/widgets/top_tading.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/widgets/top_traders.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


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
  }

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();
    return BaseLoaderContainer(
      hasData: provider.data != null,
      isLoading: provider.isLoadingTournament,
      error: provider.error,
      showPreparingText: true,
      child: CommonRefreshIndicator(
        onRefresh: _callAPI,
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Visibility(
                visible: provider.data?.heading != null &&
                    provider.data?.heading != '',
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${provider.data?.heading}',
                    style: styleBaseBold(fontSize: 18),
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
                    style: styleBaseBold(fontSize: 18),
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
                      const SpacerVertical(height: 8),
                      BaseHeading(
                        title: provider.data?.topTradingTitans?.title,
                        subtitle: provider.data?.topTradingTitans?.subTitle,
                        titleStyle: styleBaseBold(fontSize: 24),
                        subtitleStyle: styleBaseRegular(fontSize: 16,color: ThemeColors.neutral80),
                        viewMore: () {
                          var selectedTournament = TournamentsHead.topTitan;
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return TopTading(
                                  title: provider.data?.topTradingTitans?.title,
                                  selectedTournament: selectedTournament);
                            },
                          ));
                        },
                      ),


                      const SpacerVertical(height: 10),
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
