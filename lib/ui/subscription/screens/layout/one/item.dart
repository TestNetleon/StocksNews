import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/ui/subscription/manager.dart';
import 'package:stocks_news_new/ui/subscription/model/subscription.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';

class LayoutOneItem extends StatelessWidget {
  final ProductPlanRes planData;
  const LayoutOneItem({super.key, required this.planData});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionManager>(
      builder: (context, manager, child) {
        return Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: ThemeColors.background,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: double.infinity,
            child: Row(
              children: [
                Visibility(
                  visible: planData.currentPlan != true,
                  child: Container(
                    decoration: BoxDecoration(
                      color: manager.selectedPlan == planData
                          ? ThemeColors.accent
                          : ThemeColors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: manager.selectedPlan == planData
                            ? Colors.transparent
                            : ThemeColors.greyBorder,
                        width: 2,
                      ),
                    ),
                    padding: EdgeInsets.all(3),
                    child: Icon(
                      Icons.check,
                      color: manager.selectedPlan == planData
                          ? ThemeColors.background
                          : ThemeColors.transparent,
                      size: 20,
                    ),
                  ),
                ),
                SpacerHorizontal(width: 15),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        planData.displayName ?? '',
                        style: styleBaseBold(
                          color: ThemeColors.accent,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Just ${planData.price}',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: ThemeColors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          children: [
                            TextSpan(
                              text: ' ${planData.periodText}',
                              style: styleBaseRegular(
                                  fontSize: 14,
                                  height: 1.6,
                                  color: ThemeColors.neutral5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
