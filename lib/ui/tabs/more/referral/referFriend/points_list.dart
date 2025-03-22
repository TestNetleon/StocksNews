import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/referral/referral_manager.dart';
import 'package:stocks_news_new/models/referral/referral_response.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/button.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/pointsTransaction/index.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/redeem/index.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/referFriend/pending_friend_item.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class PointsList extends StatelessWidget {
  final List<ReferralPointRes>? data;

  const PointsList({
    super.key,
    required this.data,
  });

  void _navigateToTransactions(context) {
    Navigator.pushNamed(
      context,
      ReferPointsTransaction.path,
      arguments: {"type": "", "title": null},
    );
  }

  void _navigateToRedeem(context) {
    Navigator.pushNamed(
      context,
      RedeemPoints.path,
      arguments: {"type": "", "title": null},
    );
  }

  @override
  Widget build(BuildContext context) {
    ReferralManager manager = context.watch<ReferralManager>();

    return Visibility(
      visible: data != null,
      child: Column(
        children: [
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              ReferralPointRes? item = data?[index];
              return PointsListItem(
                data: item!,
                onTap: () {
                  if (item.txnType != null && item.txnType != "") {
                    Navigator.pushNamed(
                      context,
                      ReferPointsTransaction.path,
                      arguments: {"type": item.txnType, "title": item.title},
                    );
                  }
                },
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox();
            },
            itemCount: data?.length ?? 0,
          ),
          SpacerVertical(height: Dimen.padding),
          BaseButton(
            margin: EdgeInsets.all(16),
            onPressed: () => _navigateToTransactions(context),
            text: "View Points Transactions",
          ),
          BaseButton(
            margin: EdgeInsets.symmetric(horizontal: 16),
            onPressed: () => _navigateToRedeem(context),
            text: "Claim Your Rewards",
          ),
          SpacerVertical(height: Dimen.padding),
          BaseHeading(
            title: manager.data?.pendingFriends?.title ?? "",
            subtitle: manager.data?.pendingFriends?.subTitle ?? "",
          ),
          SpacerVertical(height: Dimen.padding),
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              PendingFriendData item =
                  manager.data!.pendingFriends!.data![index];
              return PendingFriendItem(data: item);
            },
            separatorBuilder: (context, index) {
              return SpacerVertical(height: Pad.pad16);
            },
            itemCount: manager.data?.pendingFriends?.data?.length ?? 0,
          ),
        ],
      ),
    );
  }
}

class PointsListItem extends StatelessWidget {
  final ReferralPointRes data;
  final Function() onTap;
  const PointsListItem({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.network(
                    data.icon ?? "",
                    color: ThemeColors.black,
                  ),
                ),
                SpacerHorizontal(width: 12),
                Expanded(
                  child: Text(
                    data.title ?? "",
                    style: styleBaseRegular(fontSize: 16),
                  ),
                ),
                SpacerHorizontal(width: 16),
                Consumer<ThemeManager>(builder: (context, value, child) {
                  bool isDark = value.isDarkMode;
                  return Text(
                    "${data.value}",
                    style: styleBaseBold(
                      fontSize: 14,
                      color:
                          isDark ? ThemeColors.black : ThemeColors.secondary120,
                    ),
                  );
                })
              ],
            ),
          ),
          BaseListDivider(),
        ],
      ),
    );
  }
}
