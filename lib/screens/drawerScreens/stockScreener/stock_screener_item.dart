import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_screener_res.dart';
import 'package:stocks_news_new/providers/stock_screener_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/screens/tabs/insider/insider_content_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class StockScreenerItem extends StatelessWidget {
  final List<Result>? data;
  final int index;
  final bool stockScreener;
//
  const StockScreenerItem({
    required this.data,
    required this.index,
    this.stockScreener = false,
    super.key,
  });

  void _onTap(context) {
    Navigator.pushNamed(
      context,
      StockDetails.path,
      arguments: {"slug": data?[index].symbol},
    );
  }

  @override
  Widget build(BuildContext context) {
    StockScreenerProvider provider = context.watch<StockScreenerProvider>();

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => _onTap(context),
                    child: Text(
                      data?[index].symbol,
                      style: stylePTSansBold(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SpacerVertical(height: 5),
                  Text(
                    data?[index].companyName,
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
                  "${data?[index].price}",
                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SpacerHorizontal(width: 10),
            InkWell(
              onTap: () {
                if (stockScreener) {
                  provider.setOpenIndexStockScreenerStocks(
                    provider.openIndexStockScreenerStocks == index ? -1 : index,
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
                  stockScreener
                      ? provider.openIndexStockScreenerStocks == index
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
            height: stockScreener
                ? provider.openIndexStockScreenerStocks == index
                    ? null
                    : 0
                : provider.openIndex == index
                    ? null
                    : 0,
            margin: EdgeInsets.only(
              top: stockScreener
                  ? provider.openIndexStockScreenerStocks == index
                      ? 10.sp
                      : 0
                  : provider.openIndex == index
                      ? 10.sp
                      : 0,
              bottom: stockScreener
                  ? provider.openIndexStockScreenerStocks == index
                      ? 10.sp
                      : 0
                  : provider.openIndex == index
                      ? 10.sp
                      : 0,
            ),
            child: Column(
              children: [
                InnerRowItem(
                  lable: "Sector",
                  value: "${data?[index].sector}",
                ),
                InnerRowItem(
                  lable: "Industry",
                  value: "${data?[index].industry}",
                ),
                InnerRowItem(
                  lable: "Country",
                  value: "${data?[index].country}",
                ),
                InnerRowItem(
                  lable: "Beta",
                  value: "${data?[index].beta}",
                ),
                InnerRowItem(
                  lable: "Is Etf",
                  value: "${data?[index].isEtf}",
                ),
                InnerRowItem(
                  lable: "is Fund",
                  value: "${data?[index].isFund}",
                ),
                InnerRowItem(
                  lable: "Is Actively Trading",
                  value: "${data?[index].isActivelyTrading}",
                ),
                InnerRowItem(
                  lable: "Market Cap",
                  value: "${data?[index].marketCap}",
                ),
                InnerRowItem(
                  lable: "Volume",
                  value: "${data?[index].volume}",
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
