import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/arena/provider/arena.dart';
import 'package:stocks_news_new/arena/screens/tournaments/dayTraining/widgets/leaderboard.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../widgets/card.dart';
import 'widgets/similar.dart';
import 'widgets/timer.dart';

class TournamentDayTrainingIndex extends StatefulWidget {
  final int? tournamentId;
  const TournamentDayTrainingIndex({super.key, this.tournamentId});

  @override
  State<TournamentDayTrainingIndex> createState() =>
      _TournamentDayTrainingIndexState();
}

class _TournamentDayTrainingIndexState
    extends State<TournamentDayTrainingIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArenaProvider>().tournamentDetail(widget.tournamentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      appBar: const AppBarHome(
        isPopBack: true,
        title: 'Day Training',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimen.padding),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 1,
                (context, index) {
                  return Column(
                    children: [
                      DayTrainingTitle(),
                      ArenaThemeCard(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 4,
                                color: ThemeColors.white,
                              ),
                              gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                transform: GradientRotation(1),
                                colors: [
                                  ThemeColors.white,
                                  Color.fromARGB(255, 215, 215, 215),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.star,
                              color: ThemeColors.accent,
                              size: 26,
                            ),
                          ),
                          title: Text(
                            'Tournament rules',
                            style: styleGeorgiaBold(),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: ThemeColors.greyBorder,
                            size: 20,
                          ),
                        ),
                      ),
                      DayTrainingSimilar(),
                      DayTrainingLeaderboard(),
                      SpacerVertical(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
