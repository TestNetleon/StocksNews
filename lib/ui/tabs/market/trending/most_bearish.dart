import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/market/trending/most_bearish.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/base/stock/add.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class MostBearish extends StatefulWidget {
  const MostBearish({super.key});

  @override
  State<MostBearish> createState() => _MostBearishState();
}

class _MostBearishState extends State<MostBearish> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  Future _callAPI() async {
    MostBearishManager manager = context.read<MostBearishManager>();
    await manager.getData();
  }

  @override
  Widget build(BuildContext context) {
    MostBearishManager manager = context.watch<MostBearishManager>();

    Utils().showLog("Length  => ${manager.data?.data?.length ?? 0}");

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
                  );
                },
                separatorBuilder: (context, index) {
                  return BaseListDivider();
                },
                itemCount: manager.data!.data?.length ?? 0,
              ),
      ),
    );
  }
}
