import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/models/market/market_res.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';

class SDMenuSheet extends StatelessWidget {
  final List<MarketResData> tabs;
  const SDMenuSheet({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    return BaseScaffold(
      appBar: BaseAppBar(showBack: true),
      body: ListView.separated(
        itemBuilder: (context, index) {
          MarketResData data = tabs[index];

          return InkWell(
            onTap: () {
              manager.onTabChange(index);
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Pad.pad16,
                vertical: Pad.pad10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data.title ?? '',
                    style: manager.selectedTab == data
                        ? styleBaseSemiBold(color: ThemeColors.black)
                        : styleBaseRegular(color: ThemeColors.neutral40),
                  ),
                  if (manager.selectedTab == data)
                    Image.asset(
                      Images.tick,
                      height: 18,
                      width: 18,
                      color: ThemeColors.secondary120,
                    ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return BaseListDivider();
        },
        itemCount: tabs.length,
      ),
    );
  }
}
