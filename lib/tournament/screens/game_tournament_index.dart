import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/leaderboard.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

import '../../utils/constants.dart';
import 'allTrades/all_trade_index.dart';
import 'tournaments/tournaments_index.dart';
import 'tournaments/leaderboard/index.dart';

class GameTournamentIndex extends StatefulWidget {
  final int? setIndex;
  const GameTournamentIndex({super.key, this.setIndex});

  @override
  State<GameTournamentIndex> createState() => _GameTournamentIndexState();
}

class _GameTournamentIndexState extends State<GameTournamentIndex> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TournamentLeaderboardProvider>().showLeaderboard();
  }
  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();
    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
        title: provider.extra?.title ?? 'Trading League',
        subTitle: provider.extra?.subTitle,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimen.padding),
        child: CustomTabContainer(
          initialIndex: widget.setIndex ?? 0,
          tabs: List.generate(
            provider.tabs.length,
            (index) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  provider.tabs[index],
                  style: styleGeorgiaBold(fontSize: 14),
                ),
              );
            },
          ),
          widgets: [
            TournamentsIndex(),
            TournamentLeaderboard(),
            TournamentAllTradeIndex(),
          ],
        ),
      ),
    );
  }
}
