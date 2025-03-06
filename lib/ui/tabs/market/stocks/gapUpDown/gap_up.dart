import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/stocks/gapUpDown/gap_up.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/lock.dart';
import 'package:stocks_news_new/ui/base/stock/add.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class GapUp extends StatefulWidget {
  const GapUp({super.key});

  @override
  State<GapUp> createState() => _GapUpState();
}

class _GapUpState extends State<GapUp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    GapUpManager manager = context.read<GapUpManager>();
    await manager.getData(loadMore: loadMore);
  }

  @override
  Widget build(BuildContext context) {
    GapUpManager manager = context.watch<GapUpManager>();
    return BaseLoaderContainer(
      isLoading: manager.isLoading,
      hasData: manager.data != null && !manager.isLoading,
      showPreparingText: true,
      error: manager.error,
      onRefresh: _callAPI,
      child: Stack(
        children: [
          BaseLoadMore(
            onLoadMore: () => _callAPI(loadMore: true),
            onRefresh: _callAPI,
            canLoadMore: manager.canLoadMore,
            child: (manager.data == null || manager.data?.data == null)
                ? const SizedBox()
                : ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return BaseStockAddItem(
                        data: manager.data!.data![index],
                        index: index,
                        onRefresh: _callAPI,
                        manager: manager,
                        expandable: manager.data!.data![index].extra,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return BaseListDivider();
                    },
                    itemCount: manager.data!.data?.length ?? 0,
                  ),
          ),
          BaseLockItem(manager: manager, callAPI: _callAPI),
        ],
      ),
    );
  }
}
