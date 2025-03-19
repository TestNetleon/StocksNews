import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/trending_view_all.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/stock/add.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class TrendingNow extends StatefulWidget {
  const TrendingNow({super.key});

  @override
  State<TrendingNow> createState() => _TrendingNowState();
}

class _TrendingNowState extends State<TrendingNow> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    TrendingViewAllManager manager = context.read<TrendingViewAllManager>();
    manager.getTrendingNow(loadMore: loadMore);
  }

  @override
  Widget build(BuildContext context) {
    TrendingViewAllManager manager = context.watch<TrendingViewAllManager>();
    return BaseLoaderContainer(
      isLoading: manager.isLoadingNow,
      hasData: manager.dataNow != null && !manager.isLoadingNow,
      showPreparingText: true,
      error: manager.errorNow,
      onRefresh: _callAPI,
      child: BaseLoadMore(
        onLoadMore: () => _callAPI(loadMore: true),
        onRefresh: _callAPI,
        canLoadMore: manager.canLoadMoreNow,
        child: (manager.dataNow == null || manager.dataNow?.data == null)
            ? const SizedBox()
            : ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return BaseStockAddItem(
                    data: manager.dataNow!.data![index],
                    index: index,
                    onRefresh: _callAPI,
                    manager: manager,
                  );
                },
                separatorBuilder: (context, index) {
                  return BaseListDivider();
                },
                itemCount: manager.dataNow!.data?.length ?? 0,
              ),
      ),
    );
  }
}
