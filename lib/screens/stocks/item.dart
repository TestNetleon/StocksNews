import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stocks_res.dart';
import 'package:stocks_news_new/providers/all_stocks_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class StocksItemAll extends StatelessWidget {
  final AllStocks? data;
  final int index;
  const StocksItemAll({super.key, this.data, required this.index});
//
  @override
  Widget build(BuildContext context) {
    AllStocksProvider provider = context.watch<AllStocksProvider>();
    return Column(
      children: [
        InkWell(
          onTap: () => provider.open(provider.openIndex == index ? -1 : index),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, StockDetails.path,
                      arguments: data?.symbol ?? ""),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25.sp),
                        child: Container(
                          padding: EdgeInsets.all(5.sp),
                          width: 43.sp,
                          height: 43.sp,
                          child: ThemeImageView(url: data?.image ?? ""),
                        ),
                      ),
                      const SpacerHorizontal(width: 3),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              data?.symbol ?? "",
                              style: stylePTSansRegular(
                                fontSize: 12,
                                color: ThemeColors.white,
                              ),
                            ),
                            Text(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              data?.name ?? "",
                              style: stylePTSansRegular(
                                fontSize: 12,
                                color: ThemeColors.greyText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // const SpacerHorizontal(width: 10),
              // Expanded(
              //   child: Text(
              //     maxLines: 1,
              //     data?.exchangeShortName ?? "",
              //     style: stylePTSansRegular(
              //       fontSize: 12,
              //       color: ThemeColors.white,
              //     ),
              //   ),
              // ),
              const SpacerHorizontal(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maxLines: 2,
                      "${data?.price}",
                      overflow: TextOverflow.ellipsis,
                      style: stylePTSansRegular(
                          fontSize: 12, color: ThemeColors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    (data?.change ?? 0) > 0
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    size: 15.sp,
                                    color: (data?.change ?? 0) > 0
                                        ? ThemeColors.accent
                                        : Colors.red,
                                  ),
                                  Flexible(
                                    child: Text(
                                      maxLines: 2,
                                      "${data?.change?.toCurrency()} (${data?.changesPercentage?.toCurrency()}%)",
                                      style: stylePTSansRegular(
                                        fontSize: 12,
                                        color: (data?.change ?? 0) > 0
                                            ? ThemeColors.accent
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Text(
                              //   maxLines: 2,
                              //   "${data?.changesPercentage?.toCurrency()}%",
                              //   style: stylePTSansRegular(
                              //     fontSize: 12,
                              //     color: (data?.changesPercentage ?? 0) > 0
                              //         ? ThemeColors.accent
                              //         : Colors.red,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: ThemeColors.accent,
                          ),
                          margin: EdgeInsets.only(left: 8.sp),
                          padding: const EdgeInsets.all(3),
                          child: Icon(
                            provider.openIndex == index
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                            size: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: provider.openIndex == index ? null : 0,
            margin: EdgeInsets.only(
              top: provider.openIndex == index ? 10.sp : 0,
              bottom: provider.openIndex == index ? 10.sp : 0,
            ),
            child: Column(
              children: [
                InnerRowItem(
                  lable: "Exchange",
                  value: data?.exchangeShortName,
                ),
                InnerRowItem(
                  lable: "Last Close",
                  value: data?.previousClose,
                ),
                InnerRowItem(
                  lable: "Open",
                  value: data?.open,
                ),
                InnerRowItem(
                  lable: "Day High",
                  value: data?.dayHigh,
                ),
                InnerRowItem(
                  lable: "Day Low",
                  value: data?.dayLow,
                ),
              ],
            ),
          ),
        ),
        const SpacerVerticel(height: Dimen.itemSpacing),
      ],
    );
  }
}
