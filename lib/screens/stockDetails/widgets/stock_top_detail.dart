// import 'package:flutter/material.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// import 'stockTopWidgets/desclaimer.dart';
// import 'stockTopWidgets/detail.dart';
// import 'stockTopWidgets/range.dart';

// class StockTopDetail extends StatefulWidget {
//   final String symbol;
//   const StockTopDetail({super.key, required this.symbol});

//   @override
//   State<StockTopDetail> createState() => _StockTopDetailState();
// }

// class _StockTopDetailState extends State<StockTopDetail> {
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//   //     context
//   //         .read<StockDetailProvider>()
//   //         .getStockDetails(symbol: widget.symbol);
//   //   });
//   // }

// //
//   @override
//   Widget build(BuildContext context) {
//     return const Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         StockDetailTopWidgetDetail(),
//         SpacerVertical(height: 4),
//         StockDetailTopDisclaimer(),
//         SpacerVertical(height: 10),
//         StockDetailTopWidgetRange(),
//       ],
//     );
//   }
// }
