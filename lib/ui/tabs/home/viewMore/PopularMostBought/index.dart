import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/home/home.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/stock/add.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class HomeViewMoreTickersIndex extends StatefulWidget {
  static const path = 'HomeViewMoreTickersIndex';
  final String apiUrl;
  const HomeViewMoreTickersIndex({
    super.key,
    required this.apiUrl,
  });

  @override
  State<HomeViewMoreTickersIndex> createState() =>
      _HomeViewMoreTickersIndexState();
}

class _HomeViewMoreTickersIndexState extends State<HomeViewMoreTickersIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI({bool loadMore = false}) async {
    await context
        .read<MyHomeManager>()
        .getViewMoreData(apiUrl: widget.apiUrl, loadMore: loadMore);
  }

  @override
  Widget build(BuildContext context) {
    MyHomeManager manager = context.watch<MyHomeManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        showSearch: true,
        showNotification: true,
        showLogo: false,
        title: manager.isLoadingViewMore ? '' : manager.homeViewMore?.title,
      ),
      body: BaseLoaderContainer(
        isLoading: manager.isLoadingViewMore,
        hasData: manager.homeViewMore?.data != null,
        showPreparingText: true,
        error: manager.errorViewMore,
        onRefresh: _callAPI,
        child: BaseLoadMore(
          onRefresh: _callAPI,
          onLoadMore: () async => _callAPI(loadMore: true),
          canLoadMore: manager.canLoadMoreViewMore,
          child: ListView.separated(
            padding: EdgeInsets.only(bottom: 10),
            itemBuilder: (context, index) {
              BaseTickerRes? data = manager.homeViewMore?.data?[index];
              if (data == null) {
                return SizedBox();
              }
              return BaseStockAddItem(
                data: data,
                index: index,
                onTap: (p0) {
                  // Navigator.pushNamed(context, SDIndex.path,
                  //     arguments: {'symbol': p0.symbol});
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SDIndex(symbol: p0.symbol ?? '')));
                },
                manager: manager,
              );
            },
            separatorBuilder: (context, index) {
              return BaseListDivider();
            },
            itemCount: manager.homeViewMore?.data?.length ?? 0,
          ),
        ),
      ),
    );
  }
}
