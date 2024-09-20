import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:stocks_news_new/providers/stockAnalysis/provider.dart';
import 'package:stocks_news_new/utils/theme.dart';
import 'package:stocks_news_new/widgets/spacer_horizontal.dart';
import '../../../modals/msAnalysis/radar_chart.dart';
import '../../../utils/colors.dart';
import '../widget/bottom_sheet.dart';

class MsStockScoreItem extends StatelessWidget {
  const MsStockScoreItem({super.key});

  @override
  Widget build(BuildContext context) {
    MSAnalysisProvider provider = context.watch<MSAnalysisProvider>();

    final selectedIndex = provider.showScoreComplete ? 0 : 1;
    MsRadarChartRes? selectedScore =
        provider.completeData?.score?[selectedIndex];
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ThemeColors.greyBorder.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "Stock Score",
                          style: stylePTSansBold(fontSize: 20),
                        ),
                        const SpacerHorizontal(width: 10),
                        GestureDetector(
                          onTap: () {
                            msShowBottomSheet();
                          },
                          child: const Icon(
                            Icons.info_rounded,
                            size: 20,
                            color: ThemeColors.greyBorder,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        CircularPercentIndicator(
                          radius: 15,
                          lineWidth: 6,
                          animation: false,
                          percent: (selectedScore?.value?.toDouble() ?? 0) / 10,
                          rotateLinearGradient: true,
                          startAngle: 180,
                          circularStrokeCap: CircularStrokeCap.round,
                          linearGradient: const LinearGradient(
                            colors: [
                              Color(0xFFFF1100),
                              Colors.orange,
                              Colors.yellow,
                              Color(0xFF00FF08),
                            ],
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        const SpacerHorizontal(width: 5),
                        Text(
                          "${selectedScore?.value ?? 0}",
                          style: stylePTSansBold(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: ThemeColors.greyBorder,
              height: 0,
            ),
            Container(
              decoration: BoxDecoration(
                color: ThemeColors.greyBorder.withOpacity(0.4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  provider.completeData?.score?.length ?? 0,
                  (index) {
                    MsRadarChartRes? data =
                        provider.completeData?.score?[index];
                    return Flexible(
                      child: IntrinsicHeight(
                        child: GestureDetector(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  data?.label ?? "",
                                  textAlign: TextAlign.center,
                                  style: styleGeorgiaBold(
                                    color: (provider.showScoreComplete &&
                                                index == 0) ||
                                            (!provider.showScoreComplete &&
                                                index == 1)
                                        ? ThemeColors.white
                                        : ThemeColors.greyText,
                                  ),
                                ),
                              ),
                              if (index <
                                  (provider.completeData?.score?.length ?? 0) -
                                      1)
                                Switch(
                                  value: provider.showScoreComplete,
                                  inactiveThumbColor: ThemeColors.white,
                                  inactiveTrackColor: ThemeColors.greyBorder,
                                  activeColor: Colors.orange,
                                  onChanged: provider.onChangeCompleteScore,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
