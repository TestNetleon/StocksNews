import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/utils/theme.dart';

import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/spacer_horizontal.dart';
import '../../../models/leaderboard.dart';

class PointsPaidItem extends StatelessWidget {
  final LeaderboardByDateRes? data;
  const PointsPaidItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: ThemeColors.background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: data?.tournamentName != null,
            child: InkWell(
              onTap: () {
                context
                    .read<TournamentProvider>()
                    .leagueToLeaderboard(selectedDate: data?.date ?? "");
              },
              child: Text(
                data?.tournamentName ?? '',
                style: styleGeorgiaBold(),
              ),
            ),
          ),
          Visibility(
              visible: data?.tournamentName != null,
              child: const SpacerVertical(height: 3)),
          InkWell(
            onTap: () {
              context
                  .read<TournamentProvider>()
                  .profileRedirection(userId:"${ data?.userId ?? ""}");
            },
            child: Row(
              children: [
                Visibility(
                  visible: data?.position != null,
                  child: Container(
                    margin: EdgeInsets.only(right: 5),
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ThemeColors.greyBorder,
                    ),
                    child: Text(
                      '${data?.position}',
                      style: styleGeorgiaBold(fontSize: 11),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    width: 40.sp,
                    height: 40.sp,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ThemeColors.greyBorder)),
                    child: data?.imageType == "svg"
                        ? SvgPicture.network(
                            fit: BoxFit.cover,
                            data?.userImage ?? "",
                            placeholderBuilder: (BuildContext context) =>
                                Container(
                              padding: const EdgeInsets.all(30.0),
                              child: const CircularProgressIndicator(
                                color: ThemeColors.accent,
                              ),
                            ),
                          )
                        : CachedNetworkImagesWidget(
                            data?.userImage,
                          ),
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: data?.userName != null,
                        child: Text(
                          data?.userName ?? "",
                          style: stylePTSansRegular(fontSize: 14),
                        ),
                      ),

                      Visibility(
                        visible: data?.date != null,
                        child:Text(
                          data?.date ?? "",
                          style: stylePTSansRegular(
                              fontSize: 12, color: ThemeColors.greyText),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: data?.totalPoints != null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SpacerVertical(height:5),
                      Text(
                        '${data?.totalPoints}',
                        style: styleGeorgiaBold(),
                      ),
                      Text(
                        'Reward Points',
                        style: stylePTSansBold(
                            fontSize: 14,
                            color:ThemeColors.greyText
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: ThemeColors.greyBorder,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: data?.performance!=null,
                child: Flexible(
                    child: _richPrices1(label: "Performance: ",value: "${data?.performance??"0"}%")
                ),
              ),
              Visibility(
                visible: data?.performancePoint != null,
                child: Flexible(
                  child:
                  _richPrices1(label: "Pref. Points: ",value: "${data?.performancePoint}"),
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }

  Widget _richPrices1 ({String? label,String? value}) {
    if(value==null||value.isEmpty) return SizedBox();
    return RichText(
        text: TextSpan(
            text: label,
            style: stylePTSansBold(
              fontSize: 14,
              color:ThemeColors.greyText,
            ),
            children: [
              TextSpan(
                  text: value,
                  style: label=="Pref. Points: "?stylePTSansRegular(fontSize: 14, color: ThemeColors.white):
                  stylePTSansBold(fontSize: 14, color: (data?.performance ?? 0) > 0 ? ThemeColors.themeGreen:data?.performance==0?ThemeColors.white:ThemeColors.darkRed)
              )
            ]
        )
    );
  }
}
