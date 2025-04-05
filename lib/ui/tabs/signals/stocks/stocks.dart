import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals/stocks.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import '../../../../models/ticker.dart';
import '../../../../widgets/custom/base_loader_container.dart';
import '../../../base/base_list_divider.dart';
import '../../../base/lock.dart';
import '../../../base/stock/add.dart';

class SignalStocksIndex extends StatefulWidget {
  const SignalStocksIndex({super.key});

  @override
  State<SignalStocksIndex> createState() => _SignalStocksIndexState();
}

class _SignalStocksIndexState extends State<SignalStocksIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    SignalsStocksManager manager = context.read<SignalsStocksManager>();
    manager.getData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentContext!.read<SignalsStocksManager>().clearAllData();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SignalsStocksManager manager = context.watch<SignalsStocksManager>();

    return Stack(
      children: [
        BaseLoaderContainer(
          isLoading: manager.isLoading,
          hasData: manager.data?.data != null,
          showPreparingText: true,
          error: manager.error,
          onRefresh: manager.getData,
          child: BaseLoadMore(
            onRefresh: manager.getData,
            onLoadMore: () async => manager.getData(loadMore: true),
            canLoadMore: manager.canLoadMore,
            child: ListView.separated(
              // shrinkWrap: true,
              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                BaseTickerRes? data = manager.data?.data?[index];
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
              itemCount: manager.data?.data?.length ?? 0,
            ),
          ),
        ),
        BaseLockItem(
          manager: manager,
          callAPI: manager.getData,
        ),
      ],
    );
  }
}
