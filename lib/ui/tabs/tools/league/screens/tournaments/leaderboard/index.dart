import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/leaderboard.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/leaderboard.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/trading_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/leaderboard/item.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/leaderboard/top_no_item.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/leaderboard/top_widget.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/widgets/dates.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/widgets/top_tading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';

class LeagueLeaderboard extends StatefulWidget {
  const LeagueLeaderboard({super.key});

  @override
  State<LeagueLeaderboard> createState() => _LeagueLeaderboardState();
}

class _LeagueLeaderboardState extends State<LeagueLeaderboard> {
  String? selectedDate;

  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    context.read<LeaderboardManager>().clearEditedDate();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    LeaderboardManager manager = context.watch<LeaderboardManager>();
    LeagueLeaderboardRes? leaderboardRes=manager.leaderboardRes;
    return BaseLoaderContainer(
      hasData: manager.battleRes != null,
      isLoading: manager.isLoadingBattle,
      error: manager.errorBattle,
      showPreparingText: true,
      child: Column(
        children: [
          SpacerVertical(height: Pad.pad10),
          CustomDateSelector(
            editedDate: manager.editedDate,
            gameValue: manager.battleRes?.battle,
            onDateSelected: (date) {
              manager.getSelectedDate(date);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                manager.leaderboard();
              });
            },
          ),
          SpacerVertical(height: Pad.pad10),
          Expanded(
            child: BaseLoaderContainer(
                hasData: leaderboardRes != null,
                isLoading: manager.isLoadingLeaderboard,
                error: manager.errorLeaderboard,
                showPreparingText: true,
                child: Column(
                  children: [
                    if (leaderboardRes?.showLeaderboard == true)
                      manager.topPerformers.isNotEmpty
                          ?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Pad.pad16),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (manager.topPerformers.length >= 2 &&
                                    (manager.topPerformers[1]?.performance ??
                                        0) >
                                        0)
                                LeaderboardTopItem(
                                  index: 1,
                                  constraints: constraints,
                                )
                                else
                                  TopNoItem(
                                    index: 1,
                                    showAll: false,
                                    constraints: constraints,
                                  ),
                                const SpacerHorizontal(width: 12),
                                LeaderboardTopItem(
                                  index: 0,
                                  constraints: constraints,
                                ),
                                const SpacerHorizontal(width: 12),
                                if (manager.topPerformers.length >= 3 &&
                                    (manager.topPerformers[2]?.performance ??
                                        0) >
                                        0)
                                LeaderboardTopItem(
                                  index: 2,
                                  constraints: constraints,
                                )
                                else
                                  TopNoItem(
                                    index: 2,
                                    showAll: false,
                                    constraints: constraints,
                                  ),
                              ],
                            );
                          },
                        ),
                      )

                          : Visibility(
                              visible: (manager.leaderboardRes?.showLeaderboard == true),
                              child:
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Pad.pad16),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TopNoItem(
                                          index: 1,
                                          constraints: constraints,
                                        ),
                                        const SpacerHorizontal(width: 12),
                                        TopNoItem(
                                          index: 0,
                                          constraints: constraints,
                                        ),
                                        const SpacerHorizontal(width: 12),
                                        TopNoItem(
                                          index: 2,
                                          constraints: constraints,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                      ),

                    SpacerVertical(),
                    Visibility(
                      visible: leaderboardRes?.loginUserPosition != null,
                      child: CommonCard(
                        padding: EdgeInsets.symmetric(horizontal:Pad.pad5,vertical: Pad.pad10),
                        margin: EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad10),
                        child: ListTile(
                          onTap: () async {
                            context.read<LeagueManager>().profileRedirection(
                                userId:
                                "${leaderboardRes?.loginUserPosition?.userId ?? ""}");
                          },
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          leading:
                          Container(
                            padding: const EdgeInsets.all(Pad.pad2),
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: ThemeColors.secondary100)),
                            child:leaderboardRes?.loginUserPosition?.imageType ==
                                "svg"
                                ? ClipRRect(
                              borderRadius:
                              BorderRadius.circular(45),
                              child: SvgPicture.network(
                                fit: BoxFit.cover,
                                leaderboardRes?.loginUserPosition?.userImage ??
                                    "",
                                placeholderBuilder:
                                    (BuildContext context) =>
                                    Container(
                                      padding:
                                      const EdgeInsets.all(30.0),
                                      child:
                                      const CircularProgressIndicator(
                                        color: ThemeColors.accent,
                                      ),
                                    ),
                              ),
                            )
                                : ClipRRect(
                              borderRadius:
                              BorderRadius.circular(45),
                              child: CachedNetworkImagesWidget(
                                  leaderboardRes?.loginUserPosition?.userImage),
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'My Position',
                                style: styleBaseBold(fontSize: 20),
                              ),
                              SpacerHorizontal(width: Pad.pad10),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: Pad.pad16,vertical: Pad.pad5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Pad.pad16),
                                  color: ThemeColors.secondary120
                                ),
                                child: Text(
                                    "${leaderboardRes?.loginUserPosition?.position ?? 0}",
                                    style: styleBaseBold(
                                        color: Colors.white
                                    )
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: ThemeColors.neutral40,
                            size: 20,
                          ),
                        ),
                      ),
                    ),

                    Visibility(visible:leaderboardRes?.title!=null,child: const SpacerVertical(height: Pad.pad10)),
                    Visibility(
                      visible:leaderboardRes?.title!=null,
                      child: BaseHeading(
                        title: leaderboardRes?.title,
                        viewMoreText: "View More",
                        viewMore: () {
                          var selectedTournament = TournamentsHead.topTitan;
                          Navigator.pushNamed(context, AllTopTtIndex.path,
                              arguments: {
                                "selectedTournament": selectedTournament,
                                "title": leaderboardRes?.title,
                              });
                        },
                        margin: const EdgeInsets.symmetric(horizontal: Pad.pad16),
                      ),
                    ),
                    Visibility(visible:leaderboardRes?.title!=null,child: const SpacerVertical(height: Pad.pad10)),
                    Expanded(
                      child: BaseLoadMore(
                        onRefresh: () async => await manager.leaderboard(),
                        canLoadMore: manager.canLoadMore,
                        onLoadMore: () async =>
                            await manager.leaderboard(loadMore: true),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            TradingRes? data = manager
                                .leaderboardRes?.leaderboardByDate?[index];
                            if (data == null) return SizedBox();
                            return LeaderboardItem(
                              data: data,
                              from: 2,
                            );
                          },
                          itemCount: manager
                                  .leaderboardRes?.leaderboardByDate?.length ??
                              0,
                          separatorBuilder: (context, index) {
                            return BaseListDivider(height: Pad.pad20);
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
