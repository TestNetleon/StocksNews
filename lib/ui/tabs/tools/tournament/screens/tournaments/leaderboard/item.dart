import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/leaderboard.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';


class TournamentLeaderboardItem extends StatelessWidget {
  final LeaderboardByDateRes data;
  final bool decorate;
  final int? from;
  const TournamentLeaderboardItem(
      {super.key, required this.data, this.decorate = true, this.from});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(builder: (context, value, child) {
      bool isDark = value.isDarkMode;
      return InkWell(
      onTap: () {
        context.read<TournamentProvider>().profileRedirection(userId: "${data.userId ?? ""}");
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                color: isDark ? null : ThemeColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular((from == 1||from == 3)?5:0),
                  bottomRight: Radius.circular((from == 1||from == 3)?5:0),
                ),
             /* gradient: isDark ?
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                transform: GradientRotation(0.9),
                colors: [
                  ThemeColors.bottomsheetGradient,
                  ThemeColors.accent,
                ],
              ):null,*/
              boxShadow: [
                BoxShadow(
                  color: ThemeColors.boxShadow,
                  blurRadius: 60,
                  offset: Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeColors.black,
                            ),
                            child: Text(
                              '${data.position}',
                              style: styleBaseBold(fontSize: 11,color: ThemeColors.white),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 43,
                              height: 43,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: ThemeColors.greyBorder)),
                              child: data.imageType == "svg"
                                  ? SvgPicture.network(
                                      fit: BoxFit.cover,
                                      data.userImage ?? "",
                                      placeholderBuilder: (BuildContext context) =>
                                          Container(
                                        padding: const EdgeInsets.all(30.0),
                                        child: const CircularProgressIndicator(
                                          color: ThemeColors.accent,
                                        ),
                                      ),
                                    )
                                  : CachedNetworkImagesWidget(
                                      data.userImage,
                                    ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.userName?.capitalizeWords() ?? 'N/A',
                                          style: styleBaseBold(),
                                        ),
                                        Visibility(
                                          visible:from == 3?false:true,
                                          child: Text(
                                            data.rank ?? 'N/A',
                                            style: styleBaseRegular(
                                                fontSize: 14),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  Container()
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: from == 2 ?true:false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SpacerVertical(height:5),
                              Text(
                                '${data.totalPoints}',
                                style: styleBaseBold(),
                              ),
                              Text(
                                'Reward Points',
                                style: styleBaseBold(
                                  fontSize: 14,
                                  color:ThemeColors.greyText
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: from == 3 ?true:false,
                          child: Text(
                            '${data.performance?.toCurrency()}%',
                            style: styleBaseBold(
                              fontSize: 14,
                              color: (data.performance ?? 0) > 0
                                  ? ThemeColors.success120
                                  : data.performance==0?
                              ThemeColors.white:
                              ThemeColors.error120,
                            ),
                          ),
                        ),
                      ],
                    )

                  ],
                ),
                Visibility(
                  visible:from == 3? false:true,
                  child: BaseListDivider(
                    color: ThemeColors.neutral40,
                    height: 20,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible:from == 3? false:true,
                      child: Flexible(
                          child: _richPrices1(label: "Performance: ",value: "${data.performance??"0"}%")
                      ),
                    ),
                    Visibility(
                      visible:(from == 3||from == 2)? false:true,
                      child: Flexible(
                        child:
                        _richPrices1(label: "Points Earned: ",value: "${((data.totalPoints??0)+(data.performancePoint??0))}"),
                      ),
                    ),
                    if(from == 2)
                      Flexible(
                        child:
                        Visibility(child: _richPrices(label: "Perf. Points: ",value: "${data.performancePoint}")),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible:(from == 1||from == 3)?false:true,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: ThemeColors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
              )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: _richPrices(label: "Trades: ",value: "${data.totalTrades}")
                  ),
                  const SpacerHorizontal(width: 10),
                  Flexible(
                    child:
                    _richPrices(label: "Win Ratio: ",value: "${data.winRatio}%"),
                  ),

                ],
              ),
            ),
          )

        ],
      ),
    );});
  }

  Widget _richPrices ({String? label,String? value}) {
    if(value==null||value.isEmpty) return SizedBox();
    return RichText(
        text: TextSpan(
            text: label,
            style: styleBaseBold(
              fontSize: 14,
              color:ThemeColors.greyText,
            ),
            children: [
              TextSpan(
                text: value,
                style: styleBaseRegular(
                    fontSize: 14,
                    color: ThemeColors.black
                ),
              )
            ]
        )
    );
  }

  Widget _richPrices1 ({String? label,String? value}) {
    if(value==null||value.isEmpty) return SizedBox();
    return RichText(
        text: TextSpan(
            text: label,
            style: styleBaseBold(
              fontSize: 14,
            ),
            children: [
              TextSpan(
                  text: value,
                  style: label=="Points Earned: "?styleBaseRegular(fontSize: 14, color: ThemeColors.black):
                  styleBaseBold(fontSize: 14, color: (data.performance ?? 0) > 0 ? ThemeColors.success120:data.performance==0?ThemeColors.black:ThemeColors.error120)
              )
            ]
        )
    );
  }
}
