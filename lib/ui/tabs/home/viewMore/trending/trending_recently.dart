import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/trending_view_all.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/stock/add.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class TrendingRecently extends StatefulWidget {
  const TrendingRecently({super.key});

  @override
  State<TrendingRecently> createState() => _TrendingRecentlyState();
}

class _TrendingRecentlyState extends State<TrendingRecently> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    TrendingViewAllManager manager = context.read<TrendingViewAllManager>();
    manager.getTrendingRecently(loadMore: loadMore);
  }

  @override
  Widget build(BuildContext context) {
    TrendingViewAllManager manager = context.watch<TrendingViewAllManager>();
    return BaseLoaderContainer(
      isLoading: manager.isLoadingRecently,
      hasData: manager.dataRecently != null && !manager.isLoadingRecently,
      showPreparingText: true,
      error: manager.errorRecently,
      onRefresh: _callAPI,
      child: BaseLoadMore(
        onLoadMore: () => _callAPI(loadMore: true),
        onRefresh: _callAPI,
        canLoadMore: manager.canLoadMoreRecently,
        child:
            (manager.dataRecently == null || manager.dataRecently?.data == null)
                ? const SizedBox()
                : ListView.separated(
                    itemBuilder: (context, index) {
                      return BaseStockAddItem(
                        data: manager.dataRecently!.data![index],
                        index: index,
                        onRefresh: _callAPI,
                        manager: manager,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return BaseListDivider();
                    },
                    itemCount: manager.dataRecently!.data?.length ?? 0,
                  ),
      ),
    );
  }
}
