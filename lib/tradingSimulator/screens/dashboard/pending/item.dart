import 'package:flutter/material.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_pending_list_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class TsPendingListItem extends StatelessWidget {
  final TsPendingListRes? item;
  final Function()? onTap;
  const TsPendingListItem({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                      Row(
                        children: [
                          Text(
                            "${item?.company}",
                            style: styleGeorgiaBold(fontSize: 18),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // SpacerHorizontal(width: 5),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(40),
                          //     color: item?.orderType == 'buy'
                          //         ? ThemeColors.accent
                          //         : ThemeColors.sos,
                          //   ),
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 10, vertical: 2),
                          //   child: Text(
                          //     // item?.buy == true ? "Buy" : "Sell",
                          //     item?.orderType ?? "",
                          //     style: stylePTSansBold(fontSize: 12),
                          //   ),
                          // ),
                        ],
                      ),
                      const SpacerVertical(height: 5),
                      Text(
                        "Price: ${item?.currency}${item?.price}",
                        style: styleGeorgiaRegular(
                          // color: ThemeColors.greyText,
                          fontSize: 14,
                        ),
                        // maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${item?.quantity} Qty",
                      style: stylePTSansBold(fontSize: 18),
                    ),
                    const SpacerVertical(height: 5),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: item?.tradeType == "Buy"
                                ? ThemeColors.themeGreen
                                : ThemeColors.darkRed,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "${item?.tradeType}",
                        style: stylePTSansBold(
                          fontSize: 14,
                          color: item?.tradeType == "Buy"
                              ? ThemeColors.themeGreen
                              : ThemeColors.darkRed,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Visibility(
              visible: item?.orderType.limitOrder.status ??
                  item?.orderType.targetPrice.status ??
                  item?.orderType.stopLoss.status ??
                  false,
              child: const Divider(color: ThemeColors.greyBorder, height: 10),
            ),
            Row(
              children: [
                Flexible(
                  child: Visibility(
                    visible: item?.orderType.limitOrder.status ?? false,
                    child: Column(
                      children: [
                        Text(
                          "Limit Order",
                          style: stylePTSansRegular(
                            color: ThemeColors.greyText,
                            fontSize: 13,
                          ),
                        ),
                        const SpacerVertical(height: 3),
                        Text(
                          "${item?.orderType.limitOrder.price}",
                          style: stylePTSansBold(
                            color: ThemeColors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SpacerHorizontal(width: 40),
                Flexible(
                  child: Visibility(
                    visible: item?.orderType.targetPrice.status ?? false,
                    child: Column(
                      children: [
                        Text(
                          "Target Price",
                          style: stylePTSansRegular(
                            color: ThemeColors.greyText,
                            fontSize: 13,
                          ),
                        ),
                        const SpacerVertical(height: 3),
                        Text(
                          "${item?.orderType.targetPrice.price}",
                          style: stylePTSansBold(
                            color: ThemeColors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SpacerHorizontal(width: 40),
                Flexible(
                  child: Visibility(
                    visible: item?.orderType.stopLoss.status ?? false,
                    child: Column(
                      children: [
                        Text(
                          "Stop Loss",
                          style: stylePTSansRegular(
                            color: ThemeColors.greyText,
                            fontSize: 13,
                          ),
                        ),
                        const SpacerVertical(height: 3),
                        Text(
                          "${item?.orderType.stopLoss.price}",
                          style: stylePTSansBold(fontSize: 14),
                        ),
                      ],
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
}
