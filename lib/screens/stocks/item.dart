import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stocks_res.dart';
import 'package:stocks_news_new/providers/all_stocks_provider.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/screens/tabs/insider/insiderDetails/insider_details_item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

import '../stockDetail/index.dart';

class StocksItemAll extends StatelessWidget {
  final AllStocks? data;
  final int index;
  const StocksItemAll({super.key, this.data, required this.index});
  void _onTap(context) {
    Navigator.push(
      navigatorKey.currentContext!,
      MaterialPageRoute(builder: (_) => StockDetail(symbol: data!.symbol)),
    );
  }

//
  @override
  Widget build(BuildContext context) {
    AllStocksProvider provider = context.watch<AllStocksProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: ThemeColors.background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => _onTap(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.sp),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    width: 48,
                    height: 48,
                    child: ThemeImageView(url: data?.image ?? ""),
                  ),
                ),
              ),
              const SpacerHorizontal(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => _onTap(context),
                      child: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        data?.symbol ?? "",
                        style: stylePTSansRegular(
                          fontSize: 18,
                          color: ThemeColors.white,
                        ),
                      ),
                    ),
                    const SpacerVertical(height: 5),
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
              const SpacerHorizontal(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data?.price ?? "",
                    style: stylePTSansBold(fontSize: 18),
                  ),
                  const SpacerVertical(height: 2),
                  RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "${data?.displayChange} (${data?.changesPercentage?.toCurrency()}%)",
                          style: stylePTSansRegular(
                            fontSize: 14,
                            color: (data?.changesPercentage ?? 0) > 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SpacerHorizontal(width: 10),
              InkWell(
                onTap: () =>
                    provider.open(provider.openIndex == index ? -1 : index),
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
              ),
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
                  InnerRowItem(
                    label: "Exchange",
                    value: data?.exchangeShortName,
                  ),
                  InnerRowItem(
                    label: "Last Close",
                    value: data?.previousClose,
                  ),
                  InnerRowItem(
                    label: "Open",
                    value: data?.open,
                  ),
                  InnerRowItem(
                    label: "Day High",
                    value: data?.dayHigh,
                  ),
                  InnerRowItem(
                    label: "Day Low",
                    value: data?.dayLow,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
