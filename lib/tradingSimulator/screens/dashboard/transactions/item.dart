import 'package:flutter/material.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_pending_list_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../widgets/order_Type.dart';

class TsTransactionListItem extends StatelessWidget {
  final TsPendingListRes? item;
  final Function()? onTap;
  const TsTransactionListItem({super.key, this.item, this.onTap});

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
                              margin: EdgeInsets.only(bottom: 3),
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
                            child: Container(
                              margin: EdgeInsets.only(bottom: 5),
                              child: Text(
                                "${item?.company}",
                                style: styleGeorgiaRegular(
                                  fontSize: 15,
                                  color: ThemeColors.greyText,
                                ),
                                maxLines: 1,
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
                          visible: item?.quantity != null,
                          child: Text(
                            "${item?.quantity} Qty",
                            style: stylePTSansBold(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              item?.tradeStatus == 'PENDING'
                                  ? "Will Execute on"
                                  : 'Executed at',
                              style: stylePTSansRegular(fontSize: 14),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                item?.tradeStatus == 'PENDING'
                                    ? "Price at Market"
                                    : item?.price ?? '0',
                                style: styleGeorgiaBold(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                          visible: item?.tradeStatus != 'PENDING' &&
                              item?.investedValue != null &&
                              item?.investedValue != '',
                          child: VerticalDivider(
                            color: ThemeColors.greyBorder,
                            thickness: 1,
                          )),
                      Visibility(
                        visible: item?.tradeStatus != 'PENDING' &&
                            item?.investedValue != null &&
                            item?.investedValue != '',
                        child: Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Order value',
                                style: stylePTSansRegular(fontSize: 14),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  item?.investedValue ?? 'N/A',
                                  style: styleGeorgiaBold(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Visibility(
                    // visible: item?.closePrice != null && item?.closePrice != '',
                    visible: item?.closePriceLabel != null &&
                        item?.closePriceLabel != '',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 65, 62, 62),
                      ),
                      margin: EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Text(
                        // "Auto closed at: ${item?.closePrice ?? '\$221'}",
                        // "Closed at: ${item?.closePrice ?? '\$221'}",
                        "${item?.closePriceLabel} ${item?.closePrice}",
                        // item?.closePriceLabel ?? "",
                        style: styleGeorgiaBold(
                          fontSize: 14,
                          color: ThemeColors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  alignment: Alignment.center,
                  child: Text(
                    '${item?.date}',
                    style: styleGeorgiaRegular(
                      color: ThemeColors.greyText,
                      fontSize: 14,
                    ),
                  ),
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
            tradeType: item?.tradeType == 'Short'
                ? 'Short'
                : item?.tradeType == 'Buy To Cover'
                    ? 'Buy to Cover'
                    : null,
          ),
        ],
      ),
    );
  }
}
