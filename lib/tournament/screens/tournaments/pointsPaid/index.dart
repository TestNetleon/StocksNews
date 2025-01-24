import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/pointsPaid/league_total_item.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/pointsPaid/play_trader_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/refresh_controll.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../models/leaderboard.dart';
import 'item.dart';

class TournamentPointsPaidIndex extends StatefulWidget {
  final TournamentsHead selectedTournament;
  const TournamentPointsPaidIndex({super.key, required this.selectedTournament});

  @override
  State<TournamentPointsPaidIndex> createState() =>
      _TournamentPointsPaidIndexState();
}

class _TournamentPointsPaidIndexState extends State<TournamentPointsPaidIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    TournamentProvider provider = context.read<TournamentProvider>();
    provider.pointsPaidAPI(loadMore: loadMore,selectedTournament:widget.selectedTournament);
  }

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();

    return BaseContainer(
      appBar: AppBarHome(
        isPopBack: true,
        canSearch: false,
        showTrailing: false,
        title: provider.extraOfPointPaid?.title ?? 'Trades Executed',
        subTitle: provider.extraOfPointPaid?.subTitle,
        /// displayed title,subtitle with dynamic value
      ),
      body: BaseUiContainer(
        hasData: provider.tradesExecuted != null &&
            provider.tradesExecuted?.isNotEmpty == true,
        isLoading: provider.isLoadingCommonList,
        error: provider.errorCommonList,
        showPreparingText: true,
        onRefresh: _callAPI,
        child: RefreshControl(
          onRefresh: _callAPI,
          onLoadMore: () => _callAPI(loadMore: true),
          canLoadMore: provider.canLoadMore,
          child:
          widget.selectedTournament==TournamentsHead.tradTotal?
          ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              LeaderboardByDateRes? data = provider.tradesExecuted?[index];
              if (data == null) {
                return SizedBox();
              }
              if (index == 0) {
                return Column(
                  children: [
                    Divider(
                      color: ThemeColors.greyBorder,
                      height: 15,
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: AutoSizeText(
                            maxLines: 1,
                            "Trading LEAGUE",
                            style: stylePTSansRegular(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        AutoSizeText(
                          maxLines: 1,
                          "USER JOINED",
                          textAlign: TextAlign.end,
                          style: stylePTSansRegular(
                            fontSize: 12,
                            color: ThemeColors.greyText,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: ThemeColors.greyBorder,
                      height: 15,
                      thickness: 1,
                    ),
                    LeagueTotalItem(
                      data: data,
                    ),
                  ],
                );
              }
              return LeagueTotalItem(
                data: data,
              );
            },
            itemCount: provider.tradesExecuted?.length ?? 0,
            separatorBuilder: (context, index) {
              return SpacerVertical(height: 10);
            },
          ):
          widget.selectedTournament==TournamentsHead.pPaid?
          ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              LeaderboardByDateRes? data = provider.tradesExecuted?[index];
              if (data == null) {
                return SizedBox();
              }
              if (index == 0) {
                return Column(
                  children: [
                    Divider(
                      color: ThemeColors.greyBorder,
                      height: 15,
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: AutoSizeText(
                            maxLines: 1,
                            "POSITION",
                            style: stylePTSansRegular(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        AutoSizeText(
                          maxLines: 1,
                          "POINTS",
                          textAlign: TextAlign.end,
                          style: stylePTSansRegular(
                            fontSize: 12,
                            color: ThemeColors.greyText,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: ThemeColors.greyBorder,
                      height: 15,
                      thickness: 1,
                    ),
                    PointsPaidItem(
                      data: data,
                    ),
                  ],
                );
              }

              return PointsPaidItem(
                data: data,
              );
            },
            itemCount: provider.tradesExecuted?.length ?? 0,
            separatorBuilder: (context, index) {
              return SpacerVertical(height: 10);
            },
          ):
          ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              LeaderboardByDateRes? data = provider.tradesExecuted?[index];
              if (data == null) {
                return SizedBox();
              }
              if (index == 0) {
                return Column(
                  children: [
                    Divider(
                      color: ThemeColors.greyBorder,
                      height: 15,
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: AutoSizeText(
                            maxLines: 1,
                            "POSITION",
                            style: stylePTSansRegular(
                              fontSize: 12,
                              color: ThemeColors.greyText,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        AutoSizeText(
                          maxLines: 1,
                          "PERFORMANCE",
                          textAlign: TextAlign.end,
                          style: stylePTSansRegular(
                            fontSize: 12,
                            color: ThemeColors.greyText,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: ThemeColors.greyBorder,
                      height: 15,
                      thickness: 1,
                    ),
                    PlayTraderItem(
                      data: data,
                    ),
                  ],
                );
              }


              return PlayTraderItem(
                data: data,
              );
            },
            itemCount: provider.tradesExecuted?.length ?? 0,
            separatorBuilder: (context, index) {
              return SpacerVertical(height: 10);
            },
          ),
        ),
      ),
    );
  }
}
