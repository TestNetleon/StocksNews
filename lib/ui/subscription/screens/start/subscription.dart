import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

import 'no_subscription.dart';

class SubscriptionIndex extends StatefulWidget {
  final SubscriptionDefault? defaultSelected;
  static const path = 'SubscriptionIndex';
  const SubscriptionIndex({super.key, this.defaultSelected});

  @override
  State<SubscriptionIndex> createState() => _SubscriptionIndexState();
}

class _SubscriptionIndexState extends State<SubscriptionIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionManager>().getSubscriptionData();
    });
  }

  @override
  Widget build(BuildContext context) {
    SubscriptionManager manager = context.watch<SubscriptionManager>();
    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: manager.subscriptionData?.title,
      ),
      body: BaseLoaderContainer(
        hasData: !manager.isLoading,
        isLoading: manager.isLoading,
        showPreparingText: true,
        child: NoSubscription(),
      ),
    );
  }
}
