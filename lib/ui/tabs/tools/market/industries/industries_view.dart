import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/industries/industries.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/stock/add.dart';
import 'package:stocks_news_new/ui/tabs/tools/market/industries/widget/header_item.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class IndustriesViewIndex extends StatefulWidget {
  final String slug;
  static const path = 'IndustriesViewIndex';

  const IndustriesViewIndex({super.key, required this.slug});

  @override
  State<IndustriesViewIndex> createState() => _IndustriesViewIndexState();
}

class _IndustriesViewIndexState extends State<IndustriesViewIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({loadMore = false}) async {
    IndustriesManager manager = context.read<IndustriesManager>();
    await manager.getViewData(widget.slug, loadMore: loadMore);
  }

  @override
  Widget build(BuildContext context) {
    IndustriesManager manager = context.watch<IndustriesManager>();
    return BaseScaffold(
        appBar: BaseAppBar(
          showBack: true,
          //title: manager.isLoadingView ? "" : manager.dataView?.title ?? "",
          showSearch: true,
          showNotification: true,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            Visibility(
                                visible: manager.dataView?.title != null,
                                child: BaseHeading(
                                  textAlign: TextAlign.start,
                                  margin: const EdgeInsets.symmetric(horizontal:Pad.pad16,vertical: Pad.pad5),
                                  title: manager.dataView?.title??"",
                                  titleStyle: styleBaseBold(),
                                )
                            ),
                          if (index == 0)
                            HeaderItem(header: manager.dataView?.header),
                          BaseStockAddItem(
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
        ));
  }
}
