import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/utils/colors.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import 'package:stocks_news_new/widgets/spacer_vertical.dart';
import '../../../modals/msAnalysis/complete.dart';
import '../widget/title_tag.dart';
import 'detail.dart';
import 'item.dart';

class MsSwotAnalysis extends StatelessWidget {
  const MsSwotAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    final Shader textGradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 247, 204, 86),
        Color.fromARGB(255, 245, 143, 47)
      ],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 250.0, 60.0));

    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();
    MsTextRes? text = provider.completeData?.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MsTitle(
          title: text?.swot?.title,
          subtitle: text?.swot?.subTitle,
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 53, 53, 53),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  children: [
                    MsSwotItem(
                      label: 'Strength',
                      value:
                          '${provider.completeData?.swotAnalysis?.strengths?.length ?? 0}',
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
                      value:
                          '${provider.completeData?.swotAnalysis?.weaknesses?.length ?? 0}',
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
                      value:
                          '${provider.completeData?.swotAnalysis?.opportunity?.length ?? 0}',
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
                      value:
                          '${provider.completeData?.swotAnalysis?.threats?.length ?? 0}',
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
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MsSwotAnalysisDetail(),
              ),
            );
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 36, 32, 32),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'View details',
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        foreground: Paint()..shader = textGradient,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.orange,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
