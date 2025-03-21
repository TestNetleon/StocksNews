import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/dayTraining/widgets/leaderboard.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/dayTraining/widgets/rules.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/dayTraining/widgets/timer.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/widgets/card.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


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
    BaseBottomSheet().bottomSheet(
      child: TournamentRules(),
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
    return BaseScaffold(
      appBar: const BaseAppBar(
        showBack: true,
        title: 'Day Training',
      ),
      body: BaseLoaderContainer(
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
                                  gradient:  LinearGradient(
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
                                style: styleBaseBold(),
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
