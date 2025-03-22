import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals.dart';
import 'package:stocks_news_new/models/my_home_premium.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/tabs/signals/politicians/item.dart';

import '../../../../widgets/custom/base_loader_container.dart';
import '../../../base/base_list_divider.dart';
import '../../../base/lock.dart';

class SignalPoliticiansIndex extends StatelessWidget {
  const SignalPoliticiansIndex({super.key});

  @override
  Widget build(BuildContext context) {
    SignalsManager manager = context.watch<SignalsManager>();

    return Stack(
      children: [
        BaseLoaderContainer(
          isLoading: manager.isLoadingPolitician,
          hasData: manager.signalPoliticianData?.data != null &&
              manager.signalPoliticianData?.data?.isNotEmpty == true,
          showPreparingText: true,
          error: manager.errorPolitician,
          onRefresh: manager.getPoliticianData,
          child: BaseLoadMore(
            onRefresh: manager.getPoliticianData,
            onLoadMore: () async => manager.getPoliticianData(loadMore: true),
            canLoadMore: manager.canLoadMorePolitician,
            child: ListView.separated(
              itemBuilder: (context, index) {
                PoliticianTradeRes? data =
                    manager.signalPoliticianData?.data?[index];
                bool isOpen = manager.openIndexPolitician == index;
                if (data == null) {
                  return SizedBox();
                }
                return BasePoliticianItem(
                  data: data,
                  isOpen: isOpen,
                  onTap: () => manager.openMorePolitician(isOpen ? -1 : index),
                );
              },
              separatorBuilder: (context, index) {
                return BaseListDivider();
              },
              itemCount: manager.signalPoliticianData?.data?.length ?? 0,
            ),
          ),
        ),
        BaseLockItem(
          manager: manager,
          callAPI: manager.getPoliticianData,
        ),
      ],
    );
  }
}
