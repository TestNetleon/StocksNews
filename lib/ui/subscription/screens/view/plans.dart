import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/service/braze/service.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/subscription/screens/layout/one/layout_one.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';
import 'package:stocks_news_new/widgets/loading.dart';

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
      context.read<SubscriptionManager>().getSubscriptionData();
      BrazeService.membershipVisit();
    });
  }

  @override
  Widget build(BuildContext context) {
    // SubscriptionManager manager = context.watch<SubscriptionManager>();

    // return BaseScaffold(
    //   appBar: BaseAppBar(showBack: true),
    //   body: BaseLoaderContainer(
    //     hasData: !manager.isLoading,
    //     isLoading: manager.isLoading,
    //     showPreparingText: true,
    //     child: ViewAllPlans(),
    //   ),
    // );

    return Consumer<SubscriptionManager>(
      builder: (context, value, child) {
        if (value.isLoading) {
          return BaseScaffold(body: Loading());
        }

        if (value.layoutData?.membershipLayout == 1) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                Images.layout1,
                fit: BoxFit.cover,
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(child: SubscriptionLayoutOne()),
              ),
            ],
          );
        }

        return BaseScaffold(
          appBar: BaseAppBar(showBack: true),
          body: BaseLoaderContainer(
            hasData: !value.isLoading,
            isLoading: value.isLoading,
            showPreparingText: true,
            child: ViewAllPlans(),
          ),
        );
      },
    );
  }
}
