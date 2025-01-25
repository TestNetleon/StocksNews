import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tournament/models/tour_user_detail.dart';
import 'package:stocks_news_new/tournament/provider/tournament.dart';
import 'package:stocks_news_new/utils/theme.dart';

import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/spacer_horizontal.dart';

class TickerItem extends StatelessWidget {
  final RecentTradeRes? data;
  const TickerItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
       // context.read<TournamentProvider>().leagueToLeaderboard(selectedDate: data?.date ?? "");
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: ThemeColors.background,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        width: 43.sp,
                        height: 43.sp,
                        padding: EdgeInsets.all(5.sp),
                        child:
                        CachedNetworkImagesWidget(data?.image)
                    ),
                    const SpacerHorizontal(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    data?.symbol ?? '',
                                    style: styleGeorgiaBold(fontSize: 17),
                                  ),
                                  const SpacerHorizontal(width: 5),
                                  Visibility(
                                    visible: data?.status != null,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: data?.status == 0
                                                ? ThemeColors.themeGreen
                                                : ThemeColors.darkRed,
                                          ),
                                          borderRadius: BorderRadius.circular(20)),
                                      child: Text(
                                        data?.status == 0 ? "OPEN" : "CLOSE",
                                        style: stylePTSansBold(
                                          fontSize:8,
                                          color: data?.status == 0
                                              ? ThemeColors.themeGreen
                                              : ThemeColors.darkRed,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SpacerVertical(height: 5),
                              Text(
                                data?.name??"",
                                style: stylePTSansRegular(
                                  color: ThemeColors.greyText,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          /*Visibility(
                            visible: data?.type != null,
                            child: Text(
                              data?.type == "sell" ? "SELL" : "BUY",
                              style: stylePTSansRegular(
                                  fontSize: 12,
                                  color:data?.type == "sell"
                                      ? Colors.red
                                      : Colors.green),
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
                          visible: data?.performance!=null,
                          child:  Text(
                            "${data?.performance??"0"}%",
                            style: stylePTSansRegular(color: (data?.performance ?? 0) > 0 ? Colors.green : Colors.red,),
                          ),
                        ),
                        Visibility(
                          visible: data?.gainLoss!=null,
                          child:  Text(
                            data?.gainLoss??"0",
                            style: stylePTSansRegular(fontSize: 12, color: (data?.performance ?? 0) > 0 ? Colors.green : Colors.red),
                          ),
                        ),
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
                      child:
                      _richPrices(label: "Order price: ",value: data?.orderPrice),
                    ),
                    const SpacerHorizontal(width: 10),
                    Flexible(
                      child: _richPrices(label: "Close price: ",value: data?.closePrice)
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 2,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: data?.type != "sell"
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
          style: stylePTSansRegular(
            fontSize: 14,
            color:ThemeColors.greyText,
          ),
          children: [
            TextSpan(
                text: value,
                style: styleGeorgiaBold(
                  fontSize: 14,
                  color:ThemeColors.white,
                ),
            )
          ]
        )
    );
  }
}
