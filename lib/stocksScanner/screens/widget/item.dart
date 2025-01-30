import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/screens/stockDetail/index.dart';
import 'package:stocks_news_new/stocksScanner/modals/scanner_res.dart';
import 'package:stocks_news_new/stocksScanner/providers/market_scanner_provider.dart';
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
        num.parse("${(data?.volume ?? 0) * (data?.price ?? 0)}").toUSDFormat();

    String volume =
        num.parse("${(data?.volume ?? 0)}").toUSDFormat(showDollar: false);

    bool preMarket = data?.ext?.extendedHoursType == "PreMarket";
    bool postMarket = data?.ext?.extendedHoursType == "PostMarket";

    String? prePost = postMarket
        ? 'Post Mkt. Price'
        : preMarket
            ? 'Pre Mkt. Price'
            : null;

    num lastTrade = data?.price ?? 0;
    num netChange = data?.change ?? 0;
    num perChange = data?.changesPercentage ?? 0;

    num? postMarketPrice = data?.ext?.extendedHoursPrice ?? 0;
    num? postMarketChange = data?.ext?.extendedHoursChange ?? 0;
    num? postMarketChangePer = data?.ext?.extendedHoursPercentChange ?? 0;

    if (!showPreMarket && (preMarket || postMarket)) {
      lastTrade = data?.ext?.extendedHoursPrice ?? 0;
      netChange = data?.ext?.extendedHoursChange ?? 0;
      perChange = data?.ext?.extendedHoursPercentChange ?? 0;

      dollarVolume = num.parse(
              "${(data?.volume ?? 0) * (data?.ext?.extendedHoursPrice ?? 0)}")
          .toUSDFormat();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (data?.identifier == null || data?.identifier == '') {
                        return;
                      }
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return StockDetail(symbol: data?.identifier ?? '');
                        },
                      ));
                    },
                    child: Visibility(
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
                            style: stylePTSansBold(fontSize: 18),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SpacerVertical(height: 3),
                        Visibility(
                          visible: data?.name != null && data?.name != '',
                          child: Text(
                            data?.name ?? '',
                            style: stylePTSansRegular(
                              color: ThemeColors.greyText,
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        //  Visibility(
                        //    visible: data?.sector != null,
                        //    child: _widget(
                        //      label: 'Sector: ',
                        //      value: data?.sector,
                        //    ),
                        //  ),
                        Visibility(
                          visible: data?.sector != null && data?.sector != '',
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              'Sector: ${data?.sector}',
                              style: stylePTSansRegular(
                                color: ThemeColors.greyText,
                                fontSize: 13,
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
                      Text(
                        '\$${lastTrade.toCurrency()}',
                        style: stylePTSansBold(fontSize: 18),
                      ),
                      const SpacerVertical(height: 5),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: netChange == 0
                                  ? "\$$netChange"
                                  : "\$$netChange ($perChange%)",
                              style: stylePTSansRegular(
                                fontSize: 14,
                                height: 0.0,
                                color:
                                    perChange > 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer<MarketScannerProvider>(
                        builder: (context, value, child) {
                          return Visibility(
                            // visible: false,
                            visible: value.port?.port?.checkMarketOpenApi
                                    ?.checkPreMarket ==
                                true,
                            //prePost != null && prePost != '' && !showPreMarket,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: const Color.fromARGB(255, 50, 49, 49),
                              ),
                              margin: const EdgeInsets.only(top: 5),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              child: Text(
                                'Pre Market',
                                style: styleGeorgiaRegular(fontSize: 13),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
              Visibility(
                visible: showPreMarket,
                child: Divider(
                  color: ThemeColors.greyBorder,
                ),
              ),
              Visibility(
                visible: showPreMarket,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Visibility(
                        visible: postMarketPrice != null && showPreMarket,
                        child: _widget(
                          fontSize: 14,
                          margin: EdgeInsets.only(top: 0),
                          label: prePost != null
                              ? '$prePost: '
                              : 'Post Mkt. Price: ',
                          value: '\$$postMarketPrice',
                        ),
                      ),
                    ),
                    const SpacerHorizontal(width: 5),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: postMarketChange == 0
                                  ? "\$$postMarketChange"
                                  : "\$$postMarketChange ($postMarketChangePer%)",
                              style: stylePTSansRegular(
                                fontSize: 14,
                                height: 0.0,
                                color: (postMarketChangePer ?? 0) > 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
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
                  Flexible(
                    child: Visibility(
                      visible: volume != '',
                      child: _widget(
                        label: 'Vol.: ',
                        value: volume,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Visibility(
                      visible: dollarVolume != '',
                      child: _widget(
                        textAlign: TextAlign.end,
                        label: '\$Vol.: ',
                        fontSize: 14,
                        value: dollarVolume,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: ThemeColors.gradientLight,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Visibility(
                  visible: data?.bid != null,
                  child: _widget(
                    label: 'Bid: ',
                    value: '\$${data?.bid}',
                  ),
                ),
              ),
              Flexible(
                child: Visibility(
                  visible: data?.ask != null,
                  child: _widget(
                    margin: EdgeInsets.only(left: 10),
                    label: 'Ask: ',
                    value: '\$${data?.ask}',
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
    Color? color,
    double fontSize = 13,
    TextAlign textAlign = TextAlign.start,
  }) {
    if (value == null || value == '') {
      return SizedBox();
    }
    return Container(
      margin: margin,
      padding: const EdgeInsets.only(bottom: 5),
      child: RichText(
        textAlign: textAlign,
        text: TextSpan(
          text: label,
          style: styleGeorgiaBold(
            fontSize: fontSize,
            color: ThemeColors.greyText,
            // height: 1.7,
          ),
          children: [
            TextSpan(
              text: value,
              style: styleGeorgiaBold(
                fontSize: fontSize,
                // height: 1.7,
                color: color ?? Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
