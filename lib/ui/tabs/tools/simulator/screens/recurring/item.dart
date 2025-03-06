import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_recurring_list_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class TsRecurringListItem extends StatelessWidget {
  final TsRecurringListRes? item;
  final Function()? onTap;
  const TsRecurringListItem({super.key, this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
                    Visibility(
                      visible:
                      item?.averagePrice != null,
                      child: Text(
                        "Avg. ${item?.averagePrice?.toFormattedPriceForSim()}",
                        style: stylePTSansRegular(fontSize: 14,color: ThemeColors.neutral40),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const Divider(color: ThemeColors.neutral5,thickness: 1, height: 10),
            const SpacerVertical(height: Pad.pad5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: item?.totalInvested != null,
                  child: Expanded(
                    child:Column(
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
                          "${item?.totalInvested?.toFormattedPriceForSim()}",
                          style:stylePTSansBold(
                              color: ThemeColors.neutral40, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: item?.currentValuation != null,
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Current",
                          style: stylePTSansRegular(
                            color: ThemeColors.splashBG,
                            fontSize: 12,
                          ),
                        ),
                        const SpacerVertical(height: Pad.pad3),
                        Text(
                          textAlign: TextAlign.center,
                          "${item?.currentValuation?.toFormattedPriceForSim() ?? 0}",
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
                    child: Column(
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
                    ),
                  ),
                ),
              ],
            ),
            const SpacerVertical(height: Pad.pad10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: item?.recurringAmount != null,
                  child: Expanded(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recurring Amt.",
                            style: stylePTSansRegular(
                              color: ThemeColors.splashBG,
                              fontSize: 12,
                            ),
                          ),
                          const SpacerVertical(height: Pad.pad3),
                          Text(
                            "${item?.recurringAmount?.toFormattedPriceForSim()}",
                            style: stylePTSansRegular(
                                color: ThemeColors.splashBG, fontSize: 12),
                          ),
                        ],
                      )
                  ),
                ),
                Visibility(
                  visible: item?.frequencyString != null && item?.frequencyString != '',
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Frequency",
                          style: stylePTSansRegular(
                            color: ThemeColors.splashBG,
                            fontSize: 12,
                          ),
                        ),
                        const SpacerVertical(height: Pad.pad3),
                        Text(
                          item?.frequencyString ?? "",
                          style: stylePTSansRegular(
                            color: ThemeColors.splashBG,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: item?.recurringDate != null && item?.recurringDate != '',
                  child: Expanded(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Recurring Date",
                          style: stylePTSansRegular(
                            color: ThemeColors.splashBG,
                            fontSize: 12,
                          ),
                        ),
                        const SpacerVertical(height: Pad.pad3),
                        Text(
                          item?.recurringStringDate ?? "",
                          style: stylePTSansRegular(
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
            Visibility(visible: item?.statusType != null && item?.statusType != '',child: const SpacerVertical(height: Pad.pad10)),
            Visibility(
              visible: item?.statusType != null && item?.statusType != '',
              child: Column(
                children: [
                  item?.statusType=="RUNNING"?
                  const Divider(color: ThemeColors.success120, height:5,thickness:1):
                  const Divider(color: ThemeColors.error120, height:5,thickness:1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}