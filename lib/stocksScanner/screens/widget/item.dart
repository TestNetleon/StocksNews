import 'package:flutter/material.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

import '../../../utils/theme.dart';
import '../../../widgets/spacer_vertical.dart';

class ScannerBaseItem extends StatelessWidget {
  final bool showPreMarket;
  final ScannerRes? data;
  const ScannerBaseItem({
    super.key,
    this.data,
    this.showPreMarket = false,
  });

  @override
  Widget build(BuildContext context) {
    String dollarVolume =
        num.parse("${(data?.volume ?? 0) * (data?.price ?? 0)}").toRuppees();
    num? postMarketPrice = data?.ext?.extendedHoursPrice;

    double lastTrade = data?.price ?? 0;
    double netChange = data?.change ?? 0;
    double perChange = data?.changesPercentage ?? 0;
    if (data?.ext?.extendedHoursType == "PostMarket" ||
        data?.ext?.extendedHoursType == "PreMarket") {
      netChange = data?.ext?.extendedHoursChange ?? 0;
      perChange = data?.ext?.extendedHoursPercentChange ?? 0;
      lastTrade = data?.ext?.extendedHoursPrice ?? 0;
    }
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ThemeColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Visibility(
                    visible: data?.image != null && data?.image != '',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: SizedBox(
                        height: 43,
                        width: 43,
                        // color: ThemeColors.greyText,
                        child: CachedNetworkImagesWidget(data?.image ?? ''),
                      ),
                    ),
                  ),
                  SpacerHorizontal(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: data?.identifier != null &&
                              data?.identifier != '',
                          child: Text(
                            data?.identifier ?? '',
                            style: stylePTSansBold(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SpacerVertical(height: 5),
                        Visibility(
                          visible: data?.name != null && data?.name != '',
                          child: Text(
                            data?.name ?? '',
                            style: stylePTSansRegular(
                              color: ThemeColors.greyText,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SpacerHorizontal(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Visibility(
                            visible: data?.bid != null,
                            child: _widget(
                              label: 'Bid: ',
                              value: '\$${data?.bid}',
                            ),
                          ),
                          Visibility(
                            visible: data?.ask != null,
                            child: _widget(
                              margin: EdgeInsets.only(left: 10),
                              label: 'Ask: ',
                              value: '\$${data?.ask}',
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: data?.volume != null,
                        child: _widget(
                          label: 'Volume: ',
                          value: '\$${data?.volume}',
                        ),
                      ),
                      Visibility(
                        visible: dollarVolume != '',
                        child: _widget(
                          label: '\$Volume: ',
                          value: dollarVolume,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Visibility(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Visibility(
                        visible: data?.sector != null,
                        child: _widget(
                          label: 'Sector: ',
                          value: data?.sector,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Visibility(
                        visible: postMarketPrice != null && showPreMarket,
                        child: _widget(
                          margin: EdgeInsets.only(left: 10),
                          label: '\$Post Market Price: ',
                          value: '\$$postMarketPrice',
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: ThemeColors.gradientLight,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: _widget(
                  margin: EdgeInsets.only(left: 10),
                  label: 'Last Trade: ',
                  value: '\$$lastTrade',
                ),
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    netChange == 0
                        ? '\$$netChange'
                        : '${netChange.toFormattedPrice()} ($perChange%)',
                    style: styleGeorgiaRegular(
                      fontSize: 11,
                      color:
                          netChange >= 0 ? ThemeColors.accent : ThemeColors.sos,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _widget({
    required String label,
    String? value,
    EdgeInsetsGeometry? margin,
  }) {
    if (value == null || value == '') {
      return SizedBox();
    }
    return Container(
      margin: margin,
      padding: const EdgeInsets.only(bottom: 5),
      child: RichText(
        text: TextSpan(
          text: label,
          style: styleGeorgiaRegular(
            fontSize: 11,
            color: ThemeColors.greyText,
            height: 1.7,
          ),
          children: [
            TextSpan(
              text: value,
              style: styleGeorgiaRegular(
                fontSize: 11,
                height: 1.7,
              ),
            )
          ],
        ),
      ),
    );
  }
}
