import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_recurring_detail.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TransactionItem extends StatelessWidget {
  final Transaction? data;
  const TransactionItem({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: data?.symbol != null && data?.symbol != '',
                          child: Container(
                            margin: EdgeInsets.only(bottom: 2),
                            child: Text(
                              "${data?.symbol}",
                              style: styleBaseBold(
                                  fontSize: 18, color: ThemeColors.primary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SpacerVertical(height: 5),
                        Row(
                          children: [
                            Visibility(
                              visible: data?.recurringAmount != null,
                              child: Flexible(
                                child: Text(
                                  "${data?.recurringAmount?.toFormattedPriceForSim()}",
                                  style: styleBaseRegular(
                                    color: ThemeColors.primary,
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
                        visible: data?.quantity != null,
                        child: Text(
                          "${data?.quantity} QTY",
                          style: styleBaseBold(
                              fontSize: 18, color: ThemeColors.primary),
                        ),
                      ),
                      Visibility(
                        visible: data?.stockPrice != null,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "Stock Price ${data?.stockPrice?.toFormattedPriceForSim()}",
                            style: styleBaseRegular(
                                fontSize: 14, color: ThemeColors.primary),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SpacerVertical(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: data?.createdAt != null && data?.createdAt != '',
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.center,
                            "Executed Date",
                            style: styleBaseRegular(
                              color: ThemeColors.greyText,
                              fontSize: 12,
                            ),
                          ),
                          const SpacerVertical(height: 3),
                          Text(
                            textAlign: TextAlign.end,
                            data?.createdAt ?? "",
                            style: styleBaseRegular(
                              color: ThemeColors.primary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: data?.usedAmount != null,
                    child: Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              "Investment Amount",
                              style: styleBaseRegular(
                                color: ThemeColors.greyText,
                                fontSize: 12,
                              ),
                            ),
                            const SpacerVertical(height: 3),
                            Text(
                              textAlign: TextAlign.end,
                              data?.usedAmount?.toFormattedPrice() ?? "0",
                              style: styleBaseRegular(
                                color: ThemeColors.primary,
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
          visible: data?.statusString != null && data?.statusString != '',
          child: Column(
            children: [
              data?.statusString == "Completed"
                  ? const BaseListDivider(
                      color: ThemeColors.accent,
                      height: 10,
                    )
                  : const BaseListDivider(
                      color: ThemeColors.darkRed,
                      height: 10,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
