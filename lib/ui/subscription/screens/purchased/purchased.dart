import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/custom/base_loader_container.dart';

import '../../model/subscription.dart';
import 'history.dart';
import 'purchased_item.dart';

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
      context.read<SubscriptionManager>().getMyPurchasedData();
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
        hasData: manager.mySubscriptionData != null,
        isLoading: manager.isLoading,
        showPreparingText: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Pad.pad16),
          child: Column(
            children: [
              PurchasedPlanItem(
                data: ProductPlanRes(
                  displayName: 'Basic',
                  text:
                      'Get started with the essentials to stay informed and make smarter trading decisions.',
                  price: '\$ 9.99',
                  periodText: '/mo',
                ),
                index: 0,
              ),
              Expanded(
                child: BaseScroll(
                  margin: EdgeInsets.zero,
                  children: [
                    BaseHeading(
                      title: 'Payment History',
                      titleStyle: styleBaseBold(fontSize: 20),
                      margin: EdgeInsets.only(bottom: 10),
                    ),
                    PurchasedHistory(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
