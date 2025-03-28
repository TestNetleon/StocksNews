import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/converter/index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/exchange/index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/myWatchlist/index.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class BillionairesIndex extends StatefulWidget {
  static const path = 'BillionairesIndex';

  const BillionairesIndex({super.key});

  @override
  State<BillionairesIndex> createState() => _BillionairesIndexState();
}

class _BillionairesIndexState extends State<BillionairesIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    BillionairesManager manager = context.read<BillionairesManager>();
    manager.getTabs();
  }

  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: !manager.isLoading ? manager.categoriesData?.title ?? "" : "",
        showSearch: true,
        showNotification: true,
      ),
      body: BaseLoaderContainer(
          isLoading: manager.isLoading,
          hasData: manager.categoriesData != null && !manager.isLoading,
          showPreparingText: true,
          error: manager.error,
          onRefresh: () {
            _callAPI();
          },
          child: Column(
            children: [
              BaseTabs(
                data: manager.categoriesData?.data ?? [],
                onTap: manager.onScreenChange,
                isScrollable:
                    manager.categoriesData?.data?.length == 2 ? false : true,
                showDivider: false,
              ),
              SpacerVertical(height: Pad.pad10),
              if (manager.selectedScreen == 0)
                Expanded(child: Cryptocurrencies()),
              if (manager.selectedScreen == 1)
                Expanded(child: MyWatchListIndex()),
              if (manager.selectedScreen == 2)
                Expanded(child: ConverterIndex()),
              if (manager.selectedScreen == 3) Expanded(child: ExchangeIndex())
            ],
          )),
    );
  }
}
