import 'package:flutter/material.dart';
import 'package:stocks_news_new/ui/base/heading.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../models/ai_analysis.dart';
import '../../../utils/constants.dart';
import 'item.dart';

class AISwot extends StatelessWidget {
  final AIswotRes? swot;
  const AISwot({super.key, this.swot});

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
