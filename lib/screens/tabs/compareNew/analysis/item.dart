import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/modals/compare_stock_res.dart';

import '../../../../providers/compare_stocks_provider.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/linear_bar.dart';

class CompareNewAnalysisItem extends StatelessWidget {
  final num value;
  final int index;
  const CompareNewAnalysisItem(
      {super.key, required this.value, required this.index});

  @override
  Widget build(BuildContext context) {
    List<CompareStockRes> company =
        context.watch<CompareStocksProvider>().company;
    return Flexible(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            right: company.length == 1
                ? BorderSide.none
                : company.length == 2 && index == 0
                    ? BorderSide(
                        color: ThemeColors.greyBorder.withOpacity(0.2),
                      )
                    : company.length == 3 && (index == 0 || index == 1)
                        ? BorderSide(
                            color: ThemeColors.greyBorder.withOpacity(0.2),
                          )
                        : BorderSide.none,
          ),
        ),
        child: LinearBarCommon(value: value),
      ),
    );
  }
}
