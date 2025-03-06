import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/managers/s_transaction.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/models/ts_pending_list_res.dart';
import 'package:stocks_news_new/ui/tabs/tools/simulator/screens/transactions/item.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/utils.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class STransactionList extends StatefulWidget {
  const STransactionList({super.key});

  @override
  State<STransactionList> createState() => _STransactionListState();
}

class _STransactionListState extends State<STransactionList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future _getData({loadMore = false}) async {
    STransactionManager manager = context.read<STransactionManager>();
    await manager.getData(loadMore: loadMore);
  }

  @override
  void dispose() {
    Utils().showLog("TRANSACTIONS CLOSED");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    STransactionManager manager = context.watch<STransactionManager>();

    return BaseLoaderContainer(
      hasData: manager.data != null && !manager.isLoading,
      isLoading: manager.isLoading,
      error: manager.error,
      onRefresh: _getData,
      showPreparingText: true,
      child: BaseLoadMore(
        onRefresh: () async {
          await _getData();
        },
        canLoadMore: manager.canLoadMore,
        onLoadMore: () async => await _getData(loadMore: true),
        child: ListView.separated(
          itemBuilder: (context, index) {
            TsPendingListRes? item = manager.data?[index];
            if (item == null) {
              return SizedBox();
            }
            return TsTransactionListItem(
              item: item,
              onTap: () {},
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
                height: 24, thickness: 1, color: ThemeColors.neutral5);
          },
          itemCount: manager.data?.length ?? 0,
        ),
      ),
    );
  }
}
