import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/managers/tournament.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/trading_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class PointsPaidItem extends StatelessWidget {
  final TradingRes? data;
  const PointsPaidItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: data?.tournamentName != null,
            child: InkWell(
              onTap: () {
                context
                    .read<LeagueManager>()
                    .leagueToLeaderboard(selectedDate: data?.date ?? "");
              },
              child: Text(
                data?.tournamentName ?? '',
                style: styleBaseRegular(),
              ),
            ),
          ),
          Visibility(
              visible: data?.tournamentName != null,
              child: const SpacerVertical(height: Pad.pad5)
          ),
          InkWell(
            onTap: () {
              context
                  .read<LeagueManager>()
                  .profileRedirection(userId:"${ data?.userId ?? ""}");
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    width: 40.sp,
                    height: 40.sp,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ThemeColors.secondary100)),
                    child: CachedNetworkImagesWidget(
                      data?.tournamentImage,
                    ),
                  ),
                ),
                SpacerHorizontal(width: Pad.pad8),
                Visibility(
                  visible: data?.position!=null,
                  child: Container(
                    margin: EdgeInsets.only(right:Pad.pad5),
                    padding: EdgeInsets.all(Pad.pad5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ThemeColors.neutral5,
                    ),
                    child: Text(
                      '${data?.position}',
                      style: styleBaseSemiBold(
                          fontSize: 11, color: ThemeColors.black),
                    ),
                  ),
                ),
                SpacerHorizontal(width: Pad.pad5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: data?.userName != null,
                        child: Text(
                          data?.userName ?? "",
                          style: styleBaseBold(fontSize: 14),
                        ),
                      ),

                      Visibility(
                        visible: data?.date != null,
                        child:Text(
                          data?.date ?? "",
                          style: styleBaseRegular(
                              fontSize: 12),
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
                        style: styleBaseRegular(),
                      ),
                      Text(
                        'Reward Points',
                        style: styleBaseBold(
                            fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SpacerVertical(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                color: ThemeColors.neutral5,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Pad.pad10),
                  bottomRight: Radius.circular(Pad.pad10),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: _richPrices1(
                        label: "Performance: ",
                        value: "${data?.performance ?? "0"}%")
                ),
                Flexible(
                  child: _richPrices1(
                      label: "Pref. Points: ",
                      value: "${(data?.performancePoint ?? 0)}"),
                ),
              ],
            ),
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
            style: styleBaseBold(
              fontSize: 14,
            ),
            children: [
              TextSpan(
                  text: value,
                  style: label=="Pref. Points: "?styleBaseRegular(fontSize: 14):
                  styleBaseBold(fontSize: 14, color: (data?.performance ?? 0) > 0 ? ThemeColors.accent:data?.performance==0?ThemeColors.black:ThemeColors.sos)
              )
            ]
        )
    );
  }
}
