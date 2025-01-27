import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/models/tour_user_detail.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/spacer_horizontal.dart';

class TlItem extends StatelessWidget {
  final RecentBattlesRes? data;
  const TlItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context
            .read<TournamentProvider>()
            .leagueToLeaderboard(selectedDate: data?.date ?? "");
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: ThemeColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: SizedBox(
                        width: 40.sp,
                        height: 40.sp,
                      /*  decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: ThemeColors.greyBorder)
                        ),*/
                        child:
                        CachedNetworkImagesWidget(
                          data?.tournamentImage?? "",
                        ),
                      ),
                    ),
                    const SpacerHorizontal(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data?.tournamentName ?? '',
                            style: styleGeorgiaBold(fontSize: 16),
                          ),
                          const SpacerVertical(height:3),
                          Visibility(
                            visible: data?.date != null,
                            child: Text(
                              data?.date ?? "",
                              style: stylePTSansRegular(
                                  fontSize: 12, color: ThemeColors.greyText),
                            ),
                          ),
                          /*Visibility(
                            visible: data?.status != null,
                            child: Text(
                              data?.status == 1 ? "Live" : "Closed",
                              style: stylePTSansRegular(
                                  fontSize: 12,
                                  color: data?.status == 1
                                      ? Colors.green
                                      : Colors.red),
                            ),
                          ),*/
                          /*Visibility(
                            visible: data?.performancePoints != null,
                            child: Text(
                              'Per. Points: ${data?.performancePoints}',
                              style: stylePTSansRegular(fontSize: 12,color:ThemeColors.greyText),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                    const SpacerHorizontal(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Visibility(
                          visible:data?.points!=0,
                          child: Text(
                            'Reward Points',
                            style: stylePTSansBold(
                              fontSize: 14,
                              color:ThemeColors.greyText,
                            )
                          ),
                        ),
                        Visibility(
                          visible:data?.points !=0,
                          child: Text(
                            '${data?.points}',
                            style: styleGeorgiaBold(
                              fontSize: 16,
                              color:ThemeColors.themeGreen,
                            ),
                          ),
                        ),
                       /* Visibility(
                          visible: data?.performance!=null,
                          child:  Text(
                            "${data?.performance??"0"}%",
                            style: stylePTSansRegular(fontSize: 14, color: (data?.performance ?? 0) > 0 ? Colors.green : Colors.red,),
                          ),
                        ),*/
                      ],
                    )

                  ],
                ),
                Divider(
                  // thickness: 1,
                  color: ThemeColors.greyBorder,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: _richPrices(label: "Gain/Loss: ",value: "${data?.performance??"0"}%")
                    ),
                    const SpacerHorizontal(width: 10),
                    Flexible(
                      child:
                      _richPrices(label: "Per. Points: ",value: "${data?.performancePoints}"),
                    ),
                  ],
                ),

              ],
            ),
          ),
          Container(
            height: 2,
            margin: EdgeInsets.symmetric(horizontal:6),
            decoration: BoxDecoration(
              color: data?.status == 1
                  ? ThemeColors.themeGreen
                  : ThemeColors.darkRed,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _richPrices ({String? label,String? value}) {
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
                style: label=="Per. Points: "?stylePTSansRegular(fontSize: 14, color: ThemeColors.white):
                stylePTSansBold(fontSize: 14, color: (data?.performance ?? 0) > 0 ? ThemeColors.themeGreen:ThemeColors.darkRed)
              )
            ]
        )
    );
  }
}
