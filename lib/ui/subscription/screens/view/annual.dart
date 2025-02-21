import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/base/base_scroll.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';

import '../../model/my_subscription.dart';
import 'item.dart';

class ViewAnnualPlan extends StatelessWidget {
  const ViewAnnualPlan({super.key});

  @override
  Widget build(BuildContext context) {
    SubscriptionManager manager = context.watch<SubscriptionManager>();
    List<ProductPlanRes>? plans = manager.subscriptionData?.annualPlan;
    return Expanded(
      child: BaseScroll(
        children: [
          Column(
            children: List.generate(
              plans?.length ?? 0,
              (index) {
                ProductPlanRes? data = plans?[index];
                if (data == null) {
                  return SizedBox();
                }
                return ViewPlanItem(data: data, index: index);
              },
            ),
          )
        ],
      ),
    );
  }
}
