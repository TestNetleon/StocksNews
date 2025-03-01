import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/stock/add.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import '../../../models/ticker.dart';
import '../index.dart';

class SDCompetitors extends StatelessWidget {
  const SDCompetitors({super.key});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    List<BaseTickerRes>? competitors = manager.dataCompetitors?.data;

    return BaseLoaderContainer(
      hasData: manager.dataCompetitors != null,
      isLoading: manager.isLoadingCompetitors,
      error: manager.errorCompetitors,
      onRefresh: manager.onSelectedTabRefresh,
      showPreparingText: true,
      child: CommonRefreshIndicator(
        onRefresh: manager.onSelectedTabRefresh,
        child: ListView.separated(
          itemBuilder: (context, index) {
            BaseTickerRes? data = competitors?[index];
            if (data == null) {
              return SizedBox();
            }

            return BaseStockAddItem(
              data: data,
              index: index,
              onTap: (p0) {
                Navigator.pushNamed(context, StockDetailIndex.path,
                    arguments: {'symbol': p0.symbol});
              },
            );
          },
          separatorBuilder: (context, index) {
            return BaseListDivider();
          },
          itemCount: competitors?.length ?? 0,
        ),
      ),
    );
  }
}
