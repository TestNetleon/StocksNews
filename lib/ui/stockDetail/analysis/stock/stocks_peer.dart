import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/stock_item.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../../../../models/stockDetail/stock_analysis.dart';

class SDStocksAnalysisPeer extends StatelessWidget {
  final StocksPeersRes? peersData;
  const SDStocksAnalysisPeer({super.key, this.peersData});

  @override
  Widget build(BuildContext context) {
    if (peersData == null) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseHeading(
          title: peersData?.title,
          margin: EdgeInsets.only(
            top: Pad.pad24,
            left: Pad.pad16,
            bottom: Pad.pad10,
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: Pad.pad16),
          itemBuilder: (context, index) {
            List<BaseTickerRes>? data = peersData?.data;
            BaseTickerRes? stockData = data?[index];
            if (stockData == null) {
              SizedBox();
            }
            return BaseStockItem(data: stockData!, index: index);
          },
          separatorBuilder: (context, index) {
            return BaseListDivider();
          },
          itemCount: peersData?.data?.length ?? 0,
        ),
      ],
    );
  }
}
