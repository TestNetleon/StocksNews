import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals/insiders.dart';
import 'package:stocks_news_new/models/my_home.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';

import '../../../../widgets/custom/base_loader_container.dart';
import '../../../base/base_list_divider.dart';
import '../../../base/lock.dart';
import 'item.dart';

class SignalInsidersIndex extends StatefulWidget {
  const SignalInsidersIndex({super.key});

  @override
  State<SignalInsidersIndex> createState() => _SignalInsidersIndexState();
}

class _SignalInsidersIndexState extends State<SignalInsidersIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    SignalsInsiderManager manager = context.read<SignalsInsiderManager>();
    manager.getData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentContext!.read<SignalsInsiderManager>().clearAllData();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SignalsInsiderManager manager = context.watch<SignalsInsiderManager>();

    return Stack(
      children: [
        BaseLoaderContainer(
          isLoading: manager.isLoading,
          hasData: manager.data?.data != null &&
              manager.data?.data?.isNotEmpty == true,
          showPreparingText: true,
          error: manager.error,
          onRefresh: manager.getData,
          child: BaseLoadMore(
            onRefresh: manager.getData,
            onLoadMore: () async => manager.getData(loadMore: true),
            canLoadMore: manager.canLoadMore,
            child: ListView.separated(
              itemBuilder: (context, index) {
                InsiderTradeRes? data = manager.data?.data?[index];
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
