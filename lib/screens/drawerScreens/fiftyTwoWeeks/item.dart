import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/fifty_two_weeks_res.dart';
import 'package:stocks_news_new/providers/fifty_two_weeks_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/tabs/insider/insider_content_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class FiftyTwoWeeksItem extends StatelessWidget {
  final FiftyTwoWeeksRes data;
  final int index;
  final bool fiftyTwoWeeks;
//
  const FiftyTwoWeeksItem({
    required this.data,
    required this.index,
    this.fiftyTwoWeeks = false,
    super.key,
  });

  void _onTap(context) {
    Navigator.pushNamed(
      context,
      StockDetails.path,
      arguments: {"slug": data.symbol},
    );
  }

  @override
  Widget build(BuildContext context) {
    FiftyTwoWeeksProvider provider = context.watch<FiftyTwoWeeksProvider>();

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _onTap(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.sp),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 43,
                  height: 43,
                  child: ThemeImageView(url: data.image ?? ""),
                ),
              ),
            ),
            const SpacerHorizontal(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => _onTap(context),
                    child: Text(
                      data.symbol,
                      style: stylePTSansBold(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    data.name,
                    style: stylePTSansRegular(
                      color: ThemeColors.greyText,
                      fontSize: 12,
                    ),
                    maxLines: 2,
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
                  "${data.price}",
                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVertical(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    data.changesPercentage > 0
                        ? Icon(
                            Icons.arrow_upward,
                            size: 14,
                            color: data.changesPercentage > 0
                                ? Colors.green
                                : Colors.red,
                          )
                        : Icon(
                            Icons.arrow_downward_rounded,
                            size: 14,
                            color: data.changesPercentage > 0
                                ? Colors.green
                                : Colors.red,
                          ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${data.change} (${data.changesPercentage}%)",
                            style: stylePTSansRegular(
                              fontSize: 11,
                              color: data.changesPercentage > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Text(
                //   "${data.changesPercentage.toString()}%",
                //   style: stylePTSansRegular(
                //     fontSize: 12,
                //     color: (data.changesPercentage ?? 0) > 0
                //         ? ThemeColors.accent
                //         : Colors.red,
                //   ),
                // ),
              ],
            ),
            const SpacerHorizontal(width: 10),
            InkWell(
              onTap: () {
                if (fiftyTwoWeeks) {
                  provider.setOpenIndexFiftyTwoWeeks(
                    provider.openIndexFiftyTwoWeeks == index ? -1 : index,
                  );
                } else {
                  provider.setOpenIndex(
                    provider.openIndex == index ? -1 : index,
                  );
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: ThemeColors.accent,
                ),
                margin: EdgeInsets.only(left: 8.sp),
                padding: const EdgeInsets.all(3),
                child: Icon(
                  fiftyTwoWeeks
                      ? provider.openIndexFiftyTwoWeeks == index
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded
                      : provider.openIndex == index
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                  size: 16,
                ),
              ),
            )
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: fiftyTwoWeeks
                ? provider.openIndexFiftyTwoWeeks == index
                    ? null
                    : 0
                : provider.openIndex == index
                    ? null
                    : 0,
            margin: EdgeInsets.only(
              top: fiftyTwoWeeks
                  ? provider.openIndexFiftyTwoWeeks == index
                      ? 10.sp
                      : 0
                  : provider.openIndex == index
                      ? 10.sp
                      : 0,
              bottom: fiftyTwoWeeks
                  ? provider.openIndexFiftyTwoWeeks == index
                      ? 10.sp
                      : 0
                  : provider.openIndex == index
                      ? 10.sp
                      : 0,
            ),
            child: Column(
              children: [
                InnerRowItem(
                  lable: "52-Week High",
                  value: "${data.yearHigh}",
                ),
                InnerRowItem(
                  lable: "52-Week Low",
                  value: "${data.yearLow}",
                ),
                InnerRowItem(
                    lable: "Previous Close", value: "${data.previousClose}"),
                InnerRowItem(
                  lable: "Intraday Range",
                  value: "${data.dayLow}-${data.dayHigh}",
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
