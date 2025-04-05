import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/widgets/grid.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/widgets/header.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/widgets/top_tading.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/widgets/top_traders.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class LeagueIndex extends StatefulWidget {
  const LeagueIndex({super.key});

  @override
  State<LeagueIndex> createState() => _LeagueIndexState();
}

class _LeagueIndexState extends State<LeagueIndex> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LeagueManager manager = context.watch<LeagueManager>();
    return BaseLoaderContainer(
      hasData: manager.data != null,
      isLoading: manager.isLoadingTournament,
      error: manager.error,
      showPreparingText: true,
      child: BaseScroll(
        onRefresh: manager.tournament,
        margin: EdgeInsets.zero,
        children: [
          SpacerVertical(height: Pad.pad10),
          Visibility(
            visible:
                manager.data?.heading != null && manager.data?.heading != '',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Pad.pad16),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '${manager.data?.heading}',
                  style: styleBaseBold(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Visibility(
            visible: manager.data?.subHeading != null &&
                manager.data?.subHeading != '',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Pad.pad16),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '${manager.data?.subHeading}',
                  style: styleBaseBold(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SpacerVertical(height: Pad.pad16),
          Visibility(
            visible: manager.data?.tournamentHeader != null &&
                manager.data?.tournamentHeader?.isNotEmpty == true,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Pad.pad16, vertical: Pad.pad10),
              child: LeagueHeader(),
            ),
          ),
          SpacerVertical(height: Pad.pad24),
          Visibility(
            visible: manager.data?.tournaments != null &&
                manager.data?.tournaments?.isNotEmpty == true,
            child: LeagueGrids(),
          ),
          Visibility(
            visible: manager.data?.topTradingTitans != null,
            child: Column(
              children: [
                const SpacerVertical(height: Pad.pad24),
                BaseHeading(
                  title: manager.data?.topTradingTitans?.title,
                  viewMoreText: "View More",
                  viewMore: () {
                    var selectedTournament = TournamentsHead.topTitan;
                    // Navigator.pushNamed(context, AllTopTtIndex.path,
                    //     arguments: {
                    //       "selectedTournament": selectedTournament,
                    //       "title": manager.data?.topTradingTitans?.title,
                    //     });
                    Navigator.push(
                        navigatorKey.currentContext!,
                        MaterialPageRoute(
                            builder: (context) => AllTopTtIndex(
                                  selectedTournament: selectedTournament,
                                  title: manager.data?.topTradingTitans?.title,
                                )));
                  },
                  margin: const EdgeInsets.symmetric(horizontal: Pad.pad16),
                ),
                const SpacerVertical(height: Pad.pad10),
                TopTraders(
                  list: manager.data?.topTradingTitans?.data,
                ),
                const SpacerVertical(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
