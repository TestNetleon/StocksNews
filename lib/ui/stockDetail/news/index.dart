import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/stockDetail/news/news.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class SDLatestNews extends StatelessWidget {
  const SDLatestNews({super.key});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    return BaseLoaderContainer(
      hasData: manager.dataLatestNews != null,
      isLoading: manager.isLoadingLatestNews && manager.dataLatestNews == null,
      error: manager.errorLatestNews,
      onRefresh: manager.onSelectedTabRefresh,
      showPreparingText: true,
      child: BaseScroll(
        margin: EdgeInsets.zero,
        onRefresh: manager.onSelectedTabRefresh,
        children: [
         // SDLatestNewsGauge(sentimentsPer: manager.dataLatestNews?.sentimentsPer),
          SpacerVertical(height: Pad.pad8),
          SDLatestNewsWidget(news: manager.dataLatestNews?.data),
        ],
      ),
    );
  }
}
