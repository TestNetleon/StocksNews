import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TournamentOpenDetail extends StatelessWidget {
  final BaseTickerRes? data;

  const TournamentOpenDetail({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10,left: Pad.pad16,right: Pad.pad16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(Pad.pad5),
                decoration: BoxDecoration(
                    color:ThemeColors.neutral5,
                    borderRadius: BorderRadius.circular(Pad.pad5)
                ),
                child: CachedNetworkImagesWidget(
                  data?.image ?? '',
                  height: 45,
                  width: 45,
                ),
              ),

              SpacerHorizontal(width: Pad.pad16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data?.symbol ?? '',
                      style: styleBaseBold(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SpacerVertical(height: 5),
                    Visibility(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text(
                          data?.name ?? '',
                          style: styleBaseRegular(
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Visibility(
                    visible: data?.price != null,
                    child: Text(
                      "${data?.price?.toFormattedPrice()}",
                      style: styleBaseBold(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      Visibility(
                        visible: data?.change != null,
                        child: Text(
                          " ${data?.change?.toFormattedPrice()}",
                          style: styleBaseBold(
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
                          " ${data?.changesPercentage?.toCurrency()}%",
                          style: styleBaseSemiBold(
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
