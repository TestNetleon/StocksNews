import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/referral/referral_response.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/pointsTransaction/index.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class PointsList extends StatelessWidget {
  final List<ReferralPointRes>? data;

  const PointsList({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: data != null,
      child: ListView.separated(
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
                  child: Image.network(data.icon ?? ""),
                ),
                SpacerHorizontal(width: 12),
                Expanded(
                  child: Text(
                    data.title ?? "",
                    style: styleBaseRegular(fontSize: 16),
                  ),
                ),
                SpacerHorizontal(width: 16),
                Text(
                  "${data.value}",
                  style: styleBaseBold(
                    fontSize: 14,
                    color: ThemeColors.secondary100,
                  ),
                )
              ],
            ),
          ),
          BaseListDivider(),
        ],
      ),
    );
  }
}
