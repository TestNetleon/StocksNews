import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/services/sse.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/tour_user_detail.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/widgets/grid_boxs.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/widgets/growth_chart.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/widgets/info_box.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/widgets/ticker_item.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/screens/tournaments/widgets/tl_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/card.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';


class TournamentUserDetail extends StatefulWidget {
  final String? userId;
  const TournamentUserDetail({super.key, this.userId});

  @override
  State<TournamentUserDetail> createState() => _TournamentUserDetailState();
}

class _TournamentUserDetailState extends State<TournamentUserDetail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future _getData() async {
    TournamentProvider provider = context.read<TournamentProvider>();
    await provider.getUserDetail(userID: widget.userId);
  }

  @override
  void dispose() {
    super.dispose();
    SSEManager.instance.disconnectScreen(SimulatorEnum.tournament);
  }


  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();
    return BaseScaffold(
        appBar: BaseAppBar(
          showBack: true,
          title: provider.isLoadingUserData
              ? ""
              : provider.extraOfUserData?.title ?? "",
          showSearch: true,
          showNotification: true,
        ),
        body: BaseLoaderContainer(
            hasData: provider.userData != null,
            isLoading: provider.isLoadingUserData,
            error: provider.errorUserData,
            showPreparingText: true,
            onRefresh: () {
              _getData();
            },
            child: BaseLoadMore(
              onRefresh: _getData,
              onLoadMore: () =>
                  provider.getUserDetail(loadMore: true, userID: widget.userId,clear: false),
              canLoadMore: provider.canLoadMoreProfile,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                  EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: provider.userData?.userStats?.imageType ==
                            "svg"
                            ? SvgPicture.network(
                          height: 100,
                          width: 100,
                          provider.userData?.userStats?.image ?? "",
                          placeholderBuilder: (BuildContext context) =>
                              Container(
                                padding: const EdgeInsets.all(30.0),
                                child: const CircularProgressIndicator(),
                              ),
                        )
                            : CachedNetworkImagesWidget(
                          provider.userData?.userStats?.image ?? "",
                          height:100,
                          width: 100,
                          showLoading: true,
                          placeHolder: Images.userPlaceholder,
                        ),
                      ),
                      const SpacerVertical(height: Pad.pad10),
                      Visibility(
                        visible: provider.userData?.userStats?.name != null,
                        child: Text(
                          provider.userData?.userStats?.name ?? "",
                          textAlign: TextAlign.center,
                          style: styleBaseBold(
                            fontSize: 28,
                          ),
                        ),
                      ),
                      const SpacerVertical(height: Pad.pad10),
                      Visibility(
                        visible: provider.userData?.userStats?.rank != null,
                        child: Text(
                          provider.userData?.userStats?.rank ?? "",
                          textAlign: TextAlign.center,
                          style: styleBaseRegular(
                              fontSize: 14, color: ThemeColors.neutral40),
                        ),
                      ),
                      const SpacerVertical(height:  Pad.pad10),
                      Row(
                          children: [
                            Expanded(
                              child: CommonCard(
                                child:InfoBox(
                                  label: 'Performance',
                                  value:
                                  "${provider.userData?.userStats?.performance ?? ""}%",
                                  values:
                                  provider.userData?.userStats?.performance ?? 0,
                                ),
                              ),
                            ),
                            SpacerHorizontal(width: Pad.pad10),
                            Expanded(
                              child: CommonCard(
                                child: InfoBox(
                                    label: 'Exp.',
                                    value: provider.userData?.userStats?.exp ?? "",
                                    values:
                                    provider.userData?.userStats?.performance ??
                                        0),
                              ),
                            ),

                          ]),
                      const SpacerVertical(height:  Pad.pad14),
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0),
                        itemCount:
                            provider.userData?.userStats?.info?.length ?? 0,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Info? info =
                              provider.userData?.userStats?.info?[index];
                          String valueString = info?.value ?? "";
                          bool isNegative = valueString.contains('-');
                          num valueWithOutSymbol = valueString.contains('%')
                              ? num.parse(valueString
                                  .replaceAll(RegExp(r'[%\-]'), '')
                                  .trim())
                              : 0;

                          return GridBoxs(
                              info: info,
                              isNegative: isNegative,
                              valueWithOutSymbol: valueWithOutSymbol);
                        },
                      ),
                      const SpacerVertical(height: 20),

                      Visibility(
                        visible:
                            (provider.userData?.recentTrades?.status != false),
                        child: BaseHeading(
                          title: provider.userData?.recentTrades?.title ?? "",
                          subtitle: provider.userData?.recentTrades?.status ==
                              true
                              ? provider.userData?.recentTrades?.subTitle ?? ""
                              : provider.userData?.recentTrades?.message ?? "",
                          titleStyle: styleBaseBold(fontSize: 24),
                          subtitleStyle: styleBaseRegular(fontSize: 16,color: ThemeColors.neutral80),
                          margin: EdgeInsets.zero,
                          viewMore: () {
                            provider.tradesRedirection(
                                "${provider.userData?.recentTrades?.tournamentBattleId ?? ""}");
                          },
                        ),
                      ),

                      Visibility(
                          visible: (provider.userData?.recentTrades?.status !=
                              false),
                          child: const SpacerVertical(height: 20)
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          RecentTradeRes? data = provider
                              .userData?.recentTrades?.dataTrade?[index];
                          if (data == null) {
                            return SizedBox();
                          }
                          return TickerItem(data: data, fromTO: 1);
                        },
                        itemCount: provider
                                .userData?.recentTrades?.dataTrade?.length ??
                            0,
                        separatorBuilder: (context, index) {
                          return SpacerVertical(height: 10);
                        },
                      ),
                      const SpacerVertical(height: 15),
                      Visibility(
                        visible: (provider.userData?.chart?.title != null),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: BaseHeading(
                            title: provider.userData?.chart?.title ?? "",
                            subtitle: provider.userData?.chart?.subTitle ?? "",
                            titleStyle: styleBaseBold(fontSize: 24),
                            subtitleStyle: styleBaseRegular(fontSize: 16,color: ThemeColors.neutral80),

                            margin: EdgeInsets.zero,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      const SpacerVertical(),
                      Visibility(
                        visible: provider.userData?.chart != null,
                        child: GrowthChart(
                            chart: provider.userData?.chart?.gChart?.toList()),
                      ),
                      Visibility(
                        visible: (provider.userData?.recentBattles?.status != false),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            BaseHeading(
                              title: provider.userData?.recentBattles?.title ?? "",
                              subtitle: provider.userData?.recentBattles?.status ==
                                  true
                                  ? provider.userData?.recentBattles?.subTitle ?? ""
                                  : provider.userData?.recentBattles?.message ?? "",
                              titleStyle: styleBaseBold(fontSize: 24),
                              subtitleStyle: styleBaseRegular(fontSize: 16,color: ThemeColors.neutral80),

                              margin: EdgeInsets.zero,
                            ),
                            InkWell(
                              onTap: (){
                                provider.pickTradingDate(userID: widget.userId);
                              },
                              child:const Icon(
                                Icons.filter_alt,
                                color: ThemeColors.accent,
                              ),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                          visible:
                              provider.userData?.recentBattles?.status != false,
                          child: const SpacerVertical(height: 13)
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          RecentBattlesRes? data =
                              provider.userData?.recentBattles?.data?[index];
                          if (data == null) {
                            return SizedBox();
                          }
                          return TlItem(
                            data: data,
                          );
                        },
                        itemCount:
                            provider.userData?.recentBattles?.data?.length ?? 0,
                        separatorBuilder: (context, index) {
                          return BaseListDivider(height:20);
                        },
                      ),
                      const SpacerVertical(height: 10)
                    ],
                  ),
                ),
              ),
            )));
  }
}
