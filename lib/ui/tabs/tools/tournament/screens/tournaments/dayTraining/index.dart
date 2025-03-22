import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/tournament_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/dayTraining/widgets/leaderboard.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/dayTraining/widgets/rules.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/dayTraining/widgets/timer.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
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
      context.read<LeagueManager>().tournamentDetail(widget.tournamentId);
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
    navigatorKey.currentContext!.read<LeagueManager>().stopCountdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LeagueManager manager = context.watch<LeagueManager>();
    LeagueDetailRes? leagueDetailRes= manager.detailRes;
    return BaseScaffold(
      appBar:  BaseAppBar(
        showBack: true,
        title: manager.isLoadingDetail
            ? ""
            : leagueDetailRes?.title ?? "",
        showSearch: true,
        showNotification: true,
      ),
      body: BaseLoaderContainer(
        hasData: manager.detailRes != null,
        isLoading: manager.isLoadingDetail,
        error: manager.errorDetail,
        showPreparingText: true,
        onRefresh: () {
          manager.tournamentDetail(widget.tournamentId);
        },
        child: BaseScroll(
          onRefresh: () async {
            manager.tournamentDetail(widget.tournamentId);
          },
          margin: EdgeInsets.zero,
          children: [
            DayTrainingTitle(),
            SpacerVertical(),
            CommonCard(
              margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: ListTile(
                leading:
                Icon(
                  Icons.star_outline_sharp,
                  size: 26,
                ),
                title: Text(
                  'Tournament Rules',
                  style: styleBaseBold(),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 20,
                ),
                onTap: _tournamentRuleDetails,
              ),
            ),
            SpacerVertical(),
            Visibility(
                visible: leagueDetailRes?.todayLeaderboard !=
                    null &&
                    leagueDetailRes?.todayLeaderboard
                        ?.isNotEmpty ==
                        true,
                child: DayTrainingLeaderboard()
            ),
            SpacerVertical(),
          ],
        ),
      ),
    );
  }
}
