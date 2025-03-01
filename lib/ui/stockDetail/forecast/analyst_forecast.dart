import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import '../../../models/stockDetail/analyst_forecast.dart';
import 'item.dart';

class SDAnalystForecast extends StatelessWidget {
  const SDAnalystForecast({super.key});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    List<AnalystForecastRes>? analystForecasts =
        manager.dataAnalystForecast?.analystForecasts;
    return BaseLoaderContainer(
      hasData: manager.dataAnalystForecast != null,
      isLoading: manager.isLoadingAnalystForecast,
      error: manager.errorAnalystForecast,
      onRefresh: manager.onSelectedTabRefresh,
      showPreparingText: true,
      child: CommonRefreshIndicator(
        onRefresh: manager.onSelectedTabRefresh,
        child: ListView.separated(
          itemBuilder: (context, index) {
            AnalystForecastRes? data = analystForecasts?[index];
            if (data == null) {
              return SizedBox();
            }
            bool isOpen = manager.openAnalystForecast == index;

            return AnalystForecastItem(
              data: data,
              isOpen: manager.openAnalystForecast == index,
              onTap: () =>
                  manager.openAnalystForecastIndex(isOpen ? -1 : index),
            );
          },
          itemCount: analystForecasts?.length ?? 0,
          separatorBuilder: (context, index) {
            return BaseListDivider();
          },
        ),
      ),
    );
  }
}
