import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../tradingSimulator/modals/trading_search_res.dart';
import '../../provider/trades.dart';

class TournamentTradeItem extends StatelessWidget {
  final TradingSearchTickerRes? data;
  const TournamentTradeItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.read<TournamentTradesProvider>().tickerDetailRedirection(data?.symbol ?? "");
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
              children: [
                Row(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    data?.symbol ?? '',
                                    style: styleGeorgiaBold(fontSize: 18),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Visibility(visible: data?.status == 0,child: const SpacerHorizontal(width: 5)),
                                  Visibility(
                                    visible: data?.status == 0,
                                    child: Text(
                                      '(${data?.currentPrice?.toFormattedPrice() ?? '\$0'})',
                                      style: stylePTSansBold(
                                          fontSize: 14,
                                          color: (data?.currentPrice ?? 0) > 0
                                              ? ThemeColors.themeGreen
                                              : (data?.currentPrice ?? 0) == 0
                                              ? ThemeColors.white
                                              : ThemeColors.darkRed
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              Visibility(
                                visible: data?.type != null,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: data?.type?.name != "sell"
                                            ? ThemeColors.themeGreen
                                            : ThemeColors.darkRed,
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(20)),
                                  child: Text(
                                    data?.type?.name != "sell" ? "BUY" : "SELL",
                                    style: stylePTSansBold(
                                      fontSize: 10,
                                      color: data?.type?.name != "sell"
                                          ? ThemeColors.themeGreen
                                          : ThemeColors.darkRed,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                         /* Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                              Text(
                                "${data?.orderChange?.toCurrency() ?? 0} %",
                                style: styleGeorgiaBold(
                                  fontSize: 13,
                                  color:(data?.orderChange ?? 0) < 0
                                      ? ThemeColors.sos
                                      :
                                  data?.orderChange==0?
                                  ThemeColors.white:
                                  ThemeColors.accent,
                                ),
                              ),
                            ],
                          )*/

                        ],
                      ),
                    ),

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
                      child: _richPrices(
                          label: "Order price: ", value: data?.orderPrice?.toFormattedPrice() ?? '\$0'),
                    ),
                    const SpacerHorizontal(width: 10),
                    Flexible(
                        child: _richPrices(
                            label: "Close price: ", value: data?.closePrice?.toFormattedPrice() ?? '\$0')),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                color: ThemeColors.primaryLight,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: _richPrices1(label: "Gain/Loss: ", value: data?.gainLoss?.toFormattedPrice() ?? '\$0',values: data?.gainLoss??0)),
                const SpacerHorizontal(width: 10),
                Flexible(
                  child: _richPrices1(
                      label: "Performance: ",
                      value: "${data?.orderChange?.toCurrency()??"0"}%",
                      values: data?.orderChange??0
                  ),

                ),
              ],
            ),
          ),
          Container(
            height: 2,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: data?.status == 1
                  ? ThemeColors.sos
                  :ThemeColors.accent,
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

  Widget _richPrices({String? label, String? value}) {
    if (value == null || value.isEmpty) return SizedBox();
    return RichText(
        text: TextSpan(
            text: label,
            style: stylePTSansRegular(
              fontSize: 14,
              color: ThemeColors.greyText,
            ),
            children: [
              TextSpan(
                text: value,
                style: stylePTSansBold(
                  fontSize: 14,
                  color: ThemeColors.white,
                ),
              )
            ]));
  }

  Widget _richPrices1({String? label, String? value, num? values}) {
    if (value == null || value.isEmpty) return SizedBox();
    return RichText(
        text: TextSpan(
            text: label,
            style: stylePTSansRegular(
              fontSize: 14,
              color: ThemeColors.greyText,
            ),
            children: [
              TextSpan(
                text: value,
                style: stylePTSansBold(
                    fontSize: 14,
                    color: (values ?? 0) > 0
                        ? ThemeColors.themeGreen
                        : (values ?? 0) == 0
                        ? ThemeColors.white
                        : ThemeColors.darkRed),
              )
            ]));
  }
}
