import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/models/trading_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/tournament/provider/tournament.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:svg_flutter/svg_flutter.dart';

class TournamentLeaderboardItem extends StatelessWidget {
  final TradingRes data;
  final bool decorate;
  final int? from;
  const TournamentLeaderboardItem(
      {super.key, required this.data, this.decorate = true, this.from});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context
            .read<LeagueManager>()
            .profileRedirection(userId: "${data.userId ?? ""}");
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: Pad.pad16),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(Pad.pad2),
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: ThemeColors.secondary100)),
                            child: data.imageType == "svg"
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: SvgPicture.network(
                                fit: BoxFit.cover,
                                data.userImage ?? "",
                                placeholderBuilder:
                                    (BuildContext context) => Container(
                                  padding: const EdgeInsets.all(30.0),
                                  child:
                                  const CircularProgressIndicator(
                                    color: ThemeColors.accent,
                                  ),
                                ),
                              ),
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: CachedNetworkImagesWidget(
                                  data.userImage),
                            ),
                          ),
                          SpacerHorizontal(width: Pad.pad8),
                          Container(
                            margin: EdgeInsets.only(right:Pad.pad5),
                            padding: EdgeInsets.all(Pad.pad5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeColors.neutral5,
                            ),
                            child: Text(
                              '${data.position}',
                              style: styleBaseSemiBold(
                                  fontSize: 11, color: ThemeColors.black),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.userName?.capitalizeWords() ??
                                          'N/A',
                                      style: styleBaseBold(),
                                    ),
                                    SpacerVertical(height: Pad.pad3),
                                    Visibility(
                                      visible: from == 3 ? false : true,
                                      child: Text(
                                        data.rank ?? 'N/A',
                                        style: styleBaseRegular(
                                            fontSize: 14,color: ThemeColors.neutral40),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: from == 2 ? true : false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SpacerVertical(height: 5),
                              Text(
                                '${data.totalPoints}',
                                style: styleBaseBold(),
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
                    )
                  ],
                ),
                SpacerVertical(height: Pad.pad8),
                Visibility(
                  visible: from == 2 ? true : false,
                  child: BaseListDivider(height: Pad.pad14),
                ),
                Visibility(
                  visible: from == 2 ? true : false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: _richPrices1(
                              label: "Performance: ",
                              value: "${data.performance ?? "0"}%")
                      ),
                      Flexible(
                        child: Visibility(
                            child: _richPrices(
                                label: "Perf. Points: ",
                                value: "${data.performancePoint}")),
                      ),

                    ],
                  ),
                ),
                Visibility(
                  visible: from == 2 ? true : false,
                  child: BaseListDivider(height: Pad.pad14),
                ),
              ],
            ),
          ),
          if(from == 1 || from == 3)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: Pad.pad16),
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
                          value: "${data.performance ?? "0"}%")
                  ),
                  Flexible(
                    child: _richPrices1(
                        label: "Points Earned: ",
                        value:
                        "${((data.totalPoints ?? 0) + (data.performancePoint ?? 0))}"),
                  ),
                ],
              ),
            ),
          if(from == 2)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: Pad.pad16),
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
                    child: _richPrices(
                        label: "Trades: ", value: "${data.totalTrades}")),
                Flexible(
                  child: _richPrices(
                      label: "Win Ratio: ", value: "${data.winRatio}%"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _richPrices({String? label, String? value}) {
    if (value == null || value.isEmpty) return SizedBox();
    return RichText(
        text: TextSpan(
            text: label,
            style: styleBaseBold(
              fontSize: 14,
              color: ThemeColors.black,
            ),
            children: [
          TextSpan(
            text: value,
            style: styleBaseRegular(fontSize: 14, color: ThemeColors.black),
          )
        ]));
  }

  Widget _richPrices1({String? label, String? value}) {
    if (value == null || value.isEmpty) return SizedBox();
    return RichText(
        text: TextSpan(
            text: label,
            style: styleBaseBold(
              fontSize: 14,
              color: ThemeColors.black
            ),
            children: [
          TextSpan(
              text: value,
              style: label == "Points Earned: "
                  ? styleBaseRegular(fontSize: 14, color: ThemeColors.black)
                  : styleBaseBold(
                      fontSize: 14,
                      color: (data.performance ?? 0) > 0
                          ? ThemeColors.success120
                          : data.performance == 0
                              ? ThemeColors.black
                              : ThemeColors.error120))
        ]));
  }
}
