import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/billionaires_res.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/billionaires_index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/widget/billionaire_item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TopBilIndex extends StatelessWidget {
  final TopTab? topTabs;
  const TopBilIndex({super.key,this.topTabs});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: topTabs?.topBillionaires != null,
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: Pad.pad10),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          RecentMentionsRes? item = topTabs?.topBillionaires?[index];
          return BillionaireItem(
              item:item,
              onTap:(){}
          );
        },
        separatorBuilder: (context, index) {
          return SpacerVertical(height: Pad.pad5);
        },
        itemCount: topTabs?.topBillionaires?.length ?? 0,
      )
    );
  }
}
