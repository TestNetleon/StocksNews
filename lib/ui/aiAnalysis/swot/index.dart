import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/base_list_divider.dart';
import 'package:stocks_news_new/ui/base/bottom_sheet.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../models/ai_analysis.dart';
import '../../../utils/constants.dart';
import 'item.dart';

enum SwotEnum { strength, weakness, opportunity, threat }

class AISwot extends StatelessWidget {
  final AIswotRes? swot;
  const AISwot({super.key, this.swot});

  _openSheet(SwotEnum type) {
    List<String> data = [];
    String? title;
    switch (type) {
      case SwotEnum.strength:
        title = 'Strength';
        data = swot?.data?.strengths ?? [];
        break;
      case SwotEnum.weakness:
        title = 'Weakness';
        data = swot?.data?.weaknesses ?? [];
        break;
      case SwotEnum.opportunity:
        title = 'Opportunity';
        data = swot?.data?.opportunity ?? [];
        break;
      case SwotEnum.threat:
        title = 'Threat';
        data = swot?.data?.threats ?? [];
        break;
    }
    if (data.isEmpty) return;
    BaseBottomSheet().bottomSheet(
      barrierColor: Colors.transparent.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseHeading(title: title),
          BaseListDivider(),
          SpacerVertical(height: 10),
          Column(
            children: List.generate(
              data.length,
              (index) {
                return Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(bottom: Pad.pad16),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 2, right: 10),
                        child: Icon(
                          Icons.circle,
                          color: ThemeColors.black,
                          size: 9,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          data[index],
                          style: styleBaseRegular(color: ThemeColors.neutral40),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SpacerVertical(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final Shader textGradient = const LinearGradient(
    //   colors: [
    //     Color.fromARGB(255, 247, 204, 86),
    //     Color.fromARGB(255, 245, 143, 47)
    //   ],
    // ).createShader(const Rect.fromLTWH(0.0, 0.0, 250.0, 60.0));

    AIswotDataRes? data = swot?.data;

    return Container(
      padding: EdgeInsets.only(
        left: Pad.pad16,
        right: Pad.pad16,
        top: Pad.pad32,
        bottom: Pad.pad10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseHeading(
            title: swot?.title,
            margin: EdgeInsets.only(
              bottom: Pad.pad10,
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  MsSwotItem(
                    onTap: () => _openSheet(SwotEnum.strength),
                    label: 'Strength',
                    value: '${data?.strengths?.length ?? 0}',
                    keyword: 'S',
                    bottom: 0,
                    right: 0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    childRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  SpacerHorizontal(width: 10),
                  MsSwotItem(
                    onTap: () => _openSheet(SwotEnum.weakness),
                    label: 'Weakness',
                    color: Colors.orange,
                    value: '${data?.weaknesses?.length ?? 0}',
                    keyword: 'W',
                    bottom: 0,
                    left: 0,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    childRadius: BorderRadius.only(
                      topRight: Radius.circular(100),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                ],
              ),
              SpacerVertical(height: 10),
              Row(
                children: [
                  MsSwotItem(
                    onTap: () => _openSheet(SwotEnum.opportunity),
                    label: 'Opportunity',
                    value: '${data?.opportunity?.length ?? 0}',
                    keyword: 'O',
                    top: 0,
                    right: 0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    childRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(100),
                    ),
                  ),
                  SpacerHorizontal(width: 10.0),
                  MsSwotItem(
                    onTap: () => _openSheet(SwotEnum.threat),
                    label: 'Threat',
                    color: ThemeColors.sos,
                    value: '${data?.threats?.length ?? 0}',
                    keyword: 'T',
                    left: 0,
                    top: 0,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    childRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
