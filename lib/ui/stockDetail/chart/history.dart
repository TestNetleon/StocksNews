import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import '../../../managers/stockDetail/stock.detail.dart';
import '../../../models/stockDetail/chart.dart';
import '../../../utils/constants.dart';
import '../../base/base_list_divider.dart';
import '../extra/list_heading.dart';
import 'item.dart';

class SDChartHistory extends StatelessWidget {
  final ChartPriceHistoryRes? chartHistory;
  const SDChartHistory({super.key, this.chartHistory});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    List<PriceHistoryDataRes>? list = chartHistory?.data;
    if (list == null || list.isEmpty) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(
          title: chartHistory?.title,
          margin: EdgeInsets.only(
            top: Pad.pad24,
            left: Pad.pad16,
            right: Pad.pad16,
          ),
        ),
        SDListHeading(
          data: ['Date', 'Opening Price', 'Closing Price'],
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            PriceHistoryDataRes? data = list[index];

            bool isOpen = manager.openChart == index;

            return ChartHistoryItem(
              data: data,
              isOpen: isOpen,
              onTap: () => manager.openChartIndex(isOpen ? -1 : index),
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
