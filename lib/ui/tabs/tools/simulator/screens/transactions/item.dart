import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_pending_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/widget/order_type.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';


class TsTransactionListItem extends StatelessWidget {
  final TsPendingListRes? item;
  final Function()? onTap;
  const TsTransactionListItem({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: Pad.pad5),
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
                              style: stylePTSansBold(fontSize: 16,color: ThemeColors.splashBG),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Visibility(
                            visible:
                                item?.company != null && item?.company != '',
                            child: Text(
                              "${item?.company}",
                              style: stylePTSansRegular(
                                fontSize: 14,
                                color: ThemeColors.neutral40,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SpacerHorizontal(width: Pad.pad10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: item?.quantity != null,
                          child: Text(
                            "${item?.quantity} Qty",
                            style: stylePTSansBold(fontSize: 16,color: ThemeColors.splashBG),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SpacerVertical(height: Pad.pad5),
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
                              style: stylePTSansRegular(fontSize: 14,color: ThemeColors.neutral40),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                item?.tradeStatus == 'PENDING'
                                    ? "Price at Market"
                                    : item?.price ?? '0',
                                style: styleGeorgiaBold(fontSize: 16,color: ThemeColors.splashBG),
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
                            color: ThemeColors.neutral5,
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
                                style: stylePTSansRegular(fontSize: 14,color: ThemeColors.neutral40),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  item?.investedValue ?? 'N/A',
                                  style: styleGeorgiaBold(fontSize: 16,color: ThemeColors.splashBG),
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
                    visible: item?.closePriceLabel != null && item?.closePriceLabel != '',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ThemeColors.neutral40),
                      ),
                      margin: EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Text(
                        "${item?.closePriceLabel} ${item?.closePrice}",
                        style: styleGeorgiaBold(
                          fontSize: 14,
                          color: ThemeColors.splashBG,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: Pad.pad10),
                  alignment: Alignment.center,
                  child: Text(
                    '${item?.date}',
                    style: styleGeorgiaRegular(
                      color: ThemeColors.neutral40,
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
