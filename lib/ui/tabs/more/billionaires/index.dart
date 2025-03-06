import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/billionaires.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/common_tab.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/tabs/more/billionaires/cryptocurrencies/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';

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
    manager.getBillionaires();
  }

  @override
  Widget build(BuildContext context) {
    BillionairesManager manager = context.watch<BillionairesManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: manager.billionairesRes?.title ?? "Billionaires",
      ),
      body: BaseLoaderContainer(
          isLoading: manager.isLoading,
          hasData: manager.billionairesRes != null && !manager.isLoading,
          showPreparingText: true,
          error: manager.error,
          onRefresh: () {
            _callAPI();
          },
          child: BaseScroll(children: [
            BaseTabs(
              data: manager.billionairesRes?.tabs ?? [],
              textStyle:
                  styleBaseBold(fontSize: 16, color: ThemeColors.splashBG),
              onTap: manager.onScreenChange,
              showDivider: false,
              //labelPadding: EdgeInsets.zero,
            ),
            if (manager.selectedScreen == 0)
              Cryptocurrencies(
                billionairesRes: manager.billionairesRes,
              ),
            if (manager.selectedScreen == 1) SizedBox(),
            if (manager.selectedScreen == 2) SizedBox(),
          ])),
    );
  }
}
