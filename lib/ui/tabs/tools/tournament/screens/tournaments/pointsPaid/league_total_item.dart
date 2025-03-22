import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/trading_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';


class LeagueTotalItem extends StatelessWidget {
  final TradingRes? data;
  const LeagueTotalItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          context.read<LeagueManager>().leagueToLeaderboard(selectedDate: data?.date ?? "");
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  const SpacerHorizontal(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data?.tournamentName ?? '',
                          style: styleBaseBold(),
                        ),
                        _richPrices(
                            label: "User Joined: ",
                            value: '${data?.joinUsers ?? 0}'
                        ),
                        Visibility(
                          visible: data?.date != null,
                          child: Text(
                            data?.date ?? "",
                            style: styleBaseRegular(
                                fontSize: 12
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  Visibility(
                    visible: data?.status != null,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: data?.status == 1
                                ? ThemeColors.themeGreen
                                : ThemeColors.darkRed,
                          ),
                          borderRadius:
                          BorderRadius.circular(20)),
                      child: Text(
                        data?.status == 1 ? "Live" : "Closed",
                        style: styleBaseBold(
                          fontSize: 10,
                          color:data?.status == 1
                              ? ThemeColors.success120
                              : ThemeColors.error120,
                        ),
                      ),
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      );
  }

  Widget _richPrices ({String? label,String? value}) {
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
                style: styleBaseRegular(
                    fontSize: 14
                ),
              )
            ]
        )
    );
  }

}
