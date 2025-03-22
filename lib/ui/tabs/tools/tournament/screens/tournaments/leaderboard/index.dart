import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/trading_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/leaderboard.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/leaderboard/item.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/leaderboard/top_no_item.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/leaderboard/top_widget.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/widgets/dates.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';



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
    WidgetsBinding.instance.addPostFrameCallback((_) {
     // _callAPI();
    });
  }

  Future _callAPI() async {
    TournamentLeaderboardProvider provider = context.read<TournamentLeaderboardProvider>();
    provider.showLeaderboard();
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
    return BaseLoaderContainer(
      hasData: provider.battleRes != null,
      isLoading: provider.isLoadingBattle,
      error: provider.errorBattels,
      showPreparingText: true,
      child: Column(
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
            child: BaseLoaderContainer(
                hasData: provider.leaderboardRes != null,
                isLoading: provider.isLoadingLeaderboard,
                error: provider.errorLeaderboard,
                showPreparingText: true,
                child: Column(
                  children: [
                    if (provider.leaderboardRes?.showLeaderboard == true)
                      provider.topPerformers.isNotEmpty
                          ? SizedBox(
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  if (provider.topPerformers.length >= 2 &&
                                      (provider.topPerformers[1]?.performance ??
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
                                      child: TopNoItem(index: 1, showAll: false),
                                    ),
                                  if (provider.topPerformers.length >= 3 &&
                                      (provider.topPerformers[2]?.performance ??
                                              0) >
                                          0)
                                    const Positioned(
                                      right: 0,
                                      top: 70,
                                      child: TournamentLeaderboardTopItem(
                                          index: 2),
                                    )
                                  else
                                    Positioned(
                                      right: 0,
                                      top: 70,
                                      child: TopNoItem(index: 2, showAll: false),
                                    ),
                                  const Align(
                                    alignment: Alignment.topCenter,
                                    child:
                                        TournamentLeaderboardTopItem(index: 0),
                                  ),
                                ],
                              ),
                            )
                          : Visibility(
                              visible:
                                  (provider.leaderboardRes?.showLeaderboard ==
                                      true),
                              child: SizedBox(
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 50,
                                      child: TopNoItem(index: 1),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 50,
                                      child: TopNoItem(index: 2),
                                    ),
                                    const Align(
                                      alignment: Alignment.topCenter,
                                      child: TopNoItem(index: 0),
                                    ),
                                  ],
                                ),
                              )
                      ),
                    Visibility(
                      visible:
                          provider.leaderboardRes?.loginUserPosition != null,
                      child: CommonCard(
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.only(top: 16, bottom: 8),
                        child: ListTile(
                          onTap: () async {
                            context.read<LeagueManager>().profileRedirection(
                                userId:
                                "${provider.leaderboardRes?.loginUserPosition?.userId ?? ""}");
                          },
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          minTileHeight: 60,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 43,
                              height: 43,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: ThemeColors.greyBorder)),
                              child: provider.leaderboardRes?.loginUserPosition
                                          ?.imageType ==
                                      "svg"
                                  ? SvgPicture.network(
                                      fit: BoxFit.cover,
                                      provider.leaderboardRes?.loginUserPosition
                                              ?.userImage ??
                                          "",
                                      placeholderBuilder:
                                          (BuildContext context) => Container(
                                        padding: const EdgeInsets.all(30.0),
                                        child: const CircularProgressIndicator(
                                          color: ThemeColors.accent,
                                        ),
                                      ),
                                    )
                                  : CachedNetworkImagesWidget(provider
                                      .leaderboardRes
                                      ?.loginUserPosition
                                      ?.userImage),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                'MY POSITION',
                                style: styleBaseRegular(fontSize: 14),
                              ),
                              SpacerHorizontal(width: 10),
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: ThemeColors.gold,
                                child: Text(
                                    "${provider.leaderboardRes?.loginUserPosition?.position ?? 0}",
                                    style: styleBaseRegular(
                                        color: ThemeColors.black)),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: ThemeColors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: BaseLoadMore(
                        onRefresh: () async => await provider.leaderboard(),
                        canLoadMore: provider.canLoadMore,
                        onLoadMore: () async =>
                            await provider.leaderboard(loadMore: true),
                        child: ListView.separated(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            TradingRes? data = provider
                                .leaderboardRes?.leaderboardByDate?[index];
                            if (data == null) return SizedBox();
                            return TournamentLeaderboardItem(
                              data: data,
                              from: 2,
                            );
                          },
                          itemCount: provider
                                  .leaderboardRes?.leaderboardByDate?.length ??
                              0,
                          separatorBuilder: (context, index) {
                            return SpacerVertical(height: 15);
                          },
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
