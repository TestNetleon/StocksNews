import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/arena/provider/arena.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/custom_tab_container.dart';

import '../../utils/constants.dart';
import 'tournaments/index.dart';
import 'tournaments/leaderboard/index.dart';

class ArenaIndex extends StatefulWidget {
  const ArenaIndex({super.key});

  @override
  State<ArenaIndex> createState() => _ArenaIndexState();
}

class _ArenaIndexState extends State<ArenaIndex> {
  @override
  Widget build(BuildContext context) {
    ArenaProvider provider = context.watch<ArenaProvider>();
    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
        title: 'Game Arena',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimen.padding),
        child: CustomTabContainer(
          tabs: List.generate(
            provider.tabs.length,
            (index) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  provider.tabs[index],
                ),
              );
            },
          ),
          widgets: [
            TournamentsIndex(),
            TournamentLeaderboard(),
            Container(),
          ],
        ),
      ),
    );
  }
}
