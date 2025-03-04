import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/todays_gainer.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/stock/add.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class TodaysGainer extends StatefulWidget {
  const TodaysGainer({super.key});

  @override
  State<TodaysGainer> createState() => _TodaysGainerState();
}

class _TodaysGainerState extends State<TodaysGainer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI() async {
    TodaysGainerManager manager = context.read<TodaysGainerManager>();
    await manager.getData();
  }

  @override
  Widget build(BuildContext context) {
    TodaysGainerManager manager = context.watch<TodaysGainerManager>();
    return BaseLoaderContainer(
      isLoading: manager.isLoading,
      hasData: manager.data != null && !manager.isLoading,
      showPreparingText: true,
      error: manager.error,
      onRefresh: _callAPI,
      child: BaseLoadMore(
        onLoadMore: () async {},
        onRefresh: _callAPI,
        canLoadMore: false,
        child: (manager.data == null || manager.data?.mostBullish == null)
            ? const SizedBox()
            : ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return BaseStockAddItem(
                    data: manager.data!.mostBullish![index],
                    index: index,
                    onRefresh: _callAPI,
                    manager: manager,
                  );
                },
                separatorBuilder: (context, index) {
                  return BaseListDivider();
                },
                itemCount: manager.data!.mostBullish?.length ?? 0,
              ),
      ),
    );
  }
}
