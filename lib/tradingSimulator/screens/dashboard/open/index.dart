import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/tradingSimulator/modals/ts_open_list_res.dart';
import 'package:stocks_news_new/tradingSimulator/providers/ts_open_list_provider.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/open/item.dart';
import 'package:stocks_news_new/tradingSimulator/screens/dashboard/tradeSheet.dart';
import 'package:stocks_news_new/utils/constants.dart';

import 'package:stocks_news_new/widgets/base_ui_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class TsOpenList extends StatefulWidget {
  const TsOpenList({super.key});

  @override
  State<TsOpenList> createState() => _TsOpenListState();
}

class _TsOpenListState extends State<TsOpenList> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _getData();
  //   });
  // }

  Future _getData() async {
    TsOpenListProvider provider = context.read<TsOpenListProvider>();
    await provider.getData();
  }

  @override
  Widget build(BuildContext context) {
    TsOpenListProvider provider = context.watch<TsOpenListProvider>();

    return BaseUiContainer(
      hasData: provider.data != null && !provider.isLoading,
      isLoading: provider.isLoading || provider.status == Status.ideal,
      error: provider.error,
      errorDispCommon: false,
      onRefresh: _getData,
      showPreparingText: true,
      child:
          // provider.data==null
          //   ? const SummaryErrorWidget(title: "No open orders")
          //   :
          CommonRefreshIndicator(
        onRefresh: _getData,
        child: ListView.separated(
          itemBuilder: (context, index) {
            TsOpenListRes item = provider.data![index];
            return TsOpenListItem(
              item: item,
              onTap: () {
                tradeSheet(
                  symbol: item.symbol,
                  doPop: false,
                  qty: item.quantity,
                );
              },
            );
          },
          separatorBuilder: (context, index) {
            return const SpacerVertical();
          },
          itemCount: provider.data?.length ?? 0,
        ),
      ),
    );
  }
}
