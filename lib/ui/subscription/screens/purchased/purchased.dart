import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

class PurchasedIndex extends StatefulWidget {
  static const path = 'PurchasedIndex';
  const PurchasedIndex({super.key});

  @override
  State<PurchasedIndex> createState() => _PurchasedIndexState();
}

class _PurchasedIndexState extends State<PurchasedIndex> {
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
        child: Container(),
      ),
    );
  }
}
