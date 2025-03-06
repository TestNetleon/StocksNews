import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/index.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/myWatchlist/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
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
        title: manager.categoriesData?.title ?? "Billionaires",
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
                isScrollable: manager.categoriesData?.data?.length == 2
                    ? false
                    : true,
                showDivider: false,
              ),
              SpacerVertical(height: Pad.pad10),
              Expanded(
                  child: BaseScroll(
                    margin: EdgeInsets.zero,
                      //onRefresh: manager.getCryptoCurrencies,
                      children: [
                if (manager.selectedScreen == 0)
                  Cryptocurrencies(),
                if (manager.selectedScreen == 1) MyWatchListIndex(),
                if (manager.selectedScreen == 2) SizedBox(),
              ]))
            ],
          )),
    );
  }
}
