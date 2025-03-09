import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals.dart';
import 'package:stocks_news_new/models/my_home.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';

import '../../../../widgets/custom/base_loader_container.dart';
import '../../../base/base_list_divider.dart';
import '../../../base/lock.dart';
import 'item.dart';

class SignalInsidersIndex extends StatelessWidget {
  const SignalInsidersIndex({super.key});

  @override
  Widget build(BuildContext context) {
    SignalsManager manager = context.watch<SignalsManager>();

    return BaseLoaderContainer(
      isLoading: manager.isLoadingInsiders,
      hasData: manager.signalInsidersData?.data != null &&
          manager.signalInsidersData?.data?.isNotEmpty == true,
      showPreparingText: true,
      error: manager.errorInsiders,
      onRefresh: manager.getInsidersData,
      child: Stack(
        children: [
          BaseLoadMore(
            onRefresh: manager.getInsidersData,
            onLoadMore: () async => manager.getInsidersData(loadMore: true),
            canLoadMore: manager.canLoadMoreInsiders,
            child: ListView.separated(
              itemBuilder: (context, index) {
                InsiderTradeRes? data =
                    manager.signalInsidersData?.data?[index];
                bool isOpen = manager.openIndex == index;
                if (data == null) {
                  return SizedBox();
                }
                return BaseInsiderItem(
                  data: data,
                  isOpen: isOpen,
                  onTap: () => manager.openMore(isOpen ? -1 : index),
                );
              },
              separatorBuilder: (context, index) {
                return BaseListDivider();
              },
              itemCount: manager.signalInsidersData?.data?.length ?? 0,
            ),
          ),
          BaseLockItem(
            manager: manager,
            callAPI: manager.getInsidersData,
          ),
        ],
      ),
    );
  }
}
