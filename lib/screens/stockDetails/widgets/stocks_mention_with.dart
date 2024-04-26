import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/stock_details_mentions_res.dart';
import 'package:stocks_news_new/modals/stock_details_res.dart';
import 'package:stocks_news_new/providers/stock_detail_provider.dart';
import 'package:stocks_news_new/screens/stockDetails/stock_details.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/screen_title.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_verticle.dart';
import 'package:stocks_news_new/widgets/theme_image_view.dart';

class StockMentionWith extends StatelessWidget {
  const StockMentionWith({super.key});

  @override
  Widget build(BuildContext context) {
    List<TradingStock>? tradingStock =
        context.watch<StockDetailProvider>().dataMentions?.tradingStock;
    CompanyInfo? companyInfo =
        context.watch<StockDetailProvider>().data?.companyInfo;
    return Column(
      children: [
        ScreenTitle(
          title: "Popular Stocks From ${companyInfo?.sector ?? "Sector"}",
          // style: stylePTSansRegular(fontSize: 20),
        ),
        ListView.separated(
          itemCount: tradingStock?.length ?? 0,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(top: 12.sp),
          itemBuilder: (context, index) {
            return StockMentionWithItem(up: index % 3 == 0, index: index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SpacerVerticel(height: 12);
          },
        ),
        const SpacerVerticel(height: Dimen.itemSpacing),
      ],
    );
  }
}

class StockMentionWithItem extends StatelessWidget {
  final bool up;
  final int index;
  const StockMentionWithItem({this.up = true, super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    TradingStock? item =
        context.watch<StockDetailProvider>().dataMentions?.tradingStock?[index];
    if (item == null) {
      return const SizedBox();
    }
    return InkWell(
      onTap: () => Navigator.pushReplacementNamed(context, StockDetails.path,
          arguments: item.symbol),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25.sp),
            child: Container(
              padding: EdgeInsets.all(5.sp),
              width: 43.sp,
              height: 43.sp,
              child: ThemeImageView(
                url: item.image ?? "",
              ),
            ),
          ),
          const SpacerHorizontal(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.symbol,
                  style: stylePTSansBold(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SpacerVerticel(height: 5),
                Text(
                  item.name,
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
          const SpacerHorizontal(width: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${item.price}",
                style: stylePTSansBold(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SpacerHorizontal(width: 8),
              Text(
                "${item.change! > 0 ? '+' : ''}${item.change?.toCurrency()}",
                style: stylePTSansRegular(
                  fontSize: 12,
                  color:
                      item.change! > 0 ? ThemeColors.accent : ThemeColors.sos,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
