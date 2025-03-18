import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_pending_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/widget/order_type.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TsPendingListItem extends StatelessWidget {
  final TsPendingListRes? item;
  final Function()? onTap;
  const TsPendingListItem({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
                horizontal: Pad.pad16, vertical: Pad.pad5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Pad.pad5),
                      child: Container(
                        padding: EdgeInsets.all(3.sp),
                        color: ThemeColors.neutral5,
                        child: CachedNetworkImagesWidget(
                          item?.image ?? "",
                          height: 36,
                          width: 36,
                        ),
                      ),
                    ),
                    const SpacerHorizontal(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: item?.symbol != null && item?.symbol != '',
                            child: Text(
                              "${item?.symbol}",
                              style: styleBaseBold(
                                  fontSize: 16, color: ThemeColors.splashBG),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Visibility(
                            visible:
                                item?.company != null && item?.company != '',
                            child: Text(
                              "${item?.company}",
                              style: styleBaseRegular(
                                fontSize: 14,
                                color: ThemeColors.neutral40,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Visibility(
                            child: Text(
                              "Price at Market",
                              style: styleBaseRegular(
                                fontSize: 14,
                                color: ThemeColors.neutral40,
                              ),
                              overflow: TextOverflow.ellipsis,
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
                            "${item?.quantity} QTY",
                            style: styleBaseBold(
                                fontSize: 16, color: ThemeColors.splashBG),
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
                      const BaseListDivider(height: 10),
                      const SpacerVertical(height: 5),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                        visible:
                            item?.targetPrice != null && item?.targetPrice != 0,
                        child: orderWithType(Alignment.centerLeft,
                            label: "Target Price", prices: item?.targetPrice)),
                    Visibility(
                        visible:
                            item?.stopPrice != null && item?.stopPrice != 0,
                        child: orderWithType(
                            item?.orderTypeOriginal == "BRACKET_ORDER"
                                ? Alignment.center
                                : Alignment.centerLeft,
                            label: item?.orderTypeOriginal == "TRAILING_ORDER"
                                ? "Trail Price"
                                : "Stop Price",
                            prices: item?.stopPrice)),
                    Visibility(
                        visible:
                            item?.limitPrice != null && item?.limitPrice != 0,
                        child: orderWithType(
                            item?.orderTypeOriginal == "STOP_LIMIT_ORDER"
                                ? Alignment.center
                                : Alignment.centerLeft,
                            label: "Limit Price",
                            prices: item?.limitPrice)),
                    Visibility(
                      visible: item?.orderTypeOriginal != null &&
                          item?.orderTypeOriginal != 'MARKET_ORDER',
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              "Order Type",
                              style: styleBaseRegular(
                                color: ThemeColors.splashBG,
                                fontSize: 12,
                              ),
                            ),
                            const SpacerVertical(height: 3),
                            Text(
                              textAlign: TextAlign.end,
                              item?.orderType ?? "",
                              style: styleBaseBold(
                                color: ThemeColors.splashBG,
                                fontSize: 12,
                              ),
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
          Visibility(
            visible: item?.tradeType == 'Buy' || item?.tradeType == 'Sell',
            child: Container(
              height: 2,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: item?.tradeType == "Buy"
                    ? ThemeColors.success120
                    : ThemeColors.error120,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
          ),
          TradingOrderType(
            tradeType: (item?.tradeType == 'Short' ||
                    item?.tradeType == 'Buy To Cover')
                ? 'Short'
                : null,
          ),
        ],
      ),
    );
  }

  Widget orderWithType(Alignment alignment, {String? label, num? prices}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label ?? "",
            style: styleBaseRegular(
              color: ThemeColors.splashBG,
              fontSize: 12,
            ),
          ),
          const SpacerVertical(height: Pad.pad3),
          Text(
            textAlign: TextAlign.start,
            prices?.toFormattedPrice() ?? "",
            style: styleBaseRegular(color: ThemeColors.splashBG, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
