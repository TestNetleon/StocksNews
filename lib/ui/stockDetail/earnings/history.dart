import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import '../../../managers/stockDetail/stock.detail.dart';
import '../../../models/stockDetail/earning.dart';
import '../../../utils/constants.dart';
import '../../base/base_list_divider.dart';
import 'history_item.dart';

class SDEarningsHistory extends StatelessWidget {
  final SDEarningHistoryRes? earningHistory;
  const SDEarningsHistory({super.key, this.earningHistory});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    List<SDEarningHistoryDataRes>? list = earningHistory?.data;
    if (list == null || list.isEmpty) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(
          title: earningHistory?.title,
          margin: EdgeInsets.only(
            top: Pad.pad10,
            left: Pad.pad16,
            right: Pad.pad16,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            SDEarningHistoryDataRes? data = list[index];

            bool isOpen = manager.openEarnings == index;

            return EarningsHistoryItem(
              data: data,
              isOpen: isOpen,
              onTap: () => manager.openEarningsIndex(isOpen ? -1 : index),
            );
          },
          itemCount: list.length,
          separatorBuilder: (context, index) {
            return BaseListDivider();
          },
        ),
      ],
    );
  }
}
