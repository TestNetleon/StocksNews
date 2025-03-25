import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/models/trading_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/league/screens/tournaments/leaderboard/item.dart';
import 'package:stocks_news_new/utils/constants.dart';


class TopTraders extends StatelessWidget {
  final List<TradingRes>? list;
  const TopTraders({super.key, this.list});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            TradingRes? data = list?[index];
            if (data == null) {
              return SizedBox();
            }

            return LeaderboardItem(data: data, from: 1);
          },
          itemCount: list?.length ?? 0,
          separatorBuilder: (context, index) {
            return BaseListDivider(height:Pad.pad20);
          },
        );
      },
    );
  }
}
