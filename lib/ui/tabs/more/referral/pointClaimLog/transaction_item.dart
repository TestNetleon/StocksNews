import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/models/referral/referral_points_res.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/ui/theme/manager.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class ReferPointTransactionItem extends StatelessWidget {
  const ReferPointTransactionItem({super.key, required this.data});
  final ReferralPoints data;

  @override
  Widget build(BuildContext context) {
    bool isDark = context.read<ThemeManager>().isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.white,
        border: Border.all(
          width: 1,
          color: Color(0xFFEFEFEF).withValues(alpha: .5),
        ),
        borderRadius: BorderRadius.circular(Dimen.radius),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: ThemeColors.lightGrey.withValues(alpha: 1),
                  offset: Offset(10, 10),
                  blurRadius: 50.0,
                  spreadRadius: 2.0,
                ),
              ],
      ),
      padding: EdgeInsets.all(Dimen.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: Consumer<ThemeManager>(builder: (context, value, child) {
                  bool isDark = value.isDarkMode;
                  return BaseBorderContainer(
                    padding: EdgeInsets.zero,
                    innerPadding: EdgeInsets.all(0),
                    borderColor: isDark ? ThemeColors.black : null,
                    child: Image.asset(
                      Images.bottomSignals,
                      color: ThemeColors.neutral20,
                    ),
                  );
                }),
              ),
              SpacerHorizontal(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.label ?? "",
                      style: styleBaseBold(
                        fontSize: 14,
                        color: ThemeColors.black,
                        height: 1.4,
                      ),
                    ),
                    Text(
                      data.createdAt ?? "",
                      style: styleBaseRegular(
                        fontSize: 12,
                        color: ThemeColors.neutral40,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "${data.spent > 0 ? '-' : '+'}${data.spent > 0 ? data.spent : data.earn}",
                style: styleBaseBold(
                  fontSize: 14,
                  color: data.spent > 0
                      ? ThemeColors.error120
                      : ThemeColors.success120,
                ),
              ),
            ],
          ),
          SpacerVertical(height: 8),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              children: [
                TextSpan(
                  text: data.txnDetail ?? "",
                  style: styleBaseBold(
                    fontSize: 12,
                    color: ThemeColors.neutral40,
                  ),
                ),
                TextSpan(
                  text: data.title ?? "",
                  style: styleBaseRegular(
                    fontSize: 12,
                    color: ThemeColors.neutral40,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
