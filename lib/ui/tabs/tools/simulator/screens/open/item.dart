import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_open_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/widget/order_type.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';


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
            margin: const EdgeInsets.symmetric(horizontal: Pad.pad16, vertical: Pad.pad5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 34,
                      height: 34,
                      child: ThemeImageView(url: item?.image ?? ""),
                    ),
                    const SpacerHorizontal(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: item?.symbol != null && item?.symbol != '',
                            child:  Text(
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
                          const SpacerVertical(height: 5),
                          Row(
                            children: [
                              Visibility(
                                visible: item?.currentPrice != null,
                                child: Flexible(
                                  child: Text(
                                    "${item?.currentPrice?.toFormattedPriceForSim()}",
                                    style: styleGeorgiaRegular(
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
                                    style: styleGeorgiaRegular(
                                      color: (item?.change ?? 0) < 0
                                          ? ThemeColors.error120
                                          : ThemeColors.success120,
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
                            style: stylePTSansBold(fontSize: 16,color: ThemeColors.splashBG),
                          ),
                        ),
                        SpacerVertical(height:Pad.pad3),
                        Visibility(
                          visible:
                              item?.avgPrice != null,
                          child: Text(
                            "Avg. ${item?.avgPrice?.toFormattedPriceForSim()}",
                            style: stylePTSansRegular(fontSize: 14,color: ThemeColors.neutral40),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const Divider(color: ThemeColors.neutral5,thickness: 1, height: 10),
                const SpacerVertical(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: item?.invested != null,
                      child: Expanded(
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Invested",
                              style: stylePTSansRegular(
                                color: ThemeColors.splashBG,
                                fontSize: 12,
                              ),
                            ),
                            const SpacerVertical(height: Pad.pad3),
                            Text(
                              textAlign: TextAlign.start,
                              "${item?.invested?.toFormattedPriceForSim()}",
                              style: stylePTSansBold(
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
                              style:stylePTSansRegular(
                                color: ThemeColors.splashBG,
                                fontSize: 12,
                              ),
                            ),
                            const SpacerVertical(height: Pad.pad3),
                            Text(
                              textAlign: TextAlign.center,
                              "${item?.currentInvested?.toFormattedPriceForSim() ?? 0}",
                              style: stylePTSansBold(
                                  color: ThemeColors.neutral40, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: item?.investedChange != null,
                      child: Expanded(
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              "Change",
                              style: stylePTSansRegular(
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
                              style: stylePTSansBold(
                                color: (item?.investedChange ?? 0) < 0
                                    ? ThemeColors.error120
                                    : ThemeColors.success120,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: item?.orderType != null && item?.orderType != '',
                  child: Column(
                    children: [
                      const Divider(color: ThemeColors.neutral5,thickness: 1, height: 10),
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
                            prices: item?.limitPrice)),
                    Visibility(
                      visible: item?.orderType != null && item?.orderType != '',
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              "Order Type",
                              style: stylePTSansRegular(
                                color: ThemeColors.splashBG,
                                fontSize: 12,
                              ),
                            ),
                            const SpacerVertical(height: 3),
                            Text(
                              textAlign: TextAlign.end,
                              item?.orderType ?? "",
                              style: stylePTSansBold(
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
              style:stylePTSansRegular(
                color: ThemeColors.splashBG,
                fontSize: 12,
              ),
            ),
            const SpacerVertical(height: Pad.pad3),
            Text(
              textAlign: TextAlign.start,
              prices?.toFormattedPrice() ?? "",
              style: stylePTSansRegular(color: ThemeColors.splashBG, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

