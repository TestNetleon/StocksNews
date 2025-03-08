import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/referral/redeem_manager.dart';
import 'package:stocks_news_new/models/referral/redeem_list_res.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/ui/base/button_small.dart';
import 'package:stocks_news_new/ui/tabs/more/referral/redeem/redeem_points_progress.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class RedeemPointsItem extends StatelessWidget {
  const RedeemPointsItem({super.key, required this.data});
  final RedeemData data;

  void _claimPoints(BuildContext context) {
    RedeemManager manager = context.read<RedeemManager>();
    manager.requestClaimReward(type: data.type);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.white,
        border: Border.all(
          width: 1,
          color: Color(0xFFEFEFEF).withValues(alpha: .5),
        ),
        borderRadius: BorderRadius.circular(Dimen.radius),
        boxShadow: [
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
                child: BaseBorderContainer(
                  padding: EdgeInsets.zero,
                  innerPadding: EdgeInsets.all(0),
                  child: Image.asset(
                    Images.bottomSignals,
                    color: ThemeColors.neutral20,
                  ),
                ),
              ),
              SpacerHorizontal(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title ?? "",
                      style: styleBaseBold(
                        fontSize: 14,
                        color: ThemeColors.black,
                        height: 1.4,
                      ),
                    ),
                    SpacerVertical(height: Pad.pad3),
                    Text(
                      "${data.claimPoints}/${data.targetPoints}",
                      style: styleBaseRegular(
                        fontSize: 12,
                        color: ThemeColors.neutral40,
                        height: 1.4,
                      ),
                    ),
                    SpacerVertical(height: Pad.pad3),
                    RedeemPointsProgress(
                      total: data.targetPoints,
                      claimed: data.claimPoints,
                    ),
                  ],
                ),
              ),
              SpacerHorizontal(width: 8),
              BaseButtonSmall(
                // onPressed: () {
                //   _claimPoints(context);
                // },
                onPressed: data.status == true
                    ? () {
                        _claimPoints(context);
                      }
                    : null,
                text: "Claim",
                disabledBackgroundColor: ThemeColors.disabledBtn.withValues(
                  alpha: .29,
                ),
                disableTextColor: ThemeColors.white,
              ),
            ],
          ),
          SpacerVertical(height: 8),
          HtmlWidget(
            data.text ?? "",
            textStyle: styleBaseRegular(
              fontSize: 12,
              color: ThemeColors.neutral40,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
