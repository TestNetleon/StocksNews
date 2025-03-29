import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/signals/politicians.dart';
import 'package:stocks_news_new/models/my_home_premium.dart';
import 'package:stocks_news_new/routes/my_app.dart';
import 'package:stocks_news_new/ui/base/load_more.dart';
import 'package:stocks_news_new/ui/tabs/signals/politicians/item.dart';

import '../../../../widgets/custom/base_loader_container.dart';
import '../../../base/base_list_divider.dart';
import '../../../base/lock.dart';

class SignalPoliticiansIndex extends StatefulWidget {
  const SignalPoliticiansIndex({super.key});

  @override
  State<SignalPoliticiansIndex> createState() => _SignalPoliticiansIndexState();
}

class _SignalPoliticiansIndexState extends State<SignalPoliticiansIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callAPI();
    });
  }

  void _callAPI() {
    SignalsPoliticianManager manager = context.read<SignalsPoliticianManager>();
    manager.getData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentContext!
          .read<SignalsPoliticianManager>()
          .clearAllData();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SignalsPoliticianManager manager =
        context.watch<SignalsPoliticianManager>();

    return Stack(
      children: [
        BaseLoaderContainer(
          isLoading: manager.isLoading,
          hasData: manager.data?.data != null &&
              manager.data?.data?.isNotEmpty == true,
          showPreparingText: true,
          error: manager.errorPolitician,
          onRefresh: manager.getData,
          child: BaseLoadMore(
            onRefresh: manager.getData,
            onLoadMore: () async => manager.getData(loadMore: true),
            canLoadMore: manager.canLoadMore,
            child: ListView.separated(
              itemBuilder: (context, index) {
                PoliticianTradeRes? data = manager.data?.data?[index];
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
