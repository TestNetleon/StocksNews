import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/utils.dart';

import '../../managers/stockDetail/stock.detail.dart';
import '../../utils/colors.dart';
import 'menu_sheet.dart';

class SDTabs extends StatelessWidget {
  final List<MarketResData>? tabs;
  const SDTabs({super.key, this.tabs});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();

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
        BaseTabs(
          leftChild: GestureDetector(
            onTap: () {
              if (manager.data?.tabs?.isEmpty ??
                  false || manager.data?.tabs == null) {
                return;
              }
              Navigator.push(
                context,
                createRoute(
                  SDMenuSheet(
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
          key: ValueKey(manager.selectedIndex),
          labelPadding: EdgeInsets.zero,
          unselectedBold: false,
          data: tabs!,
          selectedIndex: manager.selectedIndex,
          onTap: manager.onTabChange,
        ),
      ],
    );
  }
}
