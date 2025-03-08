import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/sectors/sectors.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/stock/add.dart';
import 'package:stocks_news_new/ui/tabs/market/sectors/widget/header_chart.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class SectorViewIndex extends StatefulWidget {
  final String slug;
  static const path = 'SectorViewIndex';

  const SectorViewIndex({super.key, required this.slug});

  @override
  State<SectorViewIndex> createState() => _SectorViewIndexState();
}

class _SectorViewIndexState extends State<SectorViewIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    SectorsManager manager = context.read<SectorsManager>();
    await manager.getViewData(widget.slug,loadMore: loadMore);
  }
  @override
  Widget build(BuildContext context) {
    SectorsManager manager = context.watch<SectorsManager>();
    return BaseScaffold(
        appBar: BaseAppBar(
          showBack: true,
          title: manager.isLoadingView?"":manager.dataView?.title ?? "",
          showSearch: true,
        ),
        body: BaseLoaderContainer(
          isLoading: manager.isLoadingView,
          hasData: manager.dataView != null && !manager.isLoadingView,
          showPreparingText: true,
          error: manager.error,
          onRefresh: _callAPI,
          child: BaseLoadMore(
            onLoadMore: () => _callAPI(loadMore: true),
            onRefresh: _callAPI,
            canLoadMore: manager.canLoadMoreView,
            child: (manager.dataView == null || manager.dataView?.data == null)
                ? const SizedBox()
                : ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if (index == 0) Visibility(visible:manager.dataView?.chart!=null,child: HeaderChart()),
                    BaseStockAddItem(
                      onTap: (value){},
                      data: manager.dataView!.data![index],
                      index: index,
                      slidable: false,
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return BaseListDivider();
              },
               itemCount: manager.dataView?.data?.length ?? 0,
            ),
          ),
        )
    );
  }
}
