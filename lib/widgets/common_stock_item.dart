import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/top_trending_res.dart';
import 'package:stocks_news_new/screens/tabs/trending/menuButton/slidable_menu.dart';
import 'package:stocks_news_new/screens/tabs/trending/widgets/common_item_ui.dart';

class CommonStockItem extends StatelessWidget {
  final EdgeInsets? padding;
  final bool showPainter;
  final String? symbol;
  final String? name;
  final String? image;
  final String? price;
  final String? change;
  final num? changesPercentage;
  final num? isAlertAdded;
  final num? isWatchlistAdded;

  const CommonStockItem({
    super.key,
    this.padding,
    this.symbol,
    this.image,
    this.name,
    this.price,
    this.change,
    this.changesPercentage,
    this.showPainter = false,
    this.isAlertAdded,
    this.isWatchlistAdded,
  });

  @override
  Widget build(BuildContext context) {
    return SlidableMenuWidget(
      // index: index,
      alertForBullish: isAlertAdded?.toInt() ?? 0,
      watlistForBullish: isWatchlistAdded?.toInt() ?? 0,
      onClickAlert: () {},
      onClickWatchlist: () {},
      child: CommonItemUi(
        data: TopTrendingDataRes(
            image: image,
            symbol: symbol ?? "",
            isAlertAdded: isAlertAdded ?? 0,
            isWatchlistAdded: isWatchlistAdded ?? 0,
            name: name ?? "",
            change: change,
            changePercentage: changesPercentage,
            price: price),
      ),
    );
    // return SlidableMenuWidget(
    //   alertForBullish: isAlertAdded?.toInt() ?? 0,
    //   watlistForBullish: isWatchlistAdded?.toInt() ?? 0,
    //   onClickAlert: () {},
    //   onClickWatchlist: () {},
    //   child: InkWell(
    //     borderRadius: BorderRadius.circular(5),
    //     onTap: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => StockDetail(symbol: symbol ?? ""),
    //         ),
    //       );
    //     },
    //     child: Stack(
    //       children: [
    //         Container(
    //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //           decoration: BoxDecoration(
    //             color: ThemeColors.background,
    //             borderRadius: BorderRadius.circular(5),
    //           ),
    //           child: Row(
    //             children: [
    //               ClipRRect(
    //                 borderRadius: BorderRadius.circular(0),
    //                 child: Container(
    //                   padding: const EdgeInsets.all(5),
    //                   width: 48,
    //                   height: 48,
    //                   child: CachedNetworkImagesWidget(image),
    //                 ),
    //               ),
    //               const SpacerHorizontal(width: 12),
    //               Expanded(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Text(
    //                       symbol ?? "",
    //                       style: styleGeorgiaBold(fontSize: 18),
    //                       maxLines: 1,
    //                       overflow: TextOverflow.ellipsis,
    //                     ),
    //                     const SpacerVertical(height: 5),
    //                     Text(
    //                       name ?? "",
    //                       style: styleGeorgiaRegular(
    //                         color: ThemeColors.greyText,
    //                         fontSize: 12,
    //                       ),
    //                       maxLines: 2,
    //                       overflow: TextOverflow.ellipsis,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               const SpacerHorizontal(width: 12),
    //               // Container(
    //               //   margin: EdgeInsets.only(right: 8.sp, left: 8.sp),
    //               //   width: 80.sp,
    //               //   height: 26.sp,
    //               //   child: LineChart(_avgData()),
    //               // ),
    //               Column(
    //                 crossAxisAlignment: CrossAxisAlignment.end,
    //                 children: [
    //                   Text(price ?? "", style: stylePTSansBold(fontSize: 18)),
    //                   const SpacerVertical(height: 5),
    //                   RichText(
    //                     text: TextSpan(
    //                       children: [
    //                         TextSpan(
    //                           text:
    //                               "${change ?? ""} (${changesPercentage ?? ""}%)",
    //                           style: stylePTSansRegular(
    //                             fontSize: 14,
    //                             color: (changesPercentage ?? 0) > 0
    //                                 ? Colors.green
    //                                 : Colors.red,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               )
    //             ],
    //           ),
    //         ),
    //         if (showPainter)
    //           Positioned(
    //             bottom: 0,
    //             left: 0,
    //             right: 0,
    //             child: CustomPaint(
    //               painter: HalfCirclePainter(
    //                 color: (changesPercentage ?? 0) > 0
    //                     ? Colors.green.withOpacity(0.1)
    //                     : Colors.red.withOpacity(0.1),
    //               ),
    //               child: Container(
    //                 height: 35,
    //               ),
    //             ),
    //           ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
