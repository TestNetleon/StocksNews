import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/dayTraining/widgets/leaderboard.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/dialogs.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../widgets/card.dart';
import 'widgets/rules.dart';
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
      context.read<TournamentProvider>().tournamentDetail(widget.tournamentId);
    });
  }

  _tournamentRuleDetails() {
    showPlatformBottomSheet(
      context: context,
      padding: EdgeInsets.only(right: 10),
      content: TournamentRules(),
    );
  }

  @override
  void dispose() {
    Utils().showLog('DISPOSING TOURNAMENT');
    navigatorKey.currentContext!.read<TournamentProvider>().stopCountdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();
    return BaseContainer(
      appBar: const AppBarHome(
        isPopBack: true,
        title: 'Day Training',
      ),
      body: BaseUiContainer(
        hasData: provider.detailRes != null,
        isLoading: provider.isLoadingDetail,
        error: provider.errorDetail,
        showPreparingText: true,
        onRefresh: () {
          provider.tournamentDetail(widget.tournamentId);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimen.padding),
          child: CommonRefreshIndicator(
            onRefresh: () async {
              provider.tournamentDetail(widget.tournamentId);
            },
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: 1,
                    (context, index) {
                      return Column(
                        children: [
                          DayTrainingTitle(),
                          TournamentThemeCard(
                            onTap: _tournamentRuleDetails,
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
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
                                'Tournament Rules',
                                style: styleGeorgiaBold(),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: ThemeColors.greyBorder,
                                size: 20,
                              ),
                            ),
                          ),
                          // DayTrainingSimilar(),
                          Visibility(
                              visible: provider.detailRes?.todayLeaderboard !=
                                      null &&
                                  provider.detailRes?.todayLeaderboard
                                          ?.isNotEmpty ==
                                      true,
                              child: DayTrainingLeaderboard()
                          ),
                          SpacerVertical(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
