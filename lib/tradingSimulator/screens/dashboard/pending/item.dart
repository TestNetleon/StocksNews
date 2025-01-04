import 'package:flutter/material.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_pending_list_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

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
                            visible:
                                item?.company != null && item?.company != '',
                            child: Text(
                              "${item?.company}",
                              style: styleGeorgiaBold(fontSize: 18),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Visibility(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                // "Price: ${item?.price}",
                                "Price at Market",

                                style: styleGeorgiaRegular(
                                  // color: ThemeColors.greyText,
                                  fontSize: 14,
                                ),
                                // maxLines: 2,
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
                            "${item?.quantity} Qty",
                            style: stylePTSansBold(fontSize: 18),
                          ),
                        ),
                        // Visibility(
                        //   visible:
                        //       item?.tradeType != null && item?.tradeType != '',
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(
                        //       horizontal: 15,
                        //       vertical: 2,
                        //     ),
                        //     margin: EdgeInsets.only(top: 5),
                        //     decoration: BoxDecoration(
                        //         border: Border.all(
                        //           color: item?.tradeType == "Buy"
                        //               ? ThemeColors.themeGreen
                        //               : ThemeColors.darkRed,
                        //         ),
                        //         borderRadius: BorderRadius.circular(20)),
                        //     child: Text(
                        //       "${item?.tradeType ?? 'N/A'}",
                        //       style: stylePTSansBold(
                        //         fontSize: 14,
                        //         color: item?.tradeType == "Buy"
                        //             ? ThemeColors.themeGreen
                        //             : ThemeColors.darkRed,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
                // Visibility(
                //   visible: item?.orderType.limitOrder.status ??
                //       item?.orderType.targetPrice.status ??
                //       item?.orderType.stopLoss.status ??
                //       false,
                //   child: const Divider(color: ThemeColors.greyBorder, height: 10),
                // ),
                // Row(
                //   children: [
                //     Flexible(
                //       child: Visibility(
                //         visible: item?.orderType.limitOrder.status ?? false,
                //         child: Column(
                //           children: [
                //             Text(
                //               "Limit Order",
                //               style: stylePTSansRegular(
                //                 color: ThemeColors.greyText,
                //                 fontSize: 13,
                //               ),
                //             ),
                //             const SpacerVertical(height: 3),
                //             Text(
                //               "${item?.orderType.limitOrder.price}",
                //               style: stylePTSansBold(
                //                 color: ThemeColors.white,
                //                 fontSize: 14,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //     const SpacerHorizontal(width: 40),
                //     Flexible(
                //       child: Visibility(
                //         visible: item?.orderType.targetPrice.status ?? false,
                //         child: Column(
                //           children: [
                //             Text(
                //               "Target Price",
                //               style: stylePTSansRegular(
                //                 color: ThemeColors.greyText,
                //                 fontSize: 13,
                //               ),
                //             ),
                //             const SpacerVertical(height: 3),
                //             Text(
                //               "${item?.orderType.targetPrice.price}",
                //               style: stylePTSansBold(
                //                 color: ThemeColors.white,
                //                 fontSize: 14,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //     const SpacerHorizontal(width: 40),
                //     Flexible(
                //       child: Visibility(
                //         visible: item?.orderType.stopLoss.status ?? false,
                //         child: Column(
                //           children: [
                //             Text(
                //               "Stop Loss",
                //               style: stylePTSansRegular(
                //                 color: ThemeColors.greyText,
                //                 fontSize: 13,
                //               ),
                //             ),
                //             const SpacerVertical(height: 3),
                //             Text(
                //               "${item?.orderType.stopLoss.price}",
                //               style: stylePTSansBold(fontSize: 14),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          Container(
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
        ],
      ),
    );
  }
}
