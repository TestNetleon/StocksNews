import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/my_home.dart';
import 'package:stocks_news_new/ui/base/heading.dart';

import '../../../managers/stockDetail/stock.detail.dart';
import '../../../utils/constants.dart';
import '../../base/base_list_divider.dart';
import '../../tabs/signals/insiders/item.dart';

class InsiderHistory extends StatelessWidget {
  final InsiderTradeListRes? insiderData;
  const InsiderHistory({super.key, this.insiderData});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    List<InsiderTradeRes>? list = insiderData?.data;
    if (list == null || list.isEmpty) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(
          title: insiderData?.title,
          margin: EdgeInsets.symmetric(
            vertical: Pad.pad10,
            horizontal: Pad.pad16,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            InsiderTradeRes? data = insiderData?.data?[index];
            bool isOpen = manager.openInsiderTrades == index;
            if (data == null) {
              return SizedBox();
            }
            return BaseInsiderItem(
              data: data,
              isOpen: isOpen,
              onTap: () => manager.openInsiderTradesIndex(isOpen ? -1 : index),
            );
          },
          separatorBuilder: (context, index) {
            return BaseListDivider();
          },
          itemCount: list.length,
        ),
      ],
    );
  }
}
