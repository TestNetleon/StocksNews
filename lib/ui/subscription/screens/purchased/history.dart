import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../base/load_more.dart';
import '../../manager.dart';
import '../../model/my_subscription.dart';
import '../../model/subscription.dart';

class PurchasedHistory extends StatelessWidget {
  const PurchasedHistory({super.key});

  @override
  Widget build(BuildContext context) {
    SubscriptionManager manager = context.watch<SubscriptionManager>();
    PaymentHistory? paymentHistory = manager.mySubscriptionData?.paymentHistory;

    return BaseLoadMore(
      onRefresh: manager.getMyPurchasedData,
      onLoadMore: () async => manager.getMyPurchasedData(loadMore: true),
      canLoadMore: manager.canLoadMoreHistory,
      child: ListView.separated(
        padding: EdgeInsets.only(bottom: 10),
        itemBuilder: (context, index) {
          ProductPlanRes? data = paymentHistory?.data?[index];
          if (data == null) {
            return SizedBox();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      data.purchaseAt ?? '',
                      style: styleBaseRegular(fontSize: 16),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      data.price ?? '',
                      style: styleBaseBold(fontSize: 18),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  '${data.displayName}  ${data.purchaseAt} - ${data.expiredAt}',
                  style: styleBaseRegular(color: ThemeColors.neutral20),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return SpacerVertical(height: 24);
        },
        itemCount: paymentHistory?.data?.length ?? 0,
      ),
    );
  }
}
