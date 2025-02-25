import 'package:flutter/material.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_pending_list_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../widgets/order_Type.dart';

class TsPendingListItem extends StatelessWidget {
  final TsPendingListRes? item;
  final Function()? onTap;
  const TsPendingListItem({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        width: 48,
                        height: 48,
                        child: ThemeImageView(url: item?.image ?? ""),
                      ),
                    ),
                    const SpacerHorizontal(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: item?.symbol != null && item?.symbol != '',
                            child: Container(
                              margin: EdgeInsets.only(bottom: 2),
                              child: Text(
                                "${item?.symbol}",
                                style: styleGeorgiaBold(fontSize: 18),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Visibility(
                            visible:
                                item?.company != null && item?.company != '',
                            child: Text(
                              "${item?.company}",
                              style: styleGeorgiaBold(
                                fontSize: 15,
                                color: ThemeColors.greyText,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Visibility(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "Price at Market",
                                style: styleGeorgiaRegular(
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpacerHorizontal(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Visibility(
                          visible:
                              item?.quantity != null && item?.quantity != '',
                          child: Text(
                            "${item?.quantity} QTY",
                            style: stylePTSansBold(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Visibility(
                  visible: item?.orderTypeOriginal != null &&
                      item?.orderTypeOriginal != 'MARKET_ORDER',
                  child: Column(
                    children: [
                      const Divider(color: ThemeColors.greyBorder, height: 10),
                      const SpacerVertical(height: 5),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: item?.targetPrice != null && item?.targetPrice != 0,
                      child:
                      orderWithType(Alignment.centerLeft,label: "Target Price",prices: item?.targetPrice)
                    ),
                    Visibility(
                      visible: item?.stopPrice != null && item?.stopPrice != 0,
                      child:
                      orderWithType(item?.orderTypeOriginal=="BRACKET_ORDER"?Alignment.centerRight:Alignment.centerLeft,label: "Stop Price",prices: item?.stopPrice)
                    ),

                    Visibility(
                      visible: item?.limitPrice != null && item?.limitPrice != 0,
                      child:orderWithType(Alignment.centerLeft,label: "Limit Price",prices: item?.limitPrice)
                    ),
                    Visibility(
                      visible: item?.orderTypeOriginal != null &&
                          item?.orderTypeOriginal != 'MARKET_ORDER',
                      child: Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                "Order Type",
                                style: stylePTSansRegular(
                                  color: ThemeColors.greyText,
                                  fontSize: 12,
                                ),
                              ),
                              const SpacerVertical(height: 3),
                              Text(
                                textAlign: TextAlign.end,
                                item?.orderType ?? "",
                                style: stylePTSansRegular(
                                  color: ThemeColors.greyText,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: item?.tradeType == 'Buy' || item?.tradeType == 'Sell',
            child: Container(
              height: 2,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: item?.tradeType == "Buy"
                    ? ThemeColors.themeGreen
                    : ThemeColors.darkRed,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
          ),
          TradingOrderTypeContainer(
            tradeType: (item?.tradeType == 'Short' ||
                    item?.tradeType == 'Buy To Cover')
                ? 'Short'
                : null,
          ),
        ],
      ),
    );
  }

  Widget orderWithType(Alignment alignment,{String? label, num? prices}) {
    return Expanded(
      child: Container(
        alignment: alignment,
        padding: const EdgeInsets.only(right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label??"",
              style: stylePTSansRegular(
                color: ThemeColors.greyText,
                fontSize: 12,
              ),
            ),
            const SpacerVertical(height: 3),
            Text(
              textAlign: TextAlign.start,
              prices?.toFormattedPrice() ?? "",
              style: stylePTSansBold(
                  color: ThemeColors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
