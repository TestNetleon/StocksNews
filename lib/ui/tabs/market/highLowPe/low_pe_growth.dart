import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/highLowPe/low_pe_growth.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/lock.dart';
import 'package:stocks_news_new/ui/base/stock/add.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class LowPeGrowth extends StatefulWidget {
  const LowPeGrowth({super.key});

  @override
  State<LowPeGrowth> createState() => _LowPeGrowthState();
}

class _LowPeGrowthState extends State<LowPeGrowth> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    LowPeGrowthManager manager = context.read<LowPeGrowthManager>();
    await manager.getData(loadMore: loadMore);
  }

  @override
  Widget build(BuildContext context) {
    LowPeGrowthManager manager = context.watch<LowPeGrowthManager>();
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

      //  BaseLoadMore(
      //   onLoadMore: () => _callAPI(loadMore: true),
      //   onRefresh: _callAPI,
      //   canLoadMore: manager.canLoadMore,
      //   child: (manager.data == null || manager.data?.data == null)
      //       ? const SizedBox()
      //       : ListView.separated(
      //           shrinkWrap: true,
      //           itemBuilder: (context, index) {
      //             return BaseStockAddItem(
      //               data: manager.data!.data![index],
      //               index: index,
      //               onRefresh: _callAPI,
      //               manager: manager,
      //               expandable: manager.data!.data![index].extra,
      //             );
      //           },
      //           separatorBuilder: (context, index) {
      //             return BaseListDivider();
      //           },
      //           itemCount: manager.data!.data?.length ?? 0,
      //         ),
      // ),
    );
  }
}
