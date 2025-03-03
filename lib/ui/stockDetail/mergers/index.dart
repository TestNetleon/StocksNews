import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/stockDetail/stock.detail.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/stockDetail/mergers/item.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/custom/refresh_indicator.dart';
import '../../../models/stockDetail/mergers.dart';

class SDMergers extends StatelessWidget {
  const SDMergers({super.key});

  @override
  Widget build(BuildContext context) {
    SDManager manager = context.watch<SDManager>();
    return BaseLoaderContainer(
      hasData: manager.dataMergers != null,
      isLoading: manager.isLoadingMergers,
      error: manager.errorMergers,
      onRefresh: manager.onSelectedTabRefresh,
      showPreparingText: true,
      child: CommonRefreshIndicator(
        onRefresh: manager.onSelectedTabRefresh,
        child: ListView.separated(
          itemBuilder: (context, index) {
            MergersDataRes? data = manager.dataMergers?.mergersList?[index];
            if (data == null) {
              return SizedBox();
            }
            bool isOpen = manager.openMergers == index;

            return SDMergersItem(
              data: data,
              isOpen: isOpen,
              onTap: () => manager.openMergersIndex(isOpen ? -1 : index),
            );
          },
          separatorBuilder: (context, index) {
            return BaseListDivider();
          },
          itemCount: manager.dataMergers?.mergersList?.length ?? 0,
        ),
      ),
    );
  }
}
