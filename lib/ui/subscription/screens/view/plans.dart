import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

import '../../manager.dart';
import 'view_plans.dart';

class SubscriptionPlansIndex extends StatefulWidget {
  static const path = 'SubscriptionPlansIndex';
  const SubscriptionPlansIndex({super.key});

  @override
  State<SubscriptionPlansIndex> createState() => _SubscriptionPlansIndexState();
}

class _SubscriptionPlansIndexState extends State<SubscriptionPlansIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionManager>().startProcess();
    });
  }

  @override
  Widget build(BuildContext context) {
    SubscriptionManager manager = context.watch<SubscriptionManager>();

    return BaseScaffold(
      appBar: BaseAppBar(showBack: true),
      body: BaseLoaderContainer(
        hasData: !manager.isLoading,
        isLoading: manager.isLoading,
        showPreparingText: true,
        child: ViewAllPlans(),
      ),
    );
  }
}
