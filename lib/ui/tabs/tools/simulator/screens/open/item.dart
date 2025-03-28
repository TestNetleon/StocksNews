import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_open_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/widget/order_type.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/cache_network_image.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TsOpenListItem extends StatelessWidget {
  final TsOpenListRes? item;
  final Function()? onTap;
  const TsOpenListItem({super.key, this.item, this.onTap});

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
                          const SpacerVertical(height: 5),
                          Row(
                            children: [
                              Visibility(
                                visible: item?.currentPrice != null,
                                child: Flexible(
                                  child: Text(
                                    "${item?.currentPrice?.toFormattedPriceForSim()}",
                                    style: styleBaseRegular(
                                      fontSize: 14,
                                    ),
                                    // maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: item?.change != null,
                                child: Flexible(
                                  child: Text(
                                    "  ${item?.change?.toFormattedPriceForSim()}",
                                    style: styleBaseRegular(
                                      color: (item?.change ?? 0) < 0
                                          ? ThemeColors.sos
                                          : ThemeColors.accent,
                                      fontSize: 14,
                                    ),
                                    // maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
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
                        SpacerVertical(height: Pad.pad3),
                        Visibility(
                          visible: item?.avgPrice != null,
                          child: Text(
                            "Avg. ${item?.avgPrice?.toFormattedPriceForSim()}",
                            style: styleBaseRegular(
                                fontSize: 14, color: ThemeColors.neutral40),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const BaseListDivider(height: 10),
                const SpacerVertical(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: item?.invested != null,
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Invested",
                              style: styleBaseRegular(
                                color: ThemeColors.splashBG,
                                fontSize: 12,
                              ),
                            ),
                            const SpacerVertical(height: Pad.pad3),
                            Text(
                              textAlign: TextAlign.start,
                              "${item?.invested?.toFormattedPriceForSim()}",
                              style: styleBaseBold(
                                  color: ThemeColors.neutral40, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: item?.currentInvested != null,
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Current",
                              style: styleBaseRegular(
                                color: ThemeColors.splashBG,
                                fontSize: 12,
                              ),
                            ),
                            const SpacerVertical(height: Pad.pad3),
                            Text(
                              textAlign: TextAlign.center,
                              "${item?.currentInvested?.toFormattedPriceForSim() ?? 0}",
                              style: styleBaseBold(
                                  color: ThemeColors.neutral40, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: item?.investedChange != null,
                      child: Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            "Change",
                            style: styleBaseRegular(
                              color: ThemeColors.splashBG,
                              fontSize: 12,
                            ),
                          ),
                          const SpacerVertical(height: Pad.pad3),
                          Text(
                            textAlign: TextAlign.end,
                            item?.investedChange == 0
                                ? '0'
                                : "${item?.investedChange?.toFormattedPriceForSim() ?? 0} (${item?.investedChangePercentage?.toCurrencyForSim() ?? 0}%)",
                            style: styleBaseBold(
                              color: (item?.investedChange ?? 0) < 0
                                  ? ThemeColors.sos
                                  : ThemeColors.accent,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
                Visibility(
                  visible: item?.orderType != null && item?.orderType != '',
                  child: Column(
                    children: [
                      const BaseListDivider(height: 10),
                      const SpacerVertical(height: Pad.pad5),
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
                          prices: item?.limitPrice),
                    ),
                    Visibility(
                      visible: item?.orderType != null && item?.orderType != '',
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
          TradingOrderType(
            tradeType: item?.tradeType == 'Short' ? 'Short' : null,
          ),
        ],
      ),
    );
  }

  Widget orderWithType(Alignment alignment, {String? label, num? prices}) {
    return Expanded(
      child: Container(
        alignment: alignment,
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
              style:
                  styleBaseRegular(color: ThemeColors.splashBG, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
