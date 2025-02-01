import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/leaderboard.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/leaderboard/item.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/leaderboard/top_no_item.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/refresh_controll.dart';
import '../../../models/leaderboard.dart';
import '../widgets/dates.dart';
import 'top_widget.dart';

class TournamentLeaderboard extends StatefulWidget {
  const TournamentLeaderboard({super.key});

  @override
  State<TournamentLeaderboard> createState() => _TournamentLeaderboardState();
}

class _TournamentLeaderboardState extends State<TournamentLeaderboard> {
  String? selectedDate;

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    context.read<TournamentLeaderboardProvider>().clearEditedDate();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    TournamentLeaderboardProvider provider =
        context.watch<TournamentLeaderboardProvider>();
    return Column(
      children: [
        CustomDateSelector(
          editedDate: provider.editedDate,
          gameValue: provider.battleRes?.battle,
          onDateSelected: (date) {
            provider.getSelectedDate(date);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<TournamentLeaderboardProvider>().leaderboard();
            });
          },
        ),

        Expanded(
          child: BaseUiContainer(
            hasData: provider.leaderboardRes != null,
            isLoading: provider.isLoadingLeaderboard,
            error: provider.errorLeaderboard,
            showPreparingText: true,
            child: RefreshControl(
              onRefresh: () async => await provider.leaderboard(),
              canLoadMore: provider.canLoadMore,
              onLoadMore: () async =>
                  await provider.leaderboard(loadMore: true),
              child: ListView.separated(
                padding: EdgeInsets.only(top: 10),
                itemBuilder: (context, index) {
                  LeaderboardByDateRes? data =
                      provider.leaderboardRes?.leaderboardByDate?[index];
                  if (data == null) return SizedBox();
                  if (provider.leaderboardRes?.showLeaderboard == false) {
                    return TournamentLeaderboardItem(
                      data: data,
                      from: 2,
                    );
                  }
                  bool isTopPerformer = (data.performance ?? 0) > 0;
                  if (index == 0 && isTopPerformer) {
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Stack(
                            children: [
                              if (provider.leaderboardRes!.leaderboardByDate!
                                          .length >
                                      2 &&
                                  (provider
                                              .leaderboardRes!
                                              .leaderboardByDate![1]
                                              .performance ??
                                          0) >
                                      0)
                                const Positioned(
                                  left: 0,
                                  top: 70,
                                  child: TournamentLeaderboardTopItem(index: 1),
                                )
                              else
                                Positioned(
                                  left: 0,
                                  top: 70,
                                  child: TopNoItem(index: 1),
                                ),
                              if (provider.leaderboardRes!.leaderboardByDate!
                                          .length >
                                      3 &&
                                  (provider
                                              .leaderboardRes!
                                              .leaderboardByDate![2]
                                              .performance ??
                                          0) >
                                      0)
                                const Positioned(
                                  right: 0,
                                  top: 70,
                                  child: TournamentLeaderboardTopItem(index: 2),
                                )
                              else
                                Positioned(
                                  right: 0,
                                  top: 70,
                                  child: TopNoItem(index: 2),
                                ),
                              if (isTopPerformer)
                                const Align(
                                  alignment: Alignment.topCenter,
                                  child: TournamentLeaderboardTopItem(index: 0),
                                ),
                            ],
                          ),
                        ),
                        if ((provider.leaderboardRes?.leaderboardByDate
                                    ?.length ??
                                0) >
                            3)
                          const Divider(
                            color: ThemeColors.greyBorder,
                            height: 15,
                          ),
                      ],
                    );
                  }
                  if ((index == 1||index == 2) && isTopPerformer){
                    return const SizedBox();
                  }

                  return TournamentLeaderboardItem(
                    data: data,
                    from: 2,
                  );
                },
                itemCount:
                    provider.leaderboardRes?.leaderboardByDate?.length ?? 0,
                separatorBuilder: (context, index) {
                  bool isTopPerformer = (provider.leaderboardRes?.leaderboardByDate?[index].performance ?? 0) > 0;
                  if ((index == 0||index == 1||index == 2) && isTopPerformer){
                    return SpacerVertical(height:5);
                  }
                  return SpacerVertical(height: 15);
                },
              ),

            ),
          ),
        ),
      ],
    );
  }
}
