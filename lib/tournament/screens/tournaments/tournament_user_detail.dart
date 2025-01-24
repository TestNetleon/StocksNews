import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/drawer/widgets/profile_image.dart';
import 'package:stocks_news_new/screens/tabs/home/widgets/app_bar_home.dart';
import 'package:stocks_news_new/tournament/models/leaderboard.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/pointsPaid/league_total_item.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/widgets/grid_boxs.dart';
import 'package:stocks_news_new/tournament/screens/tournaments/widgets/info_box.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/base_container.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

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
  void _getData() async {
    TournamentProvider provider = context.read<TournamentProvider>();
    await provider.getUserDetail();
  }
  @override
  Widget build(BuildContext context) {
    TournamentProvider provider = context.watch<TournamentProvider>();
    return BaseContainer(
        appBar: AppBarHome(
          isPopBack: true,
          canSearch: false,
          showTrailing: false,
          title:provider.userData?.title ?? "",
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(Dimen.padding, 0, Dimen.padding, 0),
            child: Column(
              children: [
                ProfileImage(
                  imageSize: 95,
                  cameraSize: 19,
                  url: "https://api.dicebear.com/9.x/thumbs/svg?size=500&seed=Felix&flip=false&backgroundColor=ffdfbf&eyes=variant2W16&mouth=variant5&shapeColor=0a5b83",
                  showCameraIcon: false,

                ),
                const SpacerVertical(height: 13),
                Text(
                 widget.userId ?? "",
                  textAlign: TextAlign.center,
                  style: stylePTSansBold(
                    fontSize: 24,
                  ),
                ),
                const SpacerVertical(height:5),
                Text(
                  "Discover a complete overview of your performance, featuring details of the leagues you've joined, your victories, setbacks, rewards earned, and your overall growth.",
                  textAlign: TextAlign.center,
                  style: stylePTSansRegular(
                    fontSize:12,
                    color: ThemeColors.greyText
                  ),
                ),
                const SpacerVertical(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                  child: Row(
                    children: [
                      InfoBox(label: 'Rank', value: 'Novice Trader'),
                      InfoBox(label: 'Exp.', value: '0.1Y'),
                    ]
                  ),
                ),
                const SpacerVertical(height: 14),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:4,
                    mainAxisSpacing:5.0,
                    crossAxisSpacing:5.0
                  ),
                  itemCount: 4,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GridBoxs();
                  },
                ),

                const SpacerVertical(height: 13),
                ScreenTitle(
                  title: "Recent Activities",
                  subTitle: "Day Trading League (01/24/2025)",
                  style: styleGeorgiaBold(fontSize: 16),
                  dividerPadding: EdgeInsets.zero,
                ),
                const SpacerVertical(height: 13),

                const SpacerVertical(height: 13),
                ScreenTitle(
                  title: "Trading Leagues",
                  subTitle: "The detailed history of your participation in trading leagues.",
                  style: styleGeorgiaBold(fontSize: 16),
                  dividerPadding: EdgeInsets.zero,
                ),
                const SpacerVertical(height: 13),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
                )
              ],
            ),
          ),
        )
    );
  }
}
