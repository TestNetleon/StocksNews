import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/breakout_stocks_res.dart';
import 'package:stocks_news_new/providers/more_stocks_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../../stockDetail/index.dart';

class BreakOutStocksItem extends StatelessWidget {
  final BreakoutStocksRes data;
  final int index;

//
  const BreakOutStocksItem({
    required this.data,
    required this.index,
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
    MoreStocksProvider provider = context.watch<MoreStocksProvider>();

    return InkWell(
      onTap: () {
        Navigator.push(
          navigatorKey.currentContext!,
          MaterialPageRoute(builder: (_) => StockDetail(symbol: data.symbol)),
        );
      },
      child: Container(
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
                      data.price ?? "",
                      style: stylePTSansBold(fontSize: 18),
                    ),
                    const SpacerVertical(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        data.percentageChange > 0
                            ? Icon(
                                Icons.arrow_upward,
                                size: 14,
                                color: data.percentageChange > 0
                                    ? Colors.green
                                    : Colors.red,
                              )
                            : Icon(
                                Icons.arrow_downward_rounded,
                                size: 14,
                                color: data.percentageChange > 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    "${data.priceChange} (${data.percentageChange}%)",
                                style: stylePTSansRegular(
                                  fontSize: 14,
                                  color: data.percentageChange > 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SpacerHorizontal(width: 10),
                InkWell(
                  onTap: () {
                    provider.setOpenIndex(
                      provider.openIndex == index ? -1 : index,
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: ThemeColors.accent,
                    ),
                    margin: EdgeInsets.only(left: 8.sp),
                    padding: const EdgeInsets.all(3),
                    child: Icon(
                      provider.openIndex == index
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
                height: provider.openIndex == index ? null : 0,
                margin: EdgeInsets.only(
                  top: provider.openIndex == index ? 10.sp : 0,
                  bottom: provider.openIndex == index ? 10.sp : 0,
                ),
                child: Column(
                  children: [
                    Visibility(
                      visible: data.the50Day != null,
                      child: InnerRowItem(
                        label: "50-Day",
                        value: data.the50Day,
                      ),
                    ),
                    Visibility(
                      visible: data.the200Day != null,
                      child: InnerRowItem(
                        label: "200-Day",
                        value: data.the200Day,
                      ),
                    ),
                    InnerRowItem(
                      label: "Percent Moving Average",
                      value: "${data.percentageMovingAverage}%",
                      style: stylePTSansBold(
                          fontSize: 14,
                          color: data.percentageMovingAverage > 0
                              ? Colors.green
                              : Colors.red),
                      iconDataValue: Icons.arrow_upward,
                      colorValueIcon: data.percentageMovingAverage > 0
                          ? Colors.green
                          : Colors.red,
                    ),
                    InnerRowItem(
                      label: "Volume",
                      value: "${data.volume}",
                    ),
                    InnerRowItem(
                      label: "Average Volume",
                      value: "${data.avgVolume}",
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
