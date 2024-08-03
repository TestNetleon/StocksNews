// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/stock_detail_new.dart';
// import 'package:stocks_news_new/screens/stockDetail/widgets/financial/widget/financial_table_item.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

// class FinancialTable extends StatelessWidget {
//   const FinancialTable({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Accessing the provider
//     StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();

//     // Building the layout
//     return FinancialTableItem();

//     // Use ScreenUtil to adapt to different screen sizes
//     // return ListView.separated(
//     //   shrinkWrap: true,
//     //   itemBuilder: (context, index) {
//     //     // Access financial data from provider

//     //     return Padding(
//     //       padding: const EdgeInsets.all(
//     //         Dimen.padding,
//     //       ),
//     //       child: FinancialTableItem(index: index),
//     //     );
//     //   },
//     //   separatorBuilder: (context, index) {
//     //     return const SpacerHorizontal(width: 10);
//     //   },
//     //   itemCount: provider.sdFinancialArray?.length ?? 0,
//     // );
//   }
// }
