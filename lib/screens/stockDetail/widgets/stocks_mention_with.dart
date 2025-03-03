// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/stock_details_mentions_res.dart';
// import 'package:stocks_news_new/modals/stock_details_res.dart';
// import 'package:stocks_news_new/providers/stock_detail_provider.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';
// import 'package:stocks_news_new/widgets/theme_image_view.dart';

// import '../../../widgets/screen_title.dart';
// import '../../stockDetail/scanner.dart';
// import 'stockTopWidgets/common_heading.dart';

// class StockMentionWith extends StatelessWidget {
//   const StockMentionWith({super.key});

//   @override
//   Widget build(BuildContext context) {
//     List<TradingStock>? tradingStock =
//         context.watch<StockDetailProvider>().dataMentions?.tradingStock;
//     CompanyInfo? company =
//         context.watch<StockDetailProvider>().data?.companyInfo;
//     return Column(
//       children: [
//         const CommonHeadingStockDetail(),
//         ScreenTitle(
//           title: "Popular Stocks from ${company?.sector}",
//           // style: stylePTSansRegular(fontSize: 20),
//         ),
//         ListView.separated(
//           itemCount: tradingStock?.length ?? 0,
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           padding: EdgeInsets.only(top: 10.sp),
//           itemBuilder: (context, index) {
//             return StockMentionWithItem(up: index % 3 == 0, index: index);
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             // return const SpacerVertical(height: 12);
//             return Divider(
//               color: ThemeColors.greyBorder,
//               height: 20.sp,
//             );
//           },
//         ),
//         const SpacerVertical(height: Dimen.itemSpacing),
//       ],
//     );
//   }
// }

// class StockMentionWithItem extends StatelessWidget {
//   final bool up;
//   final int index;
//   const StockMentionWithItem({this.up = true, super.key, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     TradingStock? item =
//         context.watch<StockDetailProvider>().dataMentions?.tradingStock?[index];
//     if (item == null) {
//       return const SizedBox();
//     }
//     return InkWell(
//       onTap: () => Navigator.pushReplacement(
//         context,
//         StockDetail.path, // arguments: item.symbol,
//         arguments: {"slug": item.symbol},
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(0.sp),
//             child: Container(
//               padding: const EdgeInsets.all(5),
//               width: 43,
//               height: 43,
//               child: ThemeImageView(
//                 url: item.image ?? "",
//               ),
//             ),
//           ),
//           const SpacerHorizontal(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.symbol,
//                   style: stylePTSansBold(fontSize: 14),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SpacerVertical(height: 5),
//                 Text(
//                   item.name,
//                   style: stylePTSansRegular(
//                     color: ThemeColors.greyText,
//                     fontSize: 12,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           const SpacerHorizontal(width: 8),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   "${item.price}",
//                   style: stylePTSansBold(fontSize: 14),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       item.change?.toCurrency() ?? "",
//                       style: stylePTSansRegular(
//                         fontSize: 11,
//                         color: item.change! > 0
//                             ? ThemeColors.accent
//                             : ThemeColors.sos,
//                       ),
//                     ),
//                     Text(
//                       " (${item.changesPercentage?.toCurrency()}%)",
//                       style: stylePTSansRegular(
//                         fontSize: 11,
//                         color: item.change! > 0
//                             ? ThemeColors.accent
//                             : ThemeColors.sos,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
