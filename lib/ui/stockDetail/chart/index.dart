import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import '../../../models/stockDetail/chart.dart';
import '../../../models/stockDetail/overview.dart';
import '../../../utils/constants.dart';
import '../../../widgets/custom_gridview.dart';
import '../extra/top.dart';
import '../overview/chart.dart';
import 'history.dart';

class SDChart extends StatelessWidget {
  const SDChart({super.key});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    List<BaseKeyValueRes>? top = manager.dataChart?.top;
    ChartPriceHistoryRes? chartHistory = manager.dataChart?.priceHistory;

    return BaseLoaderContainer(
      hasData: manager.dataChart != null,
      isLoading: manager.isLoadingChart,
      error: manager.errorChart,
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
                return SDTopCards(
                  top: data,
                  valueColor: data.value.toString().contains('+')
                      ? Colors.green
                      : data.value.toString().contains('-')
                          ? Colors.red
                          : Colors.black,
                );
              },
            ),
          ),
          SDHistoricalChart(),
          SDChartHistory(chartHistory: chartHistory),
        ],
      ),
    );
  }
}
