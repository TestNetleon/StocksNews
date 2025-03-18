import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:stocks_news_new/ui/base/app_bar.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/base/scaffold.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/utils/utils.dart';
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
    ProductPlanRes? activeMembership =
        manager.mySubscriptionData?.activeMembership;

    return BaseScaffold(
      appBar: BaseAppBar(
        showBack: true,
        title: manager.subscriptionData?.title,
      ),
      body: BaseLoaderContainer(
        hasData: manager.mySubscriptionData != null,
        isLoading: manager.isLoadingPurchased,
        showPreparingText: true,
        error: manager.error,
        onRefresh: manager.getMyPurchasedData,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Pad.pad16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (activeMembership != null)
                PurchasedPlanItem(data: activeMembership, index: 0),
              BaseHeading(
                title: manager.mySubscriptionData?.paymentHistory?.title,
                titleStyle: styleBaseBold(fontSize: 20),
                margin: EdgeInsets.only(bottom: 10),
              ),
              Expanded(child: PurchasedHistory()),
              // BaseButton(
              //   text: 'See all Plans',
              //   onPressed: () {
              //     Navigator.pushNamed(context, SubscriptionPlansIndex.path);
              //   },
              // ),
              BaseButton(
                text: 'Manage Subscription',
                onPressed: () async {
                  CustomerInfo info = await Purchases.getCustomerInfo();
                  openUrl(info.managementURL);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
