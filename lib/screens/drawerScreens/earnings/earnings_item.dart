import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/Earnings_res.dart';
import 'package:stocks_news_new/providers/Earnings_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/tabs/insider/insider_content_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class EarningsItem extends StatelessWidget {
  final EarningsRes? data;
  final int index;
  final bool earnings;
//
  const EarningsItem({
    required this.data,
    required this.index,
    this.earnings = false,
    super.key,
  });

  void _onTap(context) {
    Navigator.pushNamed(
      context,
      StockDetails.path,
      arguments: {"slug": data?.symbol},
    );
  }

  @override
  Widget build(BuildContext context) {
    EarningsProvider provider = context.watch<EarningsProvider>();

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          StockDetails.path,
          // arguments: data.symbol,
          arguments: {"slug": data?.symbol},
        );
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _onTap(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.sp),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    width: 43,
                    height: 43,
                    child: ThemeImageView(url: data?.image ?? ""),
                  ),
                ),
              ),
              const SpacerHorizontal(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _onTap(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data?.symbol,
                        style: stylePTSansBold(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SpacerVertical(height: 5),
                      Text(
                        data?.name,
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
              ),
              const SpacerHorizontal(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${data?.price}",
                    style: stylePTSansBold(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SpacerHorizontal(width: 10),
              InkWell(
                onTap: () {
                  if (earnings) {
                    provider.setOpenIndexEarningsStocks(
                      provider.openIndexEarningsStocks == index ? -1 : index,
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
                    earnings
                        ? provider.openIndexEarningsStocks == index
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
              height: earnings
                  ? provider.openIndexEarningsStocks == index
                      ? null
                      : 0
                  : provider.openIndex == index
                      ? null
                      : 0,
              margin: EdgeInsets.only(
                top: earnings
                    ? provider.openIndexEarningsStocks == index
                        ? 10.sp
                        : 0
                    : provider.openIndex == index
                        ? 10.sp
                        : 0,
                bottom: earnings
                    ? provider.openIndexEarningsStocks == index
                        ? 10.sp
                        : 0
                    : provider.openIndex == index
                        ? 10.sp
                        : 0,
              ),
              child: Column(
                children: [
                  Visibility(
                    visible: data?.date != null,
                    child: InnerRowItem(
                      lable: "Date",
                      value: "${data?.date}",
                    ),
                  ),
                  Visibility(
                    visible: data?.exchangeShortName != null,
                    child: InnerRowItem(
                      lable: "Exchange",
                      value: "${data?.exchangeShortName}",
                    ),
                  ),
                  Visibility(
                    visible: data?.eps != null,
                    child: InnerRowItem(
                      lable: "EPS",
                      value: "${data?.eps}",
                    ),
                  ),
                  Visibility(
                    visible: data?.epsEstimated != null,
                    child: InnerRowItem(
                      lable: "EPS Estimated",
                      value: "${data?.epsEstimated}",
                    ),
                  ),
                  Visibility(
                    visible: data?.revenue != null,
                    child: InnerRowItem(
                      lable: "Revenue",
                      value: "${data?.revenue}",
                    ),
                  ),
                  Visibility(
                    visible: data?.revenueEstimated != null,
                    child: InnerRowItem(
                      lable: "Revenue Estimated",
                      value: "${data?.revenueEstimated}",
                    ),
                  ),
                  Visibility(
                    visible: data?.fiscalDateEnding != null,
                    child: InnerRowItem(
                      lable: "Fiscal Date Ending",
                      value: "${data?.fiscalDateEnding}",
                    ),
                  ),
                  Visibility(
                    visible: data?.updatedFromDate != null,
                    child: InnerRowItem(
                      lable: "Updated From Date",
                      value: "${data?.updatedFromDate}",
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
