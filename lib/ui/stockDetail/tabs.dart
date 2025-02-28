import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../../managers/stockDetail/stock.detail.dart';
import '../../utils/colors.dart';
import 'menu_sheet.dart';

class StocksDetailTabs extends StatelessWidget {
  final List<MarketResData>? tabs;
  const StocksDetailTabs({super.key, this.tabs});

  @override
  Widget build(BuildContext context) {
    StocksDetailManager manager = context.watch<StocksDetailManager>();

    if (tabs?.isEmpty == true || tabs == null) {
      return SizedBox();
    }

    return Column(
      children: [
        Divider(
          color: ThemeColors.neutral5,
          height: 1,
          thickness: 1,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (manager.data?.tabs?.isEmpty ??
                    false || manager.data?.tabs == null) {
                  return;
                }
                Navigator.push(
                  context,
                  createRoute(
                    StocksDetailMenuSheet(
                      tabs: manager.data!.tabs!,
                    ),
                  ),
                );
              },
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Image.asset(
                  Images.menu,
                  height: 18,
                  width: 18,
                ),
              ),
            ),
            Flexible(
              child: BaseTabs(
                key: ValueKey(manager.selectedIndex),
                labelPadding: EdgeInsets.zero,
                showDivider: false,
                data: tabs!,
                selectedIndex: manager.selectedIndex,
                onTap: manager.onTabChange,
              ),
            ),
          ],
        ),
        Divider(
          color: ThemeColors.neutral5,
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }
}
