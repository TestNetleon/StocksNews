// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/stock_detail_provider.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';
// import 'package:stocks_news_new/widgets/screen_title.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

// import '../stockTopWidgets/common_heading.dart';
// import 'test/container.dart';

// class StocksTechnicalAnalysis extends StatefulWidget {
//   final String symbol;
//   const StocksTechnicalAnalysis({super.key, required this.symbol});

//   @override
//   State<StocksTechnicalAnalysis> createState() =>
//       _StocksTechnicalAnalysisState();
// }

// class _StocksTechnicalAnalysisState extends State<StocksTechnicalAnalysis> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       StockDetailProvider provider = context.read<StockDetailProvider>();
//       if (provider.technicalAnalysisRes == null) {
//         provider.technicalAnalysisData(symbol: widget.symbol);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     StockDetailProvider provider = context.watch<StockDetailProvider>();
// //
//     return Column(
//       children: [
//         const CommonHeadingStockDetail(),
//         ScreenTitle(
//           // title: "${provider.data?.keyStats?.symbol} ",
//           // title:
//           //     "${provider.data?.keyStats?.name} (${provider.data?.keyStats?.symbol})",
//           subTitle: provider.dataMentions?.technicalText,
//         ),
//         provider.tALoading && provider.technicalAnalysisRes == null
//             ? Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const CircularProgressIndicator(
//                     color: ThemeColors.accent,
//                   ),
//                   const SpacerHorizontal(width: 5),
//                   Flexible(
//                     child: Text(
//                       "Fetching technical analysis data...",
//                       style: stylePTSansRegular(color: ThemeColors.accent),
//                     ),
//                   ),
//                 ],
//               )
//             : provider.data != null
//                 // ? const StocksTechnicalAnalysisBase()

//                 ? const TEstTechnicalAnalysis()
//                 : Text(
//                     "No technical analysis data found.",
//                     style: stylePTSansRegular(),
//                   ),
//       ],
//     );
//   }
// }
