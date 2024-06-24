import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/gainers_losers_res.dart';
import 'package:stocks_news_new/providers/more_stocks_provider.dart';
import 'package:stocks_news_new/route/my_app.dart';
import 'package:stocks_news_new/screens/tabs/insider/insider_content_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../../stockDetail/index.dart';

class GainerLoserItem extends StatelessWidget {
  final GainersLosersDataRes data;
  final int index;
  final bool losers;
  final bool marketData;

//
  const GainerLoserItem({
    required this.data,
    required this.index,
    this.losers = false,
    this.marketData = false,
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
      onTap: marketData
          ? null
          : () {
              Navigator.push(
                navigatorKey.currentContext!,
                MaterialPageRoute(
                  builder: (_) => StockDetail(symbol: data.symbol),
                ),
              );
            },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: marketData ? null : () => _onTap(context),
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
                child: InkWell(
                  onTap: !marketData ? null : () => _onTap(context),
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
              ),
              const SpacerHorizontal(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(data.price ?? "", style: stylePTSansBold(fontSize: 14)),
                  const SpacerVertical(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      data.displayPercentage > 0
                          ? Icon(
                              Icons.arrow_upward,
                              size: 14,
                              color: data.displayPercentage > 0
                                  ? Colors.green
                                  : Colors.red,
                            )
                          : Icon(
                              Icons.arrow_downward_rounded,
                              size: 14,
                              color: data.displayPercentage > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "${data.displayChange} (${data.displayPercentage.toCurrency()}%)",
                              style: stylePTSansRegular(
                                fontSize: 11,
                                color: data.displayPercentage > 0
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
                  if (losers) {
                    provider.setOpenIndexLosers(
                      provider.openIndexLosers == index ? -1 : index,
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
                    losers
                        ? provider.openIndexLosers == index
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
              height: losers
                  ? provider.openIndexLosers == index
                      ? null
                      : 0
                  : provider.openIndex == index
                      ? null
                      : 0,
              margin: EdgeInsets.only(
                top: losers
                    ? provider.openIndexLosers == index
                        ? 10.sp
                        : 0
                    : provider.openIndex == index
                        ? 10.sp
                        : 0,
                bottom: losers
                    ? provider.openIndexLosers == index
                        ? 10.sp
                        : 0
                    : provider.openIndex == index
                        ? 10.sp
                        : 0,
              ),
              child: Column(
                children: [
                  Visibility(
                    visible: marketData && data.open != null,
                    child: InnerRowItem(
                      lable: "Open",
                      value: data.open,
                    ),
                  ),
                  InnerRowItem(
                    lable: "Previous Close",
                    value: data.previousClose,
                  ),
                  InnerRowItem(
                    lable: marketData ? "Intraday Range" : "Range",
                    value: data.range,
                  ),
                  InnerRowItem(
                    lable: "Volume",
                    value: "${data.volume}",
                  ),
                  InnerRowItem(
                    lable: "Average Volume",
                    value: "${data.avgVolume}",
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
