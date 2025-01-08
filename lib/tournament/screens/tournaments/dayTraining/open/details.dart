import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../../../../../tradingSimulator/modals/trading_search_res.dart';
import '../../../../../utils/colors.dart';
import '../../../../../utils/theme.dart';
import '../../../../../widgets/spacer_horizontal.dart';
import '../../../../../widgets/spacer_vertical.dart';

class TournamentOpenDetail extends StatelessWidget {
  final TradingSearchTickerRes? data;

  const TournamentOpenDetail({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: CachedNetworkImage(
                  width: 43,
                  height: 43,
                  imageUrl: data?.image ?? '',
                ),
              ),
              SpacerHorizontal(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data?.symbol ?? '',
                      style: styleGeorgiaBold(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SpacerVertical(height: 5),
                    Visibility(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          data?.name ?? '',
                          style: styleGeorgiaRegular(
                            color: ThemeColors.greyText,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SpacerHorizontal(width: 10),
              Column(
                children: [
                  Visibility(
                    visible: data?.currentPrice != null,
                    child: Text(
                      "${data?.currentPrice?.toFormattedPrice()}",
                      style: styleGeorgiaBold(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: data?.change != null,
                        child: Text(
                          " ${data?.change?.toFormattedPrice()}",
                          style: styleGeorgiaRegular(
                            color: (data?.change ?? 0) >= 0
                                ? ThemeColors.accent
                                : ThemeColors.sos,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Visibility(
                        visible: data?.changesPercentage != null,
                        child: Text(
                          " (${data?.changesPercentage?.toCurrency()}%)",
                          style: styleGeorgiaRegular(
                            color: (data?.changesPercentage ?? 0) >= 0
                                ? ThemeColors.accent
                                : ThemeColors.sos,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
