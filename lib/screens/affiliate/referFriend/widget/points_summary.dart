import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/leaderboard.dart';
import 'package:stocks_news_new/screens/affiliate/referFriend/trasnsaction.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class PointsSummary extends StatelessWidget {
  const PointsSummary({super.key});

  @override
  Widget build(BuildContext context) {
    LeaderBoardProvider provider = context.watch<LeaderBoardProvider>();

    return Visibility(
      visible: (provider.data?.length ?? 0) != 0 ||
          (provider.extra?.received ?? 0) != 0 ||
          (provider.extra?.totalActivityPoints ?? 0) != 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Points Summary",
            style: stylePTSansBold(fontSize: 25),
          ),
          const SpacerVertical(height: 15),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color.fromARGB(255, 17, 17, 17),
              border: Border.all(
                color: const Color.fromARGB(255, 29, 29, 29),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    15,
                    20,
                    20,
                  ),
                  child: Column(
                    children: [
                      PointSummaryItem(
                        icon: Image.asset(Images.referPoint, width: 24),
                        label: "Referral Points",
                        value: "${provider.data?.length ?? 0}",
                      ),
                      Visibility(
                        visible:
                            provider.verified != 0 || provider.unVerified != 0,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Visibility(
                                visible: provider.verified != 0,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    right: 5,
                                  ),
                                  child: Text(
                                    "Verified: ${provider.verified}${provider.unVerified != 0 ? "," : ""}",
                                    style: stylePTSansRegular(
                                      color: ThemeColors.accent,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: provider.unVerified != 0,
                                child: Text(
                                  "Unverified: ${provider.unVerified}",
                                  style: stylePTSansRegular(
                                    color: ThemeColors.sos,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 56, 56, 56),
                        height: 25,
                      ),
                      PointSummaryItem(
                        icon: Container(
                          height: 24,
                          width: 24,
                          padding: const EdgeInsets.all(2),
                          child: Image.asset(
                            Images.activityPoints,
                            width: 22,
                            color: Colors.amber,
                          ),
                        ),
                        label: "Activity Points",
                        value: "${provider.extra?.totalActivityPoints ?? 0}",
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 56, 56, 56),
                        height: 25,
                      ),
                      PointSummaryItem(
                        icon: Image.asset(
                          Images.totalPoint,
                          width: 24,
                          color: Colors.amber,
                        ),
                        label: "Total Points",
                        value: "${provider.extra?.received ?? 0}",
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 56, 56, 56),
                        height: 25,
                      ),
                      PointSummaryItem(
                        icon: Image.asset(
                          Images.pointSpent,
                          width: 24,
                          color: Colors.red,
                        ),
                        label: "Points Spent",
                        value: "${provider.extra?.spent ?? 0}",
                      ),
                      const Divider(
                        color: Color.fromARGB(255, 56, 56, 56),
                        height: 25,
                      ),
                      PointSummaryItem(
                        icon: Image.asset(Images.totalPoints, width: 24),
                        label: "Balance Points",
                        value: "${provider.extra?.balance ?? 0}",
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AffiliateTransaction(),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 29, 29, 29),
                        ),
                        left: BorderSide(
                          color: Color.fromARGB(255, 29, 29, 29),
                        ),
                        right: BorderSide(
                          color: Color.fromARGB(255, 29, 29, 29),
                        ),
                      ),
                      color: Color.fromARGB(255, 25, 25, 25),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Images.transaction,
                          height: 20,
                          width: 20,
                          color: ThemeColors.accent,
                        ),
                        const SpacerHorizontal(width: 5),
                        Flexible(
                          child: Text(
                            "View Points Transactions",
                            style: stylePTSansBold(
                              fontSize: 14,
                              color: ThemeColors.accent,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PointSummaryItem extends StatelessWidget {
  const PointSummaryItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Icon(icon, color: Colors.green),
        // Image.asset(icon, width: 24),
        icon,
        const SpacerHorizontal(width: 12),
        Expanded(
          child: Text(
            label,
            style: stylePTSansRegular(fontSize: 17),
          ),
        ),
        const SpacerVertical(height: 10),
        Text(
          value,
          style: stylePTSansBold(fontSize: 17),
        ),
      ],
    );
  }
}
