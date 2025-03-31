import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/alerts.dart';
import 'package:stocks_news_new/models/ticker.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/no_item.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/base/stock/edit.dart';
import 'package:stocks_news_new/ui/stockDetail/index.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../base/load_more.dart';

class AlertIndex extends StatefulWidget {
  static const String path = "Alerts";
  const AlertIndex({super.key});

  @override
  State<AlertIndex> createState() => _AlertIndexState();
}

class _AlertIndexState extends State<AlertIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    AlertsM manager = context.read<AlertsM>();
    manager.getAlerts(showProgress: false);
  }

  @override
  Widget build(BuildContext context) {
    AlertsM manager = context.watch<AlertsM>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: manager.alertData?.title ?? "",
        showSearch: true,
        showNotification: true,
      ),
      body: Consumer<ThemeManager>(
        builder: (context, value, child) {
          return BaseLoaderContainer(
            isLoading: manager.isLoading,
            hasData: manager.alertData != null && !manager.isLoading,
            showPreparingText: true,
            error: manager.error,
            onRefresh: () {
              _callAPI();
            },
            child: manager.alertData?.noDataRes != null
                ? BaseNoItem(
                    noDataRes: manager.alertData?.noDataRes,
                    onTap: () {
                      manager.redirectToMarket();
                    })
                : Column(
                    children: [
                      Visibility(
                        visible: manager.alertData?.subTitle != '',
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Pad.pad16, vertical: Pad.pad8),
                          child: Text(
                            textAlign: TextAlign.start,
                            manager.alertData?.subTitle ?? "",
                            style: styleBaseRegular(
                                fontSize: 16,
                                color: ThemeColors.neutral80,
                                height: 1.6),
                          ),
                        ),
                      ),
                      SpacerVertical(height: 10),
                      Expanded(
                        child: BaseLoadMore(
                          onRefresh: manager.getAlerts,
                          onLoadMore: () async =>
                              manager.getAlerts(loadMore: true),
                          canLoadMore: manager.canLoadMore,
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Pad.pad3),
                            itemBuilder: (context, index) {
                              BaseTickerRes? data =
                                  manager.alertData?.alerts?[index];
                              if (data == null) {
                                return SizedBox();
                              }
                              return BaseStockEditItem(
                                data: data,
                                deleteDataRes: manager.alertData?.deleteBox,
                                index: index,
                                onTap: (p0) {
                                  Navigator.pushNamed(context, SDIndex.path,
                                      arguments: {'symbol': p0.symbol});
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return BaseListDivider();
                            },
                            itemCount: manager.alertData?.alerts?.length ?? 0,
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
