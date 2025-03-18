import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/ui/subscription/model/layout_one.dart';
import 'package:stocks_news_new/ui/subscription/model/subscription.dart';
import 'package:stocks_news_new/ui/subscription/screens/layout/extra/features.dart';
import 'item.dart';

class LayoutOnePlans extends StatelessWidget {
  final LayoutDataRes? data;
  const LayoutOnePlans({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            MembershipFeatures(features: data?.features),
            Column(
              children: List.generate(
                data?.data?.length ?? 0,
                (index) {
                  ProductPlanRes? planData = data?.data?[index];
                  if (planData == null) {
                    return SizedBox();
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    margin: EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                        onTap: planData.currentPlan == true
                            ? null
                            : () {
                                context
                                    .read<SubscriptionManager>()
                                    .onChangePlan(planData);
                              },
                        child: LayoutOneItem(planData: planData)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
