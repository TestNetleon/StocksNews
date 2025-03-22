import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/sectors/sectors.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/base_sector_header.dart';
import 'package:stocks_news_new/ui/base/base_sector_item.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/lock.dart';
import 'package:stocks_news_new/ui/tabs/tools/market/sectors/sector_view.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class Sectors extends StatefulWidget {
  const Sectors({super.key});

  @override
  State<Sectors> createState() => _SectorsState();
}

class _SectorsState extends State<Sectors> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    SectorsManager manager = context.read<SectorsManager>();
    await manager.getData(loadMore: loadMore);
  }

  @override
  Widget build(BuildContext context) {
    SectorsManager manager = context.watch<SectorsManager>();
    return Stack(
      children: [
        BaseLoaderContainer(
          isLoading: manager.isLoading,
          hasData: manager.data != null && !manager.isLoading,
          showPreparingText: true,
          error: manager.error,
          onRefresh: _callAPI,
          child: BaseLoadMore(
            onLoadMore: () => _callAPI(loadMore: true),
            onRefresh: _callAPI,
            canLoadMore: manager.canLoadMore,
            child: (manager.data == null || manager.data?.data == null)
                ? const SizedBox()
                : ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          if (index == 0)
                            BaseSectorHeader(title: manager.data?.heading),
                          if (index == 0) BaseListDivider(),
                          BaseSectorItem(
                            data: manager.data!.data![index],
                            index: index,
                            onTap: (value) {
                              Navigator.pushNamed(context, SectorViewIndex.path,
                                  arguments: {
                                    'slug': value?.industrySlug ?? ""
                                  });
                            },
                          ),
                        ],
                      );
                      // return BaseStockAddItem(
                      //   data: manager.data!.data![index],
                      //   index: index,
                      //   onRefresh: _callAPI,
                      //   manager: manager,
                      //   expandable: manager.data!.data![index].extra,
                      // );
                    },
                    separatorBuilder: (context, index) {
                      return BaseListDivider();
                    },
                    // itemCount: manager.data!.data?.length ?? 0,
                    itemCount: 4,
                  ),
          ),
        ),
        BaseLockItem(manager: manager, callAPI: _callAPI),
      ],
    );
  }
}
