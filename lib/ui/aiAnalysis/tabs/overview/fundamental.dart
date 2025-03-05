import 'package:flutter/material.dart';
import 'package:stocks_news_new/models/ai_analysis.dart';
import 'package:stocks_news_new/ui/base/border_container.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';

import '../../../../models/stockDetail/overview.dart';
import '../../../../utils/constants.dart';
import '../../../../widgets/custom_gridview.dart';

class AIOverviewFundamentals extends StatelessWidget {
  final AIFundamentalsRes? data;
  const AIOverviewFundamentals({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    List<BaseKeyValueRes>? body = data?.data;

    return Container(
      padding: EdgeInsets.only(
        left: Pad.pad16,
        right: Pad.pad16,
        top: Pad.pad16,
        bottom: Pad.pad10,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseHeading(title: data?.title),
          Wrap(
            runSpacing: 10,
            spacing: 10,
            children: List.generate(
              data?.header?.length ?? 0,
              (index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ThemeColors.neutral5,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    data?.header?[index] ?? '',
                    style: styleBaseRegular(fontSize: 13),
                  ),
                );
              },
            ),
          ),
          SpacerVertical(height: 16),
          CustomGridView(
            length: body?.length ?? 0,
            paddingHorizontal: 0,
            paddingVertical: 10,
            itemSpace: 10,
            getChild: (index) {
              BaseKeyValueRes? data = body?[index];
              if (data == null) {
                return SizedBox();
              }
              return BaseBorderContainer(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data.value}',
                      style: styleBaseRegular(
                        fontSize: 13,
                        color: ThemeColors.neutral80,
                      ),
                    ),
                    SpacerVertical(height: 8),
                    Text(
                      data.title ?? '',
                      style: styleBaseBold(fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
