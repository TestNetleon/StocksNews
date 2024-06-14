// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/stock_details_mentions_res.dart';
// import 'package:stocks_news_new/providers/stock_detail_provider.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/screen_title.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import '../../../widgets/disclaimer_widget.dart';
// import '../../../widgets/error_display_common.dart';
// import 'stockTopWidgets/common_heading.dart';

// class StocksMentions extends StatelessWidget {
//   const StocksMentions({super.key});
// //
//   @override
//   Widget build(BuildContext context) {
//     StockDetailProvider provider = context.watch<StockDetailProvider>();
//     // KeyStats? keyStats = provider.data?.keyStats;
//     List<Mentions>? mentions = provider.dataMentions?.mentions;

//     if (provider.mentionLoading) {
//       return const Center(
//         child: CircularProgressIndicator(
//           color: ThemeColors.accent,
//         ),
//       );
//     }
//     if (!provider.mentionLoading && mentions?.isEmpty == true) {
//       return Center(
//         child: ErrorDisplayWidget(
//           smallHeight: true,
//           error: "No mentions found.",
//           onRefresh: () async {
//             provider.getStockDetailsMentions(
//               symbol: provider.data?.keyStats?.symbol ?? "",
//               sectorSlug: provider.data?.companyInfo?.sectorSlug ?? '',
//               price: provider.data?.keyStats?.priceWithoutCur,
//             );
//           },
//         ),
//         // child: NoDataCustom(error: 'No mentions data found.'),
//       );
//     }

//     return Column(
//       children: [
//         const CommonHeadingStockDetail(),
//         ScreenTitle(
//           // title: "News Mentions",
//           // title: "${keyStats?.name} (${keyStats?.symbol})",
//           subTitle: provider.dataMentions?.mentionText,
//         ),
//         SizedBox(
//           height: 130.sp,
//           child: PieChart(
//             PieChartData(
//               sections: List.generate(
//                 mentions?.length ?? 0,
//                 (index) => PieChartSectionData(
//                   color: mentions?[index].color,
//                   value: mentions?[index].mentionCount?.toDouble(),
//                   title: '',
//                   radius: 6,
//                 ),
//               ),
//               borderData: FlBorderData(show: false),
//               sectionsSpace: 5.sp,
//               centerSpaceRadius: 60.sp,
//             ),
//           ),
//         ),
//         ListView.separated(
//           padding: EdgeInsets.only(top: 20.sp),
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemBuilder: (context, index) {
//             return Row(
//               children: [
//                 CircleAvatar(
//                   backgroundColor: mentions?[index].color,
//                   radius: 5,
//                 ),
//                 const SpacerHorizontal(width: 10),
//                 Expanded(
//                   child: Wrap(
//                     children: [
//                       Text(
//                         mentions?[index].website ?? "",
//                         style: stylePTSansBold(fontSize: 14),
//                       ),
//                       const SpacerHorizontal(width: 20),
//                       Text(
//                         "${mentions?[index].mentionCount}",
//                         style: stylePTSansBold(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             );
//           },
//           separatorBuilder: (context, index) {
//             return const SpacerVertical(height: 12);
//           },
//           itemCount: mentions?.length ?? 0,
//         ),
//         if (provider.extra?.disclaimer != null &&
//             (!provider.mentionLoading && mentions?.isNotEmpty == true))
//           DisclaimerWidget(
//             data: provider.extra!.disclaimer!,
//           ),
//       ],
//     );
//   }
// }
