import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/stock/add.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/utils/constants.dart';

import '../../../../models/stockDetail/stock_analysis.dart';

class SDStocksAnalysisPeer extends StatelessWidget {
  final StocksPeersRes? peersData;
  const SDStocksAnalysisPeer({super.key, this.peersData});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();

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
            return BaseStockAddItem(
              data: stockData!,
              index: index,
              onTap: (p0) {
                // Navigator.pushReplacementNamed(context, SDIndex.path,
                //     arguments: {
                //       'symbol': p0.symbol,
                //     });

                Navigator.pushReplacement(
                    navigatorKey.currentContext!,
                    MaterialPageRoute(
                        builder: (context) => SDIndex(
                              symbol: p0.symbol ?? '',
                            )));
              },
              manager: manager,
            );
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
