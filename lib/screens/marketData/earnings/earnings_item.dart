import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stocks_news_new/modals/earnings_res.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../../stockDetail/index.dart';

class EarningsItem extends StatelessWidget {
  final EarningsRes data;
  final bool isOpen;
  final Function() onTap;

  const EarningsItem({
    required this.data,
    required this.isOpen,
    required this.onTap,
    super.key,
  });

  void _onTap(context) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => StockDetail(symbol: data.symbol)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: ThemeColors.background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => _onTap(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.sp),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    width: 48,
                    height: 48,
                    child: ThemeImageView(url: data.image ?? ""),
                  ),
                ),
              ),
              const SpacerHorizontal(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () => _onTap(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.symbol,
                        style: stylePTSansBold(fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
              ),
              const SpacerHorizontal(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${data.date}",
                    style: stylePTSansBold(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SpacerHorizontal(width: 10),
              InkWell(
                onTap: onTap,
                child: Container(
                  decoration: const BoxDecoration(
                    color: ThemeColors.accent,
                  ),
                  margin: EdgeInsets.only(left: 8.sp),
                  padding: const EdgeInsets.all(3),
                  child: Icon(
                    isOpen
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
              height: isOpen ? null : 0,
              margin: EdgeInsets.only(
                top: isOpen ? 10.sp : 0,
                bottom: isOpen ? 10.sp : 0,
              ),
              child: Column(
                children: [
                  Visibility(
                    visible: data.exchangeShortName != null,
                    child: InnerRowItem(
                      label: "Price",
                      value: "${data.price}",
                    ),
                  ),
                  Visibility(
                    visible: data.exchangeShortName != null,
                    child: InnerRowItem(
                      label: "Price Change",
                      value: "${data.priceChange}",
                    ),
                  ),
                  Visibility(
                    visible: data.exchangeShortName != null,
                    child: InnerRowItem(
                      label: "Percentage Change",
                      value: "${data.percentageChange}%",
                    ),
                  ),
                  InnerRowItem(
                    label: "Exchange",
                    value: "${data.exchangeShortName ?? "N/A"}",
                  ),
                  InnerRowItem(
                    label: "EPS",
                    value: "${data.eps ?? "N/A"}",
                  ),
                  InnerRowItem(
                    label: "EPS Estimated",
                    value: "${data.epsEstimated ?? "N/A"}",
                  ),
                  InnerRowItem(
                    label: "Revenue",
                    value: "${data.revenue ?? "N/A"}",
                  ),
                  InnerRowItem(
                    label: "Revenue Estimated",
                    value: "${data.revenueEstimated ?? "N/A"}",
                  ),
                  InnerRowItem(
                    label: "Fiscal Date Ending",
                    value: "${data.fiscalDateEnding ?? "N/A"}",
                  ),
                  InnerRowItem(
                    label: "Updated From Date",
                    value: "${data.updatedFromDate ?? "N/A"}",
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
