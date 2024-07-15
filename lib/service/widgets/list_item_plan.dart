import 'package:flutter/material.dart';
import 'package:stocks_news_new/modals/plans_res.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

class ListItemPlan extends StatelessWidget {
  final Plan plan;
  const ListItemPlan({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: ThemeColors.themeGreen),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  plan.name,
                  style: styleGeorgiaBold(fontSize: 24),
                ),
              ),
              Text(
                plan.price ?? "",
                style: styleGeorgiaBold(fontSize: 18),
              ),
            ],
          ),
          const SpacerVertical(height: 12),
          if (plan.text != null)
            Text(
              plan.text ?? "",
              style: styleGeorgiaRegular(height: 1.3),
            ),
          if (plan.detail != null)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    const Icon(Icons.circle, size: 12),
                    const SpacerHorizontal(width: 12),
                    Flexible(
                      child: Text(
                        plan.detail?[index] ?? "",
                        style: styleGeorgiaRegular(height: 1.3),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const SpacerVertical(height: 5);
              },
              itemCount: plan.detail?.length ?? 0,
            )
        ],
      ),
    );
  }
}
