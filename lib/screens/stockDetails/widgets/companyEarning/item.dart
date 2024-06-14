// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/modals/stocks_other_detail_res.dart';
// import 'package:stocks_news_new/providers/stock_detail_provider.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/theme.dart';

// class CompanyEarningItem extends StatelessWidget {
//   final int index;
//   const CompanyEarningItem({super.key, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     EarningData? data =
//         context.watch<StockDetailProvider>().otherData?.earning?.data?[index];
// //
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         Visibility(
//           visible: data?.quarter != null,
//           child: Text(
//             data?.quarter ?? "",
//             style: stylePTSansRegular(fontSize: 12),
//           ),
//         ),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Visibility(
//                 visible: data?.eps != null,
//                 child: Text(
//                   maxLines: 1,
//                   data?.eps ?? "",
//                   style: stylePTSansBold(
//                     fontSize: 12,
//                     color: data?.epsArrowClass == "green-arrow"
//                         ? ThemeColors.accent
//                         : Colors.red,
//                   ),
//                 ),
//               ),
//               Visibility(
//                 visible: data?.epsPercentChange != null,
//                 child: Text(
//                   maxLines: 1,
//                   "(${data?.epsPercentChange ?? ""}) ${data?.epsArrow ?? ""}",
//                   style: stylePTSansBold(
//                     fontSize: 10,
//                     color: data?.epsArrowClass == "green-arrow"
//                         ? ThemeColors.accent
//                         : Colors.red,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Visibility(
//                 visible: data?.revenue != null,
//                 child: Text(
//                   maxLines: 1,
//                   data?.revenue ?? "",
//                   style: stylePTSansBold(
//                       fontSize: 12,
//                       color: data?.revenueArrowClass == "green-arrow"
//                           ? ThemeColors.accent
//                           : Colors.red),
//                 ),
//               ),
//               Visibility(
//                 visible: data?.revenuePercentChange != null,
//                 child: Text(
//                   maxLines: 1,
//                   "(${data?.revenuePercentChange}) ${data?.revenueArrow}",
//                   style: stylePTSansBold(
//                       fontSize: 10,
//                       color: data?.revenueArrowClass == "green-arrow"
//                           ? ThemeColors.accent
//                           : Colors.red),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
