// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/stock_detail_new.dart';
// import 'package:stocks_news_new/widgets/custom_gridview.dart';
// import 'package:stocks_news_new/widgets/screen_title.dart';

// import '../../../../modals/stockDetailRes/earnings.dart';
// import '../../../stockDetails/widgets/states.dart';

// class SdCompanyCalendar extends StatelessWidget {
//   const SdCompanyCalendar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();

//     return Column(
//       children: [
//         const ScreenTitle(title: "Company Calendar"),
//         CustomGridView(
//             length: provider.overviewRes?.calendar?.length ?? 0,
//             getChild: (index) {
//               SdTopRes? data = provider.overviewRes?.calendar?[index];
//               return StateItemNEW(
//                 label: data?.key ?? "",
//                 value: data?.value ?? "",
//               );
//             })
//       ],
//     );
//   }
// }
