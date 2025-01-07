import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/leaderboard.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/leaderboard/item.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    TournamentLeaderboardProvider provider =
        context.watch<TournamentLeaderboardProvider>();
    return Column(
      children: [
        CustomDateSelector(
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
                  if (index == 0) {
                    return Column(
                      children: [
                        const SizedBox(
                          // height: 300,
                          width: double.infinity,
                          // color: ThemeColors.accent,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 80,
                                child: TournamentLeaderboardTopItem(index: 1),
                              ),
                              Positioned(
                                right: 0,
                                top: 80,
                                child: TournamentLeaderboardTopItem(index: 2),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: TournamentLeaderboardTopItem(index: 0),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: (provider.leaderboardRes?.leaderboardByDate
                                      ?.length ??
                                  0) >
                              3,
                          // visible: listData.length > 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(
                                color: ThemeColors.greyBorder,
                                height: 15,
                              ),
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       "RANKING",
                              //       style: stylePTSansRegular(
                              //           color: ThemeColors.greyBorder),
                              //     ),
                              //     Text(
                              //       "POINTS",
                              //       style: stylePTSansRegular(
                              //           color: ThemeColors.greyBorder),
                              //     ),
                              //   ],
                              // ),
                              // const Divider(
                              //   color: ThemeColors.greyBorder,
                              //   height: 15,
                              // ),
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  if (index == 1 || index == 2) {
                    return const SizedBox();
                  }

                  if (data == null) {
                    return SizedBox();
                  }
                  return TournamentLeaderboardItem(
                    data: data,
                  );
                },
                itemCount:
                    provider.leaderboardRes?.leaderboardByDate?.length ?? 0,
                separatorBuilder: (context, index) {
                  if (index == 1 || index == 2) {
                    return const SizedBox();
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
