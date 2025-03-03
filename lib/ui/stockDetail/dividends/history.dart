import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import '../../../managers/stockDetail/stock.detail.dart';
import '../../../models/stockDetail/dividends.dart';
import '../../../utils/constants.dart';
import '../../base/base_list_divider.dart';
import '../extra/list_heading.dart';
import 'history_item.dart';

class SDDividendsHistory extends StatelessWidget {
  final DividendsRes? dividendHistory;
  const SDDividendsHistory({super.key, this.dividendHistory});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    List<DividendsDataRes>? list = dividendHistory?.data;
    if (list == null || list.isEmpty) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(
          title: dividendHistory?.title,
          margin: EdgeInsets.only(
            top: Pad.pad10,
            left: Pad.pad16,
            right: Pad.pad16,
          ),
        ),
        SDListHeading(
          data: ['Announced', 'Amount'],
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            DividendsDataRes? data = list[index];

            bool isOpen = manager.openDividends == index;

            return DividendHistoryItem(
              data: data,
              isOpen: isOpen,
              onTap: () => manager.openDividendsIndex(isOpen ? -1 : index),
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
