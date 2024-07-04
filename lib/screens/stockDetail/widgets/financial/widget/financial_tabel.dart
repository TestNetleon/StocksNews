// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:stocks_news_new/providers/stock_detail_new.dart';
// import 'package:stocks_news_new/screens/stockDetail/widgets/financial/widget/financial_table_item.dart';
// import 'package:stocks_news_new/utils/colors.dart';
// import 'package:stocks_news_new/utils/constants.dart';
// import 'package:stocks_news_new/widgets/spacer_vertical.dart';

// class FinancialTable extends StatelessWidget {
//   const FinancialTable({super.key});

//   @override
//   Widget build(BuildContext context) {
//     StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();

//     return SizedBox(
//       height: 500, // Adjust the height as per your design
//       child: ListView.separated(
//           padding: const EdgeInsets.only(top: 0, bottom: 15),
//           shrinkWrap: true,
//           scrollDirection:
//               Axis.horizontal, // Set the scroll direction to horizontal
//           physics: const AlwaysScrollableScrollPhysics(),
//           itemBuilder: (context, index) {
// Map<String, dynamic>? data = provider.sdFinancialArray?[index];

// return Padding(
//   padding: const EdgeInsets.all(
//     Dimen.padding,
//   ),
//   child: FinancialTableItem(index: index),
// );
//           },
//           separatorBuilder: (context, index) {
//             return const SizedBox(
//                 width: 15); // Use SizedBox for horizontal spacing
//           },
//           itemCount: provider.sdFinancialArray?.length ?? 0),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stock_detail_new.dart';
import 'package:stocks_news_new/screens/stockDetail/widgets/financial/widget/financial_table_item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class FinancialTable extends StatelessWidget {
  const FinancialTable({super.key});
//
  @override
  Widget build(BuildContext context) {
    StockDetailProviderNew provider = context.watch<StockDetailProviderNew>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
            height: constraints.maxWidth,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Map<String, dynamic>? data = provider.sdFinancialArray?[index];

                return Padding(
                  padding: const EdgeInsets.all(
                    Dimen.padding,
                  ),
                  child: FinancialTableItem(index: index),
                );
              },
              separatorBuilder: (context, index) {
                return const SpacerHorizontal(width: 10);
              },
              itemCount: provider.sdFinancialArray?.length ?? 0,
            ));
      },
    );
  }
}
