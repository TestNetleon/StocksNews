import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/compare_stocks_provider.dart';
import 'package:stocks_news_new/screens/tabs/compareStocks/widgets/pop_up.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/alert_popup.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../providers/search_provider.dart';
import '../../../../utils/constants.dart';
import 'header.dart';

class CompareNewAddScreen extends StatelessWidget {
  const CompareNewAddScreen({super.key});
  _showPopUp(BuildContext context) {
    context.read<SearchProvider>().clearSearch();
    showDialog(
        context: context,
        builder: (context) {
          return const CompareStocksPopup(
            fromAdd: true,
          );
        });
  }

  _onTap(BuildContext context) {
    CompareStocksProvider provider = context.read<CompareStocksProvider>();

    for (var i = 0; i < provider.compareData.length; i++) {
      Timer(Duration(seconds: i == 0 ? 0 : 2), () {
        provider.addStockItem(
            fromNewAdd: true, symbol: provider.compareData[i].symbol);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CompareStocksProvider provider = context.watch<CompareStocksProvider>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            Dimen.padding, Dimen.padding, Dimen.padding, 0),
        child: Column(
          children: [
            const CompareNewAddHeader(),
            const SpacerVertical(height: 5),
            Row(
              children: [
                Visibility(
                  visible: provider.compareData.length != 3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(left: 10, right: 15),
                      disabledBackgroundColor:
                          ThemeColors.greyBorder.withOpacity(0.2),
                      disabledForegroundColor: ThemeColors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: provider.compareData.length == 2
                                ? ThemeColors.accent
                                : ThemeColors.greyBorder),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: provider.compareData.length == 2
                        ? () {
                            _showPopUp(context);
                            // easeOutBuilder(
                            //   duration: const Duration(milliseconds: 100),
                            //   context,
                            //   child: const CompareNewSearch(),
                            // );
                          }
                        : null,
                    child: Row(
                      children: [
                        Icon(Icons.add,
                            size: 20,
                            color: provider.compareData.length == 2
                                ? ThemeColors.accent
                                : ThemeColors.greyBorder),
                        const SpacerHorizontal(width: 5),
                        Text(
                          "Add Stock",
                          style: stylePTSansBold(
                              fontSize: 13,
                              color: provider.compareData.length == 2
                                  ? ThemeColors.accent
                                  : ThemeColors.greyBorder),
                        )
                      ],
                    ),
                  ),
                ),
                const SpacerHorizontal(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.accent),
                    onPressed: () {
                      if (provider.compareData.length <= 1) {
                        popUpAlert(
                          message: "At least add 2 Stocks to compare.",
                          title: "Alert",
                          icon: Images.alertPopGIF,
                        );
                      } else {
                        _onTap(context);
                      }
                    },
                    child: Text(
                      provider.compareData.isEmpty
                          ? "Compare"
                          : "Compare (${provider.compareData.length})",
                      style: stylePTSansBold(fontSize: 13),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
