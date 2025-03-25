import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/tour_user_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/widgets/grid_boxs.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/widgets/growth_chart.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/widgets/info_box.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/widgets/ticker_item.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/widgets/tl_item.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';


class LeagueUserDetail extends StatefulWidget {
  final String? userId;
  static const path = 'LeagueUserDetail';
  const LeagueUserDetail({super.key, this.userId});

  @override
  State<LeagueUserDetail> createState() => _LeagueUserDetailState();
}

class _LeagueUserDetailState extends State<LeagueUserDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future _getData() async {
    LeagueManager manager = context.read<LeagueManager>();
    await manager.getUserDetail(userID: widget.userId);
  }

  @override
  void dispose() {
    super.dispose();
    SSEManager.instance.disconnectScreen(SimulatorEnum.tournament);
  }


  @override
  Widget build(BuildContext context) {
    LeagueManager manager = context.watch<LeagueManager>();
    LeagueUserDetailRes? leagueUserDetailRes= manager.userData;

    return BaseScaffold(
        appBar: BaseAppBar(
          showBack: true,
          title: manager.isLoadingUserData
              ? ""
              : leagueUserDetailRes?.title ?? "",
          showNotification: true,
        ),
        body: BaseLoaderContainer(
            hasData: manager.userData != null,
            isLoading: manager.isLoadingUserData,
            error: manager.errorUserData,
            showPreparingText: true,
            onRefresh: () {
              _getData();
            },
            child: BaseLoadMore(
              onRefresh: _getData,
              onLoadMore: () =>
                  manager.getUserDetail(loadMore: true, userID: widget.userId,clear: false),
              canLoadMore: manager.canLoadMoreProfile,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SpacerVertical(height: Pad.pad10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: leagueUserDetailRes?.userStats?.imageType ==
                          "svg"
                          ? SvgPicture.network(
                        height: 100,
                        width: 100,
                        leagueUserDetailRes?.userStats?.image ?? "",
                        placeholderBuilder: (BuildContext context) =>
                            Container(
                              padding: const EdgeInsets.all(30.0),
                              child: const CircularProgressIndicator(),
                            ),
                      )
                          : CachedNetworkImagesWidget(
                        leagueUserDetailRes?.userStats?.image ?? "",
                        height:100,
                        width: 100,
                        showLoading: true,
                        placeHolder: Images.userPlaceholder,
                      ),
                    ),
                    const SpacerVertical(height: Pad.pad14),
                    Visibility(
                      visible: leagueUserDetailRes?.userStats?.name != null,
                      child: Text(
                        leagueUserDetailRes?.userStats?.name ?? "",
                        textAlign: TextAlign.center,
                        style: styleBaseBold(
                          fontSize: 28,
                        ),
                      ),
                    ),
                    const SpacerVertical(height: Pad.pad5),
                    Visibility(
                      visible: leagueUserDetailRes?.userStats?.rank != null,
                      child: Text(
                        leagueUserDetailRes?.userStats?.rank ?? "",
                        textAlign: TextAlign.center,
                        style: styleBaseRegular(
                            fontSize: 14, color: ThemeColors.neutral40),
                      ),
                    ),
                    const SpacerVertical(height:  Pad.pad16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Pad.pad16),
                      child: Row(
                          children: [
                            Expanded(
                              child: CommonCard(
                                child:InfoBox(
                                  label: 'Performance',
                                  value:
                                  "${leagueUserDetailRes?.userStats?.performance ?? ""}%",
                                  values:
                                  leagueUserDetailRes?.userStats?.performance ?? 0,
                                ),
                              ),
                            ),
                            SpacerHorizontal(width: Pad.pad10),
                            Expanded(
                              child: CommonCard(
                                child: InfoBox(
                                    label: 'Exp.',
                                    value: leagueUserDetailRes?.userStats?.exp ?? "",
                                    values:
                                    leagueUserDetailRes?.userStats?.performance ??
                                        0),
                              ),
                            ),

                          ]),
                    ),
                    const SpacerVertical(height:  Pad.pad10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Pad.pad16),

                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0),
                        itemCount:
                            leagueUserDetailRes?.userStats?.info?.length ?? 0,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Info? info =
                              leagueUserDetailRes?.userStats?.info?[index];
                          String valueString = info?.value ?? "";
                          bool isNegative = valueString.contains('-');
                          num valueWithOutSymbol = valueString.contains('%')
                              ? num.parse(valueString
                                  .replaceAll(RegExp(r'[%\-]'), '')
                                  .trim())
                              : 0;

                          return GridBoxes(
                              info: info,
                              isNegative: isNegative,
                              valueWithOutSymbol: valueWithOutSymbol);
                        },
                      ),
                    ),
                    const SpacerVertical(height: Pad.pad24),
                    Visibility(
                      visible:
                          (leagueUserDetailRes?.recentTrades?.status != false),
                      child: BaseHeading(
                        title: leagueUserDetailRes?.recentTrades?.title ?? "",
                        subtitle: leagueUserDetailRes?.recentTrades?.status ==
                            true
                            ? leagueUserDetailRes?.recentTrades?.subTitle ?? ""
                            : leagueUserDetailRes?.recentTrades?.message ?? "",
                        titleStyle: styleBaseBold(fontSize: 24),
                        subtitleStyle: styleBaseRegular(fontSize: 16,color: ThemeColors.neutral80),
                        margin: const EdgeInsets.symmetric(horizontal: Pad.pad16),
                      viewMore: () {
                          manager.tradesRedirection(
                              "${leagueUserDetailRes?.recentTrades?.tournamentBattleId ?? ""}");
                        },
                      ),
                    ),
                    Visibility(
                        visible: (leagueUserDetailRes?.recentTrades?.status !=
                            false),
                        child: const SpacerVertical(height: Pad.pad20)
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        BaseTickerRes? data = manager.userData?.recentTrades?.dataTrade?[index];
                        if (data == null) {
                          return SizedBox();
                        }
                        return TickerItem(data: data, fromTO: 1);
                      },
                      itemCount: manager
                              .userData?.recentTrades?.dataTrade?.length ??
                          0,
                      separatorBuilder: (context, index) {
                        return BaseListDivider(height: Pad.pad24);
                      },
                    ),
                    const SpacerVertical(height: Pad.pad24),
                    Visibility(
                      visible: (leagueUserDetailRes?.chart?.title != null),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: BaseHeading(
                          title: leagueUserDetailRes?.chart?.title ?? "",
                          subtitle: leagueUserDetailRes?.chart?.subTitle ?? "",
                          titleStyle: styleBaseBold(fontSize: 24),
                          subtitleStyle: styleBaseRegular(fontSize: 16,color: ThemeColors.neutral80),
                          margin:  const EdgeInsets.symmetric(horizontal: Pad.pad16),
                        crossAxisAlignment: CrossAxisAlignment.start,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    const SpacerVertical(),
                    Visibility(
                      visible: leagueUserDetailRes?.chart != null,
                      child: GrowthChart(
                          chart: leagueUserDetailRes?.chart?.gChart?.toList()),
                    ),
                    Visibility(
                      visible: (leagueUserDetailRes?.recentBattles?.status != false),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          BaseHeading(
                            title: leagueUserDetailRes?.recentBattles?.title ?? "",
                            subtitle: leagueUserDetailRes?.recentBattles?.status ==
                                true
                                ? leagueUserDetailRes?.recentBattles?.subTitle ?? ""
                                : leagueUserDetailRes?.recentBattles?.message ?? "",
                            titleStyle: styleBaseBold(fontSize: 24),
                            subtitleStyle: styleBaseRegular(fontSize: 16,color: ThemeColors.neutral80),
                            margin:  const EdgeInsets.symmetric(horizontal: Pad.pad16),
                          ),
                          IconButton(
                            onPressed: (){
                              manager.pickTradingDate(userID: widget.userId);
                            },
                            icon:Image.asset(
                              Images.bottomTools,
                              color: ThemeColors.neutral60,
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                        visible:
                            leagueUserDetailRes?.recentBattles?.status != false,
                        child: const SpacerVertical(height: 13)
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        RecentBattlesRes? data =
                            leagueUserDetailRes?.recentBattles?.data?[index];
                        if (data == null) {
                          return SizedBox();
                        }
                        return TlItem(
                          data: data,
                        );
                      },
                      itemCount:
                          leagueUserDetailRes?.recentBattles?.data?.length ?? 0,
                      separatorBuilder: (context, index) {
                        return BaseListDivider(height:20);
                      },
                    ),
                    const SpacerVertical(height: 10)
                  ],
                ),
              ),
            )));
  }
}
