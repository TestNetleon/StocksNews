import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/scanner/manager/scanner.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/allTrades/all_trade_index.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/leaderboard/index.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/tournaments_index.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/widgets/card.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';


class GameTournamentIndex extends StatefulWidget {
  final int? setIndex;
  const GameTournamentIndex({super.key, this.setIndex});

  @override
  State<GameTournamentIndex> createState() => _GameTournamentIndexState();
}

class _GameTournamentIndexState extends State<GameTournamentIndex> {
  int firstIndex = 0;
  int selectedTab = 0;

  onTabChange(index) {
    selectedTab = index;
    firstIndex=index;
    setState(() {});
  }
  List<MarketResData> tabs = [
    MarketResData(title: 'League', slug: 'league'),
    MarketResData(title: 'Leaderboard', slug: 'leaderboard'),
    MarketResData(title: 'My Trades', slug: 'myTrades'),
  ];
  @override
  void initState() {
    super.initState();
    onTabChange(widget.setIndex??0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScannerManager>().getScannerPorts(reset: false);
    });
  }


  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: provider.extra?.title ?? 'Trading League',
        //subTitle: provider.extra?.subTitle,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimen.padding - 2),
        child: Column(
          children: [
            if (firstIndex == 0)
              Visibility(
                visible: provider.data?.loginUserPosition != null,
                child: TournamentThemeCard(
                  onTap: () async {
                    context.read<TournamentProvider>().profileRedirection(
                        userId:
                            "${provider.data?.loginUserPosition?.userId ?? ""}");
                  },
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    horizontalTitleGap: 8,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: ThemeColors.greyBorder)),
                        child: provider.data?.loginUserPosition?.imageType ==
                                "svg"
                            ? SvgPicture.network(
                                fit: BoxFit.cover,
                                provider.data?.loginUserPosition?.userImage ??
                                    "",
                                placeholderBuilder: (BuildContext context) =>
                                    Container(
                                  padding: const EdgeInsets.all(30.0),
                                  child:  CircularProgressIndicator(
                                    color: ThemeColors.white,
                                  ),
                                ),
                              )
                            : CachedNetworkImagesWidget(
                                provider.data?.loginUserPosition?.userImage),
                      ),
                    ),
                    title: Text(
                      "Welcome, ${provider.data?.loginUserPosition?.userName ?? ""} !",
                      style: styleBaseBold(fontSize: 14,color: ThemeColors.black),
                    ),
                    subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(provider.data?.loginUserPosition?.rank ?? "",
                                  style: styleBaseBold(
                                      fontSize: 12, color: ThemeColors.black)),
                              SpacerVertical(height: 3),
                              Text(
                                "Rank",
                                style: styleBaseRegular(
                                  fontSize: 12,
                                  color: ThemeColors.black,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                  "${provider.data?.loginUserPosition?.performance?.toCurrency() ?? "0"}%",
                                  style: styleBaseBold(
                                      fontSize: 12,
                                      color: (provider.data?.loginUserPosition
                                                      ?.performance ??
                                                  0) >
                                              0
                                          ? ThemeColors.success120
                                          : provider.data?.loginUserPosition
                                                      ?.performance ==
                                                  0
                                              ? ThemeColors.black
                                              : ThemeColors.error120)),
                              SpacerVertical(height: 3),
                              Text(
                                "Performance",
                                style: styleBaseRegular(
                                  fontSize: 12,
                                  color: ThemeColors.black,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                  "${((provider.data?.loginUserPosition?.totalPoints ?? 0) + (provider.data?.loginUserPosition?.performancePoint ?? 0))}",
                                  style: styleBaseBold(
                                      fontSize: 12, color: ThemeColors.black)),
                              SpacerVertical(height: 3),
                              Text(
                                "Total Points",
                                style: styleBaseRegular(
                                  fontSize: 12,
                                  color: ThemeColors.black,
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),

            BaseTabs(
              data:tabs,
              isScrollable: true,
              onTap: onTabChange,
              selectedIndex:selectedTab,
            ),

            SpacerVertical(height: Pad.pad10),
            if (selectedTab == 0) Expanded(child: TournamentsIndex()),
            if (selectedTab == 1) Expanded(child: TournamentLeaderboard()),
            if (selectedTab == 2)  Expanded(child: TournamentAllTradeIndex())


          ],
        ),
      ),
    );
  }
}
