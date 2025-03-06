import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/managers/aiAnalysis/ai.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/constants.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../models/ai_analysis.dart';
import '../../../models/stockDetail/overview.dart';
import 'item.dart';

class AIHighlights extends StatelessWidget {
  const AIHighlights({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AIManager aiManager = context.watch<AIManager>();
    AIHighlightsRes? highlights = aiManager.data?.highlights;
    List<BaseKeyValueRes>? list = highlights?.data;
    if (list?.isEmpty == true || list == null) {
      return SizedBox();
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Pad.pad16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacerVertical(height: 24),
          BaseHeading(title: highlights?.title),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicHeight(
              child: Row(
                children: List.generate(
                  list.length,
                  (index) {
                    BaseKeyValueRes data = list[index];

                    return Container(
                      width: 200.sp,
                      margin: const EdgeInsets.only(right: 16),
                      child: AIHighlightsItem(data: data),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
