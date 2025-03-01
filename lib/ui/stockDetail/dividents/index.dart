import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/stockDetail/earnings/estimates.dart';
import 'package:stocks_news_new/ui/stockDetail/earnings/history.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom_gridview.dart';

import '../../../models/stockDetail/earning.dart';
import '../../../models/stockDetail/overview.dart';
import '../extra/top.dart';

class SDDividends extends StatelessWidget {
  const SDDividends({super.key});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();

    List<BaseKeyValueRes>? top = manager.dataDividends?.top;

    SDEpsEstimatesRes? epsEstimates = manager.dataEarnings?.epsEstimates;
    SDEarningHistoryRes? earningHistory = manager.dataEarnings?.earningHistory;

    return BaseLoaderContainer(
      hasData: manager.dataDividends != null,
      isLoading: manager.isLoadingDividends,
      error: manager.errorDividends,
      onRefresh: manager.onSelectedTabRefresh,
      showPreparingText: true,
      child: BaseScroll(
        onRefresh: manager.onSelectedTabRefresh,
        margin: EdgeInsets.zero,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: Pad.pad16),
            child: CustomGridView(
              length: top?.length ?? 0,
              paddingHorizontal: 0,
              paddingVertical: Pad.pad16,
              itemSpace: Pad.pad16,
              getChild: (index) {
                BaseKeyValueRes? data = top?[index];
                if (data == null) {
                  return SizedBox();
                }
                return SDTopCards(top: data);
              },
            ),
          ),
          // SDDividendsHistory(earningHistory: earningHistory),
          // SDDividendsEstimates(epsEstimates: epsEstimates),
        ],
      ),
    );
  }
}
