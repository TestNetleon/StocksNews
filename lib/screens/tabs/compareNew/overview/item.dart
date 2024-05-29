import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/utils/colors.dart';

import '../../../../modals/compare_stock_res.dart';
import '../../../../utils/theme.dart';

class CompareNewOverviewItem extends StatelessWidget {
  final String item;
  final int index;
  const CompareNewOverviewItem(
      {super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    List<CompareStockRes> company =
        context.watch<CompareStocksProvider>().company;
    return Flexible(
      child: Container(
        alignment: Alignment.centerLeft,
        // height: constraints.maxWidth * 0.5,
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
        child: Text(
          item,
          textAlign: TextAlign.left,
          maxLines: 2,
          style: stylePTSansRegular(fontSize: 13),
        ),
      ),
    );
  }
}
