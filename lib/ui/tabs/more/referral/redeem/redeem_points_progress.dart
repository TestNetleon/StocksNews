import 'package:flutter/material.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';

class RedeemPointsProgress extends StatelessWidget {
  const RedeemPointsProgress({
    super.key,
    required this.total,
    required this.claimed,
  });

  final int total, claimed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double claimedWidth =
          claimed == 0 ? 0 : (constraints.maxWidth * (claimed / total));

      return Container(
        height: 10,
        decoration: BoxDecoration(
          color: ThemeColors.neutral5,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.all(Pad.pad2),
        alignment: Alignment.centerLeft,
        child: Container(
          width: claimedWidth,
          height: 8,
          decoration: BoxDecoration(
            color: ThemeColors.success100,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
    });
  }
}
