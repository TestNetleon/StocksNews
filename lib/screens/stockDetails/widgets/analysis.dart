// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/analysis_res.dart';
// import 'package:stocks_news_new/providers/stock_detail_provider.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/utils/utils.dart';
// import 'package:stocks_news_new/widgets/base_ui_container.dart';
// import 'package:stocks_news_new/widgets/screen_title.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import '../../../widgets/disclaimer_widget.dart';
// import '../../../widgets/theme_image_view.dart';
// import '../../stockDetail/index.dart';
// import 'stockTopWidgets/common_heading.dart';

// //
// class Analysis extends StatefulWidget {
//   final String symbol;
//   const Analysis({super.key, required this.symbol});

//   @override
//   State<Analysis> createState() => _AnalysisState();
// }

// class _AnalysisState extends State<Analysis> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _getData();
//     });
//   }

//   _getData() {
//     StockDetailProvider provider = context.read<StockDetailProvider>();
//     if (provider.analysisRes == null) {
//       provider.analysisData(symbol: widget.symbol);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     StockDetailProvider provider = context.watch<StockDetailProvider>();

//     return BaseUiContainer(
//       isLoading: provider.analysisLoading && provider.analysisRes == null,
//       hasData: !provider.analysisLoading && provider.analysisRes != null,
//       showPreparingText: true,
//       child: Column(
//         children: [
//           const CommonHeadingStockDetail(),
//           ScreenTitle(
//             // title: "Stock Analysis",
//             subTitle: provider.analysisRes?.text,
//           ),
//           const AlalysisBase(),

//           // provider.analysisLoading && provider.analysisRes == null
//           //     ? const Loading(text: 'Fetching stock analysis data...')
//           //     //  Row(
//           //     //     mainAxisAlignment: MainAxisAlignment.center,
//           //     //     children: [
//           //     //       const CircularProgressIndicator(
//           //     //         color: ThemeColors.accent,
//           //     //       ),
//           //     //       const SpacerHorizontal(width: 5),
//           //     //       Flexible(
//           //     //         child: Text(
//           //     //           "Fetching stock analysis data...",
//           //     //           style: stylePTSansRegular(color: ThemeColors.accent),
//           //     //         ),
//           //     //       ),
//           //     //     ],
//           //     //   )
//           //     : provider.data != null
//           //         ? const AlalysisBase()
//           //         : Text(
//           //             "No analysis data found",
//           //             style: stylePTSansBold(),
//           //           ),
//         ],
//       ),
//     );
//   }
// }

// class AlalysisBase extends StatelessWidget {
//   const AlalysisBase({super.key});

//   @override
//   Widget build(BuildContext context) {
//     StockDetailProvider provider = context.watch<StockDetailProvider>();

//     AnalysisRes? analysisRes = context.watch<StockDetailProvider>().analysisRes;

//     return Column(
//       children: [
//         AnalysisItem(
//           label: "Overall",
//           value: analysisRes?.overallPercent.toDouble(),
//         ),
//         const SpacerVertical(height: Dimen.itemSpacing),
//         AnalysisItem(
//           label: "Fundamental",
//           value: analysisRes?.fundamentalPercent.toDouble(),
//         ),
//         const SpacerVertical(height: Dimen.itemSpacing),
//         AnalysisItem(
//           label: "Short Technical",
//           value: analysisRes?.shortTermPercent.toDouble(),
//         ),
//         const SpacerVertical(height: Dimen.itemSpacing),
//         AnalysisItem(
//           label: "Long Technical",
//           value: analysisRes?.longTermPercent.toDouble(),
//         ),
//         const SpacerVertical(height: Dimen.itemSpacing),
//         AnalysisItem(
//           label: "Analysis Ranking",
//           value: analysisRes?.analystRankingPercent.toDouble(),
//         ),
//         const SpacerVertical(height: Dimen.itemSpacing),
//         AnalysisItem(
//           label: "Valuation",
//           value: analysisRes?.valuationPercent.toDouble(),
//         ),
//         const SpacerVertical(height: Dimen.itemSpacing),

//         // Row(
//         //   children: [
//         //     Expanded(
//         //       child: AnalysisItem(
//         //         label: "Overall",
//         //         value: analysisRes?.overallPercent.toDouble(),
//         //       ),
//         //     ),
//         //     const SpacerHorizontal(width: Dimen.padding),
//         //     // Expanded(child: AnalysisItemLocked(label: "Fundamental")),
//         //     Expanded(
//         //       child: AnalysisItem(
//         //         label: "Fundamental",
//         //         value: analysisRes?.fundamentalPercent.toDouble(),
//         //       ),
//         //     ),
//         //   ],
//         // ),
//         // const SpacerVertical(height: Dimen.itemSpacing),
//         // Row(
//         //   children: [
//         //     // Expanded(child: AnalysisItemLocked(label: "Short Technical")),
//         //     Expanded(
//         //       child: AnalysisItem(
//         //         label: "Short Technical",
//         //         value: analysisRes?.shortTermPercent.toDouble(),
//         //       ),
//         //     ),
//         //     const SpacerHorizontal(width: Dimen.padding),
//         //     // Expanded(child: AnalysisItemLocked(label: "Long Technical")),
//         //     Expanded(
//         //       child: AnalysisItem(
//         //         label: "Long Technical",
//         //         value: analysisRes?.longTermPercent.toDouble(),
//         //       ),
//         //     ),
//         //   ],
//         // ),
//         // const SpacerVertical(height: Dimen.itemSpacing),
//         // Row(
//         //   children: [
//         //     // Expanded(child: AnalysisItemLocked(label: "Analysis Renking")),
//         //     Expanded(
//         //       child: AnalysisItem(
//         //         label: "Analysis Ranking",
//         //         value: analysisRes?.analystRankingPercent.toDouble(),
//         //       ),
//         //     ),
//         //     const SpacerHorizontal(width: Dimen.padding),
//         //     // Expanded(child: AnalysisItemLocked(label: "Valuation")),
//         //     Expanded(
//         //       child: AnalysisItem(
//         //         label: "Valuation",
//         //         value: analysisRes?.valuationPercent.toDouble(),
//         //       ),
//         //     ),
//         //   ],
//         // ),
//         // const SpacerVertical(height: Dimen.itemSpacing),
//         SentimentSeekbarItem(
//             label: "Neutral",
//             // analysisRes!.setimentPercent == 0 ||
//             //         analysisRes.setimentPercent < 50
//             //     ? "Bearish"
//             //     : analysisRes.setimentPercent == 50
//             //         ? "Neutral"
//             //         : "Bullish",
//             value: (analysisRes?.setimentPercent.toDouble() ?? 1.0) / 100),

//         const SpacerVertical(height: 20),
//         Visibility(
//           visible: provider.analysisRes?.peersData?.isNotEmpty == true,
//           child: const ScreenTitle(
//             title: "Stock Peers",
//           ),
//         ),
//         // provider.analysisRes?.peersData?.isEmpty == true
//         //     ? const NoDataCustom(
//         //         error: "Stock peers data not found.",
//         //       )
//         //     :
//         ListView.separated(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           padding: const EdgeInsets.only(top: 0),
//           itemBuilder: (context, index) {
//             return PeerStockItem(
//               data: provider.analysisRes?.peersData?[index],
//               index: index,
//             );
//           },
//           separatorBuilder: (context, index) {
//             return Divider(
//               color: ThemeColors.greyBorder,
//               height: 12.sp,
//             );
//           },
//           itemCount: provider.analysisRes?.peersData?.length ?? 0,
//         ),
//         if (provider.extra?.disclaimer != null &&
//             (!provider.analysisLoading && provider.analysisRes != null))
//           DisclaimerWidget(
//             data: provider.extra!.disclaimer!,
//           ),
//       ],
//     );
//   }
// }

// class PeerStockItem extends StatelessWidget {
//   final PeersDatum? data;
//   final int index;
//   const PeerStockItem({super.key, required this.index, this.data});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.pushNamed(
//           context,
//           StockDetail.path, // arguments: data?.symbol,
//           arguments: {"slug": data?.symbol},
//         );
//       },
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(0.sp),
//             child: Container(
//               padding: const EdgeInsets.all(5),
//               width: 43,
//               height: 43,
//               child: ThemeImageView(url: data?.image ?? ""),
//             ),
//           ),
//           const SpacerHorizontal(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   data?.symbol ?? "",
//                   style: styleGeorgiaBold(fontSize: 14),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SpacerVertical(height: 5),
//                 Text(
//                   data?.name ?? "",
//                   style: styleGeorgiaRegular(
//                     color: ThemeColors.greyText,
//                     fontSize: 12,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           const SpacerHorizontal(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(data?.price ?? "", style: stylePTSansBold(fontSize: 14)),
//               const SpacerVertical(height: 2),
//               RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text:
//                           "${data?.change} (${data?.changesPercentage.toCurrency()}%)",
//                       style: stylePTSansRegular(
//                         fontSize: 12,
//                         color: (data?.changesPercentage ?? 0) > 0
//                             ? Colors.green
//                             : Colors.red,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }

// class AnalysisItem extends StatelessWidget {
//   final String label;
//   final double? value;
//   const AnalysisItem({
//     required this.label,
//     this.value,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: ThemeColors.primaryLight,
//         borderRadius: BorderRadius.circular(4.r),
//       ),
//       padding: EdgeInsets.all(8.sp),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Flexible(
//                 child: Text(
//                   label,
//                   style: stylePTSansBold(fontSize: 18).copyWith(height: 1),
//                 ),
//               ),
//               const SpacerHorizontal(width: 5),
//               Text(
//                 "${value?.toCurrency() ?? 0}",
//                 style: stylePTSansBold(fontSize: 18).copyWith(height: 1),
//               ),
//             ],
//           ),
//           Container(
//             height: 10,
//             width: double.infinity,
//             margin: EdgeInsets.only(top: 5.sp),
//             decoration: BoxDecoration(
//               color: ThemeColors.background,
//               borderRadius: BorderRadius.circular(2.sp),
//             ),
//             child: FractionallySizedBox(
//               alignment: Alignment.centerLeft,
//               widthFactor: (value ?? 1.0) / 100,
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(2),
//                   color: Colors.green,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AnalysisItemLocked extends StatelessWidget {
//   final String label;
//   const AnalysisItemLocked({
//     required this.label,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: ThemeColors.accent,
//         borderRadius: BorderRadius.circular(4.r),
//       ),
//       padding: EdgeInsets.all(8.sp),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: stylePTSansRegular(fontSize: 12),
//                 ),
//                 Text(
//                   "PREMIUM",
//                   style: stylePTSansBold(fontSize: 18),
//                 ),
//               ],
//             ),
//           ),
//           const Icon(Icons.lock_outline)
//         ],
//       ),
//     );
//   }
// }

// class SentimentSeekbarItem extends StatelessWidget {
//   final String label;
//   final double value;
//   const SentimentSeekbarItem({
//     required this.label,
//     required this.value,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     Utils().showLog("Stock detail sentiment value : $value");
//     return Container(
//       decoration: BoxDecoration(
//         color: ThemeColors.primaryLight,
//         borderRadius: BorderRadius.circular(4.r),
//       ),
//       padding: EdgeInsets.all(8.sp),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 "Stock Sentiment",
//                 style: stylePTSansRegular(fontSize: 14),
//               ),
//               // Text(
//               //   label,
//               //   style: stylePTSansBold(fontSize: 18),
//               // ),
//             ],
//           ),
//           const SpacerVertical(height: 3),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Text("Bearish", style: stylePTSansRegular(fontSize: 12)),

//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Image.asset(
//                     Images.graphBear,
//                     height: 40,
//                     width: 40,
//                   ),
//                   Text("Bearish", style: stylePTSansRegular(fontSize: 12)),
//                 ],
//               ),
//               const SpacerHorizontal(width: 5),
//               Expanded(
//                 child: LayoutBuilder(
//                   builder: (BuildContext context, BoxConstraints constraint) {
//                     return RangeIndicator(
//                       value: value,
//                       width: constraint.w.minWidth,
//                     );
//                   },
//                 ),
//               ),
//               const SpacerHorizontal(width: 5),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Image.asset(
//                     Images.graphBull,
//                     height: 40,
//                     width: 40,
//                   ),
//                   Text("Bullish", style: stylePTSansRegular(fontSize: 12)),
//                 ],
//               ),
//               // Text("Bullish", style: stylePTSansRegular(fontSize: 12)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class RangeIndicator extends StatelessWidget {
//   final double width; // Value between 0 and 1
//   final double value; // Value between 0 and 1
//   final double indicatorWidth = 20.0; // Width of the triangle indicator
//   final double indicatorHeight = 20.0; // Height of the triangle indicator

//   const RangeIndicator({
//     super.key,
//     required this.value,
//     required this.width,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: indicatorHeight,
//       child: Stack(
//         children: [
//           Container(
//             height: double.infinity,
//             width: width,
//             margin: EdgeInsets.only(top: 5.sp),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(2),
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.red.withOpacity(0.7),
//                   Colors.red.withOpacity(0.9), // Adjust the opacity as needed
//                   Colors.yellow, // Adjust the opacity as needed
//                   Colors.green.withOpacity(0.9), // Adjust the opacity as needed
//                   Colors.green.withOpacity(0.7),
//                 ],
//                 stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
//                 begin: Alignment.centerLeft,
//                 end: Alignment.centerRight,
//               ),
//             ),
//           ),
//           Positioned(
//             left: value == 1.0
//                 ? (0.73 * (width - indicatorWidth))
//                 : (value * (width - indicatorWidth)),
//             // top: -(indicatorHeight - 15), // Adjust based on your preference
//             child: SizedBox(
//               width: indicatorWidth,
//               height: indicatorHeight,
//               child: CustomPaint(
//                 painter: ReversePyramidIndicatorPainter(
//                     value: value == 1.0 ? 0.89 : value),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ReversePyramidIndicatorPainter extends CustomPainter {
//   final double value;
//   const ReversePyramidIndicatorPainter({this.value = 0});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint borderPaint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.sp;

//     final Path path = Path()
//       ..moveTo(0, 0)
//       ..lineTo(size.width, 0)
//       ..lineTo(size.width / 2, size.height)
//       ..close();

//     canvas.drawPath(path, borderPaint);
//     canvas.clipPath(path);

//     final gradient = LinearGradient(
//       colors: [
//         calculateColor(value),
//         calculateColor(value),
//         calculateColor(value),
//       ],
//       stops: const [0.0, 0.5, 1.0],
//       begin: Alignment.centerLeft,
//       end: Alignment.centerRight,
//     );

//     final Rect rect =
//         Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height));
//     final Paint fillPaint = Paint()..shader = gradient.createShader(rect);

//     canvas.drawRect(rect, fillPaint);
//   }

//   Color calculateColor(double value) {
//     final List<Color> gradientColors = [
//       Colors.red.withOpacity(0.7),
//       Colors.red.withOpacity(0.9), // Adjust the opacity as needed
//       Colors.yellow, // Adjust the opacity as needed
//       Colors.green.withOpacity(0.9), // Adjust the opacity as needed
//       Colors.green.withOpacity(0.7),
//     ];

//     // Ensure the value is within the valid range [0, 1]
//     value = value.clamp(0.0, 1.0);

//     final int colorStops = gradientColors.length - 1;
//     final double colorPosition = value * colorStops;
//     final int startIndex = colorPosition.floor();
//     final int endIndex = startIndex + 1;

//     final double fraction = colorPosition - startIndex.toDouble();

//     final Color startColor = gradientColors[startIndex];
//     final Color endColor = gradientColors[endIndex];

//     return Color.lerp(startColor, endColor, fraction)!;
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
