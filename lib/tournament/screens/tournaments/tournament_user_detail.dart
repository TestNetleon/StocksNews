import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/tournament/models/tour_user_detail.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/widgets/grid_boxs.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/widgets/growth_chart.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/widgets/info_box.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/widgets/ticker_item.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/widgets/tl_item.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/widgets/trading_line_chart.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/loading.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';

class TournamentUserDetail extends StatefulWidget {
  final String? userId;
  const TournamentUserDetail({super.key, this.userId});

  @override
  State<TournamentUserDetail> createState() => _TournamentUserDetailState();
}

class _TournamentUserDetailState extends State<TournamentUserDetail> {
  late DateTime currentDate;
 /* List<GChart> gchart=[
    GChart(
      performance:800,
      battleDate: "2024-12-23",
      formatPerformance: "800%"
    ),
    GChart(
        performance: -400,
        battleDate: "2024-12-22",
        formatPerformance: "-400%"
    ),
    GChart(
        performance:-100,
        battleDate: "2024-12-21",
        formatPerformance: "100%"
    )
    ,
    GChart(
        performance:0,
        battleDate: "2024-12-21",
        formatPerformance: "0%"
    )
    ,
    GChart(
        performance:10,
        battleDate: "2024-12-21",
        formatPerformance: "10%"
    )
    ,
    GChart(
        performance:-10,
        battleDate: "2024-12-21",
        formatPerformance: "10%"
    )
    ,
    GChart(
        performance:40,
        battleDate: "2024-12-21",
        formatPerformance: "40%"
    )
  ];*/
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentDate = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      _getData();
    });

  }

  void _getData() async {
    TournamentProvider provider = context.read<TournamentProvider>();
    await provider.getUserDetail(userID: widget.userId);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();
    return BaseContainer(
        appBar: AppBarHome(
          isPopBack: true,
          canSearch: false,
          showTrailing: false,
          title: provider.extraOfUserData?.title ?? "",
        ),
        body: BaseUiContainer(
            hasData: provider.userData != null,
            isLoading: provider.isLoadingUserData,
            error: provider.errorUserData,
            showPreparingText: true,
            onRefresh: () {
              _getData();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: ThemeColors.white, width: 3),
                          shape: BoxShape.circle),
                      child: ClipOval(
                        child: provider.userData?.userStats?.imageType == "svg"
                            ? SvgPicture.network(
                                height: 95,
                                width: 95,
                                provider.userData?.userStats?.image ?? "",
                                placeholderBuilder: (BuildContext context) =>
                                    Container(
                                  padding: const EdgeInsets.all(30.0),
                                  child: const CircularProgressIndicator(),
                                ),
                              )
                            : CachedNetworkImagesWidget(
                                provider.userData?.userStats?.image ?? "",
                                height: 95,
                                width: 95,
                                showLoading: true,
                                placeHolder: Images.userPlaceholder,
                              ),
                      ),
                    ),
                    const SpacerVertical(height: 13),
                    Visibility(
                      visible: provider.userData?.userStats?.name != null,
                      child: Text(
                        provider.userData?.userStats?.name ?? "",
                        textAlign: TextAlign.center,
                        style: stylePTSansBold(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SpacerVertical(height:3),
                    Visibility(
                      visible: provider.userData?.userStats?.rank!=null,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal:10,vertical:5),
                        decoration: BoxDecoration(
                          border: Border.all(color: ThemeColors.greyText,width:0.5),
                          color: ThemeColors.primary,
                          borderRadius: BorderRadius.circular(14.0)
                        ),
                        child: Text(
                          provider.userData?.userStats?.rank ?? "",
                          textAlign: TextAlign.center,
                          style: stylePTSansBold(
                              fontSize: 14, color: ThemeColors.white),
                        ),
                      ),
                    ),
                    /*const SpacerVertical(height: 5),
                    Text(
                      provider.extraOfUserData?.subTitle ?? "",
                      textAlign: TextAlign.center,
                      style: stylePTSansRegular(
                          fontSize: 12, color: ThemeColors.greyText),
                    ),*/
                    const SpacerVertical(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          transform: GradientRotation(0.9),
                          colors: [
                            ThemeColors.bottomsheetGradient,
                            ThemeColors.accent,
                          ],
                        ),
                      ),
                      child: Row(children: [
                        InfoBox(
                            label: 'Performance',
                            value: "${provider.userData?.userStats?.performance ?? ""}%"),
                       /* InfoBox(
                            label: 'Rank',
                            value: provider.userData?.userStats?.rank ?? ""),*/
                        InfoBox(
                            label: 'Exp.',
                            value: provider.userData?.userStats?.exp ?? ""),
                      ]),
                    ),
                    const SpacerVertical(height:14),
                    ScreenTitle(
                      title:"Cumulative Stats",
                      style: styleGeorgiaBold(fontSize: 16),
                      dividerPadding: EdgeInsets.zero,
                    ),
                    const SpacerVertical(height: 12),
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 5.0,
                          crossAxisSpacing: 5.0),
                      itemCount:
                          provider.userData?.userStats?.info?.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Info? info = provider.userData?.userStats?.info?[index];
                        return GridBoxs(info: info);
                      },
                    ),
                    const SpacerVertical(height: 13),
                    Visibility(
                      visible:(provider.userData?.recentTrades?.status!=false),
                      child: ScreenTitle(
                        title: provider.userData?.recentTrades?.title??"",
                        subTitle: provider.userData?.recentTrades?.status==true?provider.userData?.recentTrades?.subTitle??"":provider.userData?.recentTrades?.message??"",
                        style: styleGeorgiaBold(fontSize: 16),
                        dividerPadding: EdgeInsets.zero,
                      ),
                    ),
                    Visibility(
                        visible:(provider.userData?.recentTrades?.status!=false),
                        child: const SpacerVertical(height: 13)
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        RecentTradeRes? data = provider.userData?.recentTrades?.dataTrade?[index];
                        if (data == null) {
                          return SizedBox();
                        }
                        return TickerItem(
                          data: data,
                        );
                      },
                      itemCount: provider.userData?.recentTrades?.dataTrade?.length ?? 0,
                      separatorBuilder: (context, index) {
                        return SpacerVertical(height: 10);
                      },
                    ),
                    const SpacerVertical(height: 10),
                    Visibility(
                      visible:(provider.userData?.chart?.title!=null),
                      child: ScreenTitle(
                        title: provider.userData?.chart?.title??"",
                        subTitle:  provider.userData?.chart?.subTitle??"",
                        style: styleGeorgiaBold(fontSize: 16),
                        dividerPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SpacerVertical(height: 13),

                    Visibility(
                      visible: provider.userData?.chart != null,
                      child: TradingLineChart(gChart: provider.userData?.chart?.gChart?.toList()),
                    ),
                    const SpacerVertical(height: 13),

                    Visibility(
                      visible:(provider.userData?.recentBattles?.status!=false),
                      child: ScreenTitle(
                        title: provider.userData?.recentBattles?.title??"",
                        subTitle: provider.userData?.recentBattles?.status==true?provider.userData?.recentBattles?.subTitle??"":provider.userData?.recentBattles?.message??"",
                        style: styleGeorgiaBold(fontSize: 16),
                        dividerPadding: EdgeInsets.zero,
                      ),
                    ),
                    Visibility(
                        visible:provider.userData?.recentBattles?.status!=false,
                        child: const SpacerVertical(height: 13)
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        RecentBattlesRes? data = provider.userData?.recentBattles?.data?[index];
                        if (data == null) {
                          return SizedBox();
                        }
                        return TlItem(
                          data: data,
                        );
                      },
                      itemCount: provider.userData?.recentBattles?.data?.length ?? 0,
                      separatorBuilder: (context, index) {
                        return SpacerVertical(height: 14);
                      },
                    )
                  ],
                ),
              ),
            )));
  }
}
