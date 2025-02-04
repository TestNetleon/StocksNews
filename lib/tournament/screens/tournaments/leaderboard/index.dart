import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/leaderboard.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/leaderboard/item.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/leaderboard/top_no_item.dart';
import 'package:stocks_news_new/tournament/widgets/card.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';
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
                                    child:
                                        TournamentLeaderboardTopItem(index: 1),
                                  )
                                else
                                  Positioned(
                                    left: 0,
                                    top: 70,
                                    child: TopNoItem(index: 1),
                                  ),
                                if (provider.topPerformers.length >= 3 &&
                                    (provider.topPerformers[2]?.performance ??
                                            0) >
                                        0)
                                  const Positioned(
                                    right: 0,
                                    top: 70,
                                    child:
                                        TournamentLeaderboardTopItem(index: 2),
                                  )
                                else
                                  Positioned(
                                    right: 0,
                                    top: 70,
                                    child: TopNoItem(index: 2),
                                  ),
                                const Align(
                                  alignment: Alignment.topCenter,
                                  child: TournamentLeaderboardTopItem(index: 0),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),

                  Visibility(
                    visible: provider.leaderboardRes?.loginUserPosition!=null,
                    child: TournamentThemeCard(
                      onTap: () async {
                        context.read<TournamentProvider>().profileRedirection(userId:"${provider.leaderboardRes?.loginUserPosition?.userId ?? ""}");
                      },
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.only(top: 16,bottom: 8),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal:10),
                        minTileHeight:60,
                        leading:
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            width: 43,
                            height: 43,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: ThemeColors.greyBorder)),
                            child:provider.leaderboardRes?.loginUserPosition?.imageType == "svg"
                                ? SvgPicture.network(
                              fit: BoxFit.cover,
                              provider.leaderboardRes?.loginUserPosition?.userImage ?? "",
                              placeholderBuilder: (BuildContext context) =>
                                  Container(
                                    padding: const EdgeInsets.all(30.0),
                                    child: const CircularProgressIndicator(
                                      color: ThemeColors.accent,
                                    ),
                                  ),
                            )
                                : CachedNetworkImagesWidget(provider.leaderboardRes?.loginUserPosition?.userImage),
                          ),
                        ),
                        /*Container(
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
                        ),*/
                        title: Row(
                          children: [
                            Text(
                              'MY POSITION',
                              style: styleGeorgiaRegular(fontSize: 14),
                            ),
                            SpacerHorizontal(width: 10),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: ThemeColors.gold,
                              child: Text(
                                  "${provider.leaderboardRes?.loginUserPosition?.position??0}",
                                  style: styleGeorgiaRegular(color: ThemeColors.primary)

                              ),
                            ),

                          ],
                        ),
                        /*subtitle: RichText(
                            text: TextSpan(
                                text: "Performance: ",
                                style: stylePTSansRegular(
                                  fontSize: 12,
                                  color:ThemeColors.greyText,
                                ),
                                children: [
                                  TextSpan(
                                      text: "${provider.leaderboardRes?.loginUserPosition?.performance?.toCurrency()??"0"}%",
                                      style: stylePTSansRegular(fontSize: 12, color: (provider.leaderboardRes?.loginUserPosition?.performance ?? 0) > 0 ? ThemeColors.themeGreen:provider.leaderboardRes?.loginUserPosition?.performance==0?ThemeColors.white:ThemeColors.darkRed)
                                  )
                                ]
                            )
                        ),*/
                        trailing: Icon(
                          Icons.arrow_forward_ios_sharp,
                          color: ThemeColors.greyBorder,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshControl(
                      onRefresh: () async => await provider.leaderboard(),
                      canLoadMore: provider.canLoadMore,
                      onLoadMore: () async =>
                          await provider.leaderboard(loadMore: true),
                      child: ListView.separated(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          LeaderboardByDateRes? data = provider
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

        /*Expanded(
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
                  LeaderboardByDateRes? data = provider.leaderboardRes?.leaderboardByDate?[index];
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
        ),*/
      ],
    );
  }

}
