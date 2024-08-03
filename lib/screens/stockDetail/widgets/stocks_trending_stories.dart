// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/home_insider_res.dart';
// import 'package:stocks_news_new/providers/stock_detail_provider.dart';
// import 'package:stocks_news_new/screens/tabs/news/news_item.dart';
// import 'package:stocks_news_new/utils/colors.dart';

// import '../../../widgets/disclaimer_widget.dart';
// import 'stockTopWidgets/common_heading.dart';

// class StocksTrendingStories extends StatelessWidget {
//   const StocksTrendingStories({super.key});
// //
//   @override
//   Widget build(BuildContext context) {
//     StockDetailProvider provider = context.watch<StockDetailProvider>();
//     List<News>? newsPost = provider.dataMentions?.newsPost;
//     // KeyStats? keyStats = provider.data?.keyStats;
//     if (newsPost == null || newsPost.isEmpty) return const SizedBox();
//     return Column(
//       children: [
//         // ScreenTitle(
//         //   title: "${keyStats?.name} (${keyStats?.symbol})",
//         //   // style: stylePTSansRegular(fontSize: 20),
//         // ),
//         const CommonHeadingStockDetail(),

//         ListView.separated(
//           itemCount: newsPost.length,
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           padding: EdgeInsets.only(top: 12.sp),
//           itemBuilder: (context, index) {
//             News news = newsPost[index];

//             if (index == 0) {
//               return NewsItemSeparated(
//                   news: news, showCategory: news.authors?.isEmpty == true);
//             }
//             return NewsItem(
//                 news: news, showCategory: news.authors?.isEmpty == true);
//           },
//           separatorBuilder: (BuildContext context, int index) {
//             return Divider(
//               color: ThemeColors.greyBorder,
//               height: 20.sp,
//             );
//           },
//         ),
//         if (provider.extra?.disclaimer != null && newsPost.isNotEmpty)
//           DisclaimerWidget(
//             data: provider.extra!.disclaimer!,
//           ),
//       ],
//     );
//   }
// }

// // class StockMentionWithItem extends StatelessWidget {
// //   final bool up;
// //   const StockMentionWithItem({this.up = true, super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         ClipRRect(
// //           borderRadius: BorderRadius.circular(25.sp),
// //           child: Container(
// //             padding: EdgeInsets.all(5.sp),
// //             width: 43.sp,
// //             height: 43.sp,
// //             child: Image.asset(
// //               Images.userPlaceholder,
// //               fit: BoxFit.cover,
// //             ),
// //           ),
// //         ),
// //         const SpacerHorizontal(width: 12),
// //         Expanded(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 "TSLA",
// //                 style: stylePTSansBold(fontSize: 14),
// //                 maxLines: 1,
// //                 overflow: TextOverflow.ellipsis,
// //               ),
// //               const SpacerVertical(height: 5),
// //               Text(
// //                 "Tesla Inc",
// //                 style: stylePTSansRegular(
// //                   color: ThemeColors.greyText,
// //                   fontSize: 12,
// //                 ),
// //                 maxLines: 2,
// //                 overflow: TextOverflow.ellipsis,
// //               ),
// //             ],
// //           ),
// //         ),
// //         const SpacerHorizontal(width: 8),
// //         Text(
// //           "VERY BULLISH",
// //           style: stylePTSansRegular(fontSize: 10, color: ThemeColors.accent),
// //           maxLines: 1,
// //           overflow: TextOverflow.ellipsis,
// //         ),
// //         const SpacerHorizontal(width: 8),
// //         Text(
// //           "\$201.99",
// //           style: stylePTSansBold(fontSize: 14),
// //           maxLines: 1,
// //           overflow: TextOverflow.ellipsis,
// //         ),
// //         const SpacerHorizontal(width: 8),
// //         Text(
// //           "+0.00%",
// //           style: stylePTSansRegular(
// //             fontSize: 12,
// //             color: ThemeColors.accent,
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
